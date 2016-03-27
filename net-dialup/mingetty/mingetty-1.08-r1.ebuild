# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 35044001d78b8b3a197d4f70f3a224a59165a059 $

EAPI=6

inherit toolchain-funcs eutils

DESCRIPTION="A compact getty program for virtual consoles only"
HOMEPAGE="http://sourceforge.net/projects/mingetty"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sparc ~x86"
IUSE="unicode"

PATCHES=(
	"${FILESDIR}"/${PN}-1.08-openlog.patch \
	"${FILESDIR}"/${PN}-1.08-check_chroot_chdir_nice.patch \
	"${FILESDIR}"/${PN}-1.08-limit_tty_length.patch
)

src_prepare() {
	if use unicode ; then
		eapply "${FILESDIR}"/${PN}-1.08-utf8.patch
	else
		eapply "${FILESDIR}"/${PN}-1.08-Allow-login-name-up-to-LOGIN_NAME_MAX-length.patch \
			"${FILESDIR}"/${PN}-1.08-Clear-scroll-back-buffer-on-clear-screen.patch
	fi
	default
}

src_compile() {
	emake CFLAGS="${CFLAGS} -Wall -W -pipe -D_GNU_SOURCE" CC="$(tc-getCC)"
}

src_install () {
	dodir /sbin /usr/share/man/man8
	emake DESTDIR="${D}" install
}
