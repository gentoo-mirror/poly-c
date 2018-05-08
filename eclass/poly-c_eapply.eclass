# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# polyc_eapply.eclass: eclass for all _pre ebuilds cr

inherit poly-c_ebuilds

try_apply() {
	[[ $# -gt 0 ]] || die "No patch files given."

	if nonfatal eapply --dry-run ${@} &>/dev/null ; then
		eapply ${@}
	fi
}
