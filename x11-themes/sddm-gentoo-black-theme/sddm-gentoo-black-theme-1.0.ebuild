# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Simple SDDM theme inspired on FBSD SLiM theme"
HOMEPAGE="https://github.com/lebarondemerde/gentoo-black-theme"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="https://github.com/lebarondemerde/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lebarondemerde/sddm-gentoo-black-theme.git"
fi

LICENSE="CC-BY-SA-3.0"
SLOT="0"
IUSE=""

RDEPEND="x11-misc/sddm"

src_install() {
	local DOCS=( AUTHORS COPYING README.md TRADEMARKS )
	einstalldocs
	rm ${DOCS[@]} || die

	local target="/usr/share/sddm/themes/${PN}"
	dodir ${target}
	insinto ${target}
	doins *	
}
