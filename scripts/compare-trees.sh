#!/bin/bash

# deprecated
#PORTDIR="$(portageq envvar PORTDIR)"
#PORTDIR="$(portageq get_repo_path / gentoo)"
PORTDIR="/home/polynomial-c/gentoo"
OVERLAYDIR="/usr/local/portage"
TMPDIR="$(mktemp -d /tmp/portage_comp_XXXXXXXXXX)"

case $1 in
	-a|aux)
		for mydir in $(find ${OVERLAYDIR} -type d -name files | sort -V) ; do 
			for fle in $(find ${mydir} -type f) ; do
				test -f ${fle/${OVERLAYDIR}/${PORTDIR}} && colordiff -u ${fle} ${fle/${OVERLAYDIR}/${PORTDIR}} | less -c --tilde
			done
		done
	;;
	-f|full)
		for fle in $(find ${OVERLAYDIR} -type f | grep -Ev "Manifest|ChangeLog|package.mask|metadata" | sort -V) ; do
			if [ -f "${fle/${OVERLAYDIR}/${PORTDIR}}" ] ; then
				colordiff -u ${fle} ${fle/${OVERLAYDIR}/${PORTDIR}} | less -c --tilde
			else
				echo "${fle/${OVERLAYDIR}/${PORTDIR}} not found" | less
			fi
		done
	;;
	-h|--help)
		echo "-a|aux	Compare only auxiliary files"
		echo "-f|full	Compare all files in overlay"
		exit 0
	;;
	*)
		for fle in $(find ${OVERLAYDIR} -type f -name "*.ebuild" | sort -V) ; do
			#sudo -n -u polynomial-c /home/polynomial-c/bin/re-checkout_ebuild.sh ${fle/${OVERLAYDIR}/${PORTDIR}} || continue
			if [[ -f ${fle/${OVERLAYDIR}/${PORTDIR}} ]] ; then
				if sed -n '3p' ${fle/${OVERLAYDIR}/${PORTDIR}} | grep -q '^# $Id' ; then
					sed '3d' ${fle/${OVERLAYDIR}/${PORTDIR}} > "${TMPDIR}/${fle##*/}"
				else
					cp ${fle/${OVERLAYDIR}/${PORTDIR}} "${TMPDIR}/${fle##*/}"
				fi
				sed "3i # \$Id: $(git hash-object ${fle/${OVERLAYDIR}/${PORTDIR}}) \$" -i "${TMPDIR}/${fle##*/}"
				colordiff -u "${fle}" "${TMPDIR}/${fle##*/}" | less -c --tilde
				#rm -f "${TMPDIR}/${fle##*/}"
			fi
		done
	;;
esac

rm "${TMPDIR}" -r || echo "Tempdir needs to be cleaned manually!"

exit 0
