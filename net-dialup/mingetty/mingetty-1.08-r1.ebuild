# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: e82c8c597b4b26323f32b4f9613ad0b5b7452fef $

EAPI=6

inherit toolchain-funcs eutils

DESCRIPTION="A compact getty program for virtual consoles only"
HOMEPAGE="https://sourceforge.net/projects/mingetty"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE="unicode"

PATCHES=(
	"${FILESDIR}"/${PN}-1.08-openlog.patch
	"${FILESDIR}"/${PN}-1.08-check_chroot_chdir_nice.patch
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

src_install() {
	dodir /sbin /usr/share/man/man8
	emake DESTDIR="${D}" install
}
