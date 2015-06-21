# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit poly-c_ebuilds

DESCRIPTION="VARMon is a GNU licensed RAID manipulation / management tool for DAC960/DAC1164 controller family"
HOMEPAGE="http://julien.danjou.info/projects/varmon"
#SRC_URI="http://julien.danjou.info/${PN}/${P}.tar.gz"
COMMIT_ID="dc44dfdc58a2cf2f393e5c24f9b227e2fdde1e35"
SRC_URI="http://git.naquadah.org/?p=varmon.git;a=snapshot;h=${COMMIT_ID};sf=tgz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""

S="${WORKDIR}/${PN}-${COMMIT_ID:0:7}"

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
