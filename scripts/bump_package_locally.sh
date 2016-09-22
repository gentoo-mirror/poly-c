#!/bin/bash

SOURCE_EBUILD="${1}"
TARGET_VERSION="${2}"
IS_POLYC_EBUILD="${3:-true}"

ECLASS_ADDON="${4:-poly-c_ebuilds}"
OVERLAY_NAME="${5:-poly-c}"
#PORTDIR="$(portageq get_repo_path / gentoo)"

if [[ ! -f "${SOURCE_EBUILD}" ]] ; then
	printf '%s\n' "First argument is not a file."
	exit 1
fi	
if ! [[ "${SOURCE_EBUILD}" =~ .*\.ebuild$ ]] ; then
	printf '%s\n' "First argument is not an ebuild."
	exit 2
fi
if [[ -z "${TARGET_VERSION}" ]] ; then
	printf '%s\n' "Second argument is not a version."
	exit 3
fi

case "${IS_POLYC_EBUILD}" in
	false|true)
		:;
	;;
	*)
		printf '%s\n' "Third argument must be \"true\" or \"false\"."
		exit 4
	;;
esac

if [[ -z "${OVERLAY_NAME}" ]] ; then
	printf '%s\n' "Please specify an overlay name."
fi
OVERLAYDIR="$(portageq get_repo_path / ${OVERLAY_NAME})"

#if [[ ! -d "${PORTDIR}" ]] ; then
#	printf '%s' "PORTDIR is empty or no directory."
#	exit 5
#fi

if [[ ! -d "${OVERLAYDIR}" ]] ; then
	printf '%s\n' "OVERLAYDIR is empty or no directory."
	exit 6
fi

if ${IS_POLYC_EBUILD} && [[ ! -f "${OVERLAYDIR}/eclass/${ECLASS_ADDON}.eclass" ]] ; then
	printf '%s\n' "Cannot find ${ECLASS_ADDON} eclass"
	exit 7
fi

SOURCE_DIR="${SOURCE_EBUILD%/*/*/*}"
FULL_PACKAGE="${SOURCE_EBUILD/${SOURCE_DIR}\/}"
CATEGORY="${FULL_PACKAGE%%/*}"
PACKAGE="${FULL_PACKAGE##*/}"
TARGET_PACKAGE="$(qatom -F "%{CATEGORY}/%{PN}/%{PN}-${TARGET_VERSION}.ebuild" ${CATEGORY}/${PACKAGE})"
TARGET_EBUILD="${OVERLAYDIR}/${TARGET_PACKAGE}"
TARGET_DIR="${TARGET_EBUILD%/*}"

if [[ ! -d "${TARGET_DIR}" ]] ; then
	mkdir -p "${TARGET_DIR}" || exit 8
fi

cp "${SOURCE_EBUILD}" "${TARGET_EBUILD}" || exit 9

if ${IS_POLYC_EBUILD} ; then
	ekeyword \~all "${TARGET_EBUILD}" &>/dev/null || exit 10

	sed \
		-e 's@${PV}@${MY_PV}@g;s@${P}@${MY_P}@g' \
		-e 's@${PV/@${MY_PV/@g;s@${P/@${MY_P/@g' \
		-i "${TARGET_EBUILD}" || exit 11

	if ! grep -q "^inherit" "${TARGET_EBUILD}" ; then
		if grep -q "^EAPI" "${TARGET_EBUILD}" ; then
			sed \
				-e "/^EAPI=/a\\\\ninherit ${ECLASS_ADDON}" \
				-i "${TARGET_EBUILD}" || exit 11
		else
			sed \
				-e "/^# \\\$Id\\\$\$/a\\\\ninherit ${ECLASS_ADDON}" \
				-i "${TARGET_EBUILD}" || exit 12
		fi
	elif grep -q '^inherit.*\\$' "${TARGET_EBUILD}" ; then
		sed \
			-e "/^inherit/s@[[:space:]]\+\\\\\$@ ${ECLASS_ADDON}&@" \
			-i "${TARGET_EBUILD}" || exit 13
	else
		sed \
			-e "/^inherit/s@\$@ ${ECLASS_ADDON}@" \
			-i "${TARGET_EBUILD}" || exit 14
	fi
fi

if grep -Fq FILESDIR ${SOURCE_EBUILD} ; then
	retval=0
	AUX_FILES=( $(\
		grep -F FILESDIR "${SOURCE_EBUILD}" \
			| egrep -v '^[[:space:]]*#|\$\(' \
			| sed \
				-e 's@.*FILESDIR["}/]*\([[:alnum:]\${}/\.,_-]\+\).*@\1@' \
				-e "s@\${PN}@$(qatom -F '%{PN}' ${PACKAGE})@g" \
				-e "s@\${P}@$(qatom -F '%{PN}-%{PV}' ${PACKAGE})@g" \
	) )
	printf '%s\n' "AUX_FILES: ${AUX_FILES[@]}"
	if [[ -n "${AUX_FILES[@]}" ]] ; then
		target_aux_dir="${TARGET_EBUILD%/*}/files"
		mkdir -p "${target_aux_dir}" || exit 15
		for file in $(eval echo ${AUX_FILES[@]}) ; do
			if grep -q "/" <<< ${file} ; then
				if [[ ! -d "${target_aux_dir}/${file%/*}" ]] ; then
					mkdir -p "${target_aux_dir}/${file%/*}" || exit 16
				fi
				cp "${SOURCE_EBUILD%/*}/files/${file}" "${target_aux_dir}/${file%/*}" \
					|| { retval=1 ; continue ; }
			else
				cp "${SOURCE_EBUILD%/*}/files/${file}" "${target_aux_dir}" \
					|| { retval=1 ; continue ; } 
			fi
		done
		[[ ${retval} -ne 0 ]] && exit 17
	fi
fi

nice ebuild "${TARGET_EBUILD}" manifest clean prepare clean
