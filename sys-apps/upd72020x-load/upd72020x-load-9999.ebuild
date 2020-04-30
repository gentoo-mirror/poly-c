# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 2184a1651c3e4166cba1197b4d935e8547b261e5 $

EAPI=7

inherit systemd toolchain-funcs

DESCRIPTION="Firmware loader for Renesas uPD72020x USB 3.0 chipsets"
HOMEPAGE="https://github.com/markusj/upd72020x-load"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/markusj/upd72020x-load.git"
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi
LICENSE=""
SLOT="0"

IUSE=""

PATCHES=(
	"${FILESDIR}/${PN}-build_fixes.patch"
)

src_compile() {
	tc-export CC
	default
}

src_install() {
	dosbin ${PN} upd72020x-check-and-init
	systemd_dounit systemd/upd72020x-fwload.service
}
