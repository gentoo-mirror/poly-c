# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils poly-c_ebuilds

DESCRIPTION="VARMon is a GNU licensed RAID manipulation / management tool for DAC960/DAC1164 controller family"
HOMEPAGE="http://julien.danjou.info/projects/varmon"
#SRC_URI="http://julien.danjou.info/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/jd/varmon/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
}

src_install() {
	exeinto /sbin
	doexe ${PN}
	dodoc README{,.LINUX26}
	insinto /usr/share/doc/${PF}
	doins USAGE.pdf
}

pkg_postinst() {
	einfo
	einfo "You can find a quite good documentation in"
	einfo "/usr/doc/${P}/USAGE.pdf"
	einfo
}
