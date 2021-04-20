# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# polyc_ebuilds.eclass: eclass for all _pre ebuilds created by me, Polynomial-C

MY_PV="${PV%_*}"
MY_P="${PN}-${MY_PV}"

S="${WORKDIR}/${MY_P}"

RESTRICT="mirror"

try_apply() {
	[[ $# -gt 0 ]] || die "No patch files given."

	if nonfatal eapply --dry-run ${@} &>/dev/null ; then
		eapply ${@}
	fi
}

preplace() {
	local pdest rpatch
	if [[ -n "${1}" ]] ; then
		pdest="${1}"
	else
		pdest="patches"
	fi
	if [[ "$(declare -p replace_patches 2>&-)" == "declare -a"* ]] ; then
		for rpatch in ${replace_patches[@]} ; do
			cp "${FILESDIR}/${rpatch}" "${WORKDIR}/${pdest}" || die
		done
	else
		die "replace_patches is not an array"
	fi
}
