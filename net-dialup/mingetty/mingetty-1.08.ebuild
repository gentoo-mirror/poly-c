# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/mingetty/mingetty-1.08.ebuild,v 1.9 2014/08/10 20:56:06 slyfox Exp $

inherit toolchain-funcs eutils

DESCRIPTION="A compact getty program for virtual consoles only"
HOMEPAGE="http://sourceforge.net/projects/mingetty"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="unicode"

src_unpack() {
	unpack ${A}

	if use unicode ; then
		epatch "${FILESDIR}"/${P}-utf8.patch
	else
		epatch "${FILESDIR}"/${P}-Allow-login-name-up-to-LOGIN_NAME_MAX-length.patch \
			"${FILESDIR}"/${P}-Clear-scroll-back-buffer-on-clear-screen.patch
	fi
	epatch "${FILESDIR}"/${P}-openlog.patch \
		"${FILESDIR}"/${P}-check_chroot_chdir_nice.patch \
		"${FILESDIR}"/${P}-limit_tty_length.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS} -Wall -W -pipe -D_GNU_SOURCE" CC="$(tc-getCC)" || die "compile failed"
}

src_install () {
	dodir /sbin /usr/share/man/man8
	emake DESTDIR="${D}" install || die "install failed"
}
