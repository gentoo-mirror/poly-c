# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit toolchain-funcs

DESCRIPTION="command-line kennyfier"
HOMEPAGE="http://www.colino.net/geek/"
SRC_URI="http://www.colino.net/geek/bin/${PN}.c"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""
DEPEND="virtual/libc"
S="${WORKDIR}"
RESTRICT="nomirror"

src_unpack() {
	cp "${DISTDIR}"/${A} "${S}"
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} ${PN}.c
}

src_install() {
	dobin ${PN}
}
