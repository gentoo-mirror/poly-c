# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 2184a1651c3e4166cba1197b4d935e8547b261e5 $

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Reformat a SCSI disk with new block size"
HOMEPAGE="http://micha.freeshell.org/scsi/"
SRC_URI="http://micha.freeshell.org/scsi/${PN}-V${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/${PN}-0.2-gentoo.patch" )

src_compile() {
	emake C1="$(tc-getCC)"
}

src_install() {
	dosbin ${PN}
	dodoc README doc/{Example,scsi-generic_long}.txt
}
