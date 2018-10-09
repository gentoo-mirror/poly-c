# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Simple SDDM theme inspired on FBSD SLiM theme"
HOMEPAGE="https://bitbucket.org/rigoletto-freebsd/sddm-gentoo-black-theme"

if [[ "${PV}" != 9999 ]] ; then
	inherit vcs-snapshot
	SRC_URI="https://bitbucket.org/rigoletto-freebsd/sddm-gentoo-black-theme/get/${PV}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/rigoletto-freebsd/sddm-gentoo-black-theme.git"
fi

LICENSE="CC-BY-SA-3.0"
SLOT="0"
IUSE=""

RDEPEND="x11-misc/sddm"

src_install() {
	local DOCS=( doc/AUTHORS COPYING README.md doc/TRADEMARKS doc/CHANGELOG )
	einstalldocs

	cd src || die

	local target="/usr/share/sddm/themes/${PN}"
	dodir ${target}
	insinto ${target}
	doins *	
}
