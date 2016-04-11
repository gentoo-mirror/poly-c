# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils bash-completion-r1 flag-o-matic versionator poly-c_ebuilds

DESCRIPTION="Terminal multiplexer"
HOMEPAGE="http://tmux.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${MY_PV}/${MY_P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug selinux vim-syntax kernel_FreeBSD kernel_linux"

CDEPEND="
	|| (
		=dev-libs/libevent-2.0*
		>=dev-libs/libevent-2.1.5-r4
	)
	kernel_linux? ( sys-libs/libutempter )
	kernel_FreeBSD? ( || ( >=sys-freebsd/freebsd-lib-9.0 sys-libs/libutempter ) )
	sys-libs/ncurses:0="
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-screen )
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)"

DOCS=( CHANGES FAQ README TODO )

PATCHES=( "${FILESDIR}"/${PN}-2.0-flags.patch )

src_prepare() {
	# bug 438558
	# 1.7 segfaults when entering copy mode if compiled with -Os
	replace-flags -Os -O2

	# regenerate aclocal.m4 to support earlier automake versions
	rm aclocal.m4 || die

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc
		$(use_enable debug)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	#newbashcomp examples/bash_completion_tmux.sh ${PN}

	#docinto examples
	#dodoc examples/*.conf

	if use vim-syntax; then
	#	insinto /usr/share/vim/vimfiles/syntax
	#	doins examples/tmux.vim

		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}"/tmux.vim
	fi
}

pkg_postinst() {
	if ! version_is_at_least 1.9a ${REPLACING_VERSIONS:-1.9a}; then
		echo
		ewarn "Some configuration options changed in this release."
		ewarn "Please read the CHANGES file in /usr/share/doc/${PF}/"
		ewarn
		ewarn "WARNING: After updating to ${P} you will _not_ be able to connect to any"
		ewarn "older, running tmux server instances. You'll have to use an existing client to"
		ewarn "end your old sessions or kill the old server instances. Otherwise you'll have"
		ewarn "to temporarily downgrade to access them."
		echo
	fi
}
