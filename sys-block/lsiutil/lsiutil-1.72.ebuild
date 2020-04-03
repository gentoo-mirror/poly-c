# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 2184a1651c3e4166cba1197b4d935e8547b261e5 $

EAPI=7

inherit toolchain-funcs

DESCRIPTION="LSI Logic Fusion MPT Command Line Interface management tool"
HOMEPAGE="https://github.com/mute55/LSIUtil"
SRC_URI="https://ftp.icm.edu.pl/packages/LSI/sw/${P}.tar.gz"
LICENSE="LSI"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/help2man"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}/${PN}-1.72-version_option.patch" )

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} ${PN}.c -o ${PN} || die

	help2man -s 8 -N -h -h -v -V -o ${PN}.8 ${PN} || die
}

src_install() {
	dosbin ${PN}
	doman ${PN}.8
}
