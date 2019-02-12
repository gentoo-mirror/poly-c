# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GENTOO_DEPEND_ON_PERL="no"

inherit ltprune perl-module poly-c_ebuilds

# Keep for _rc compability
REAL_P="${MY_P/_/-}"

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="https://irssi.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${MY_PV/_/-}/${REAL_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+perl selinux socks5 +proxy libressl"

COMMON_DEPEND="
	sys-libs/ncurses:0=
	>=dev-libs/glib-2.6.0
	dev-libs/libutf8proc
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
	perl? ( dev-lang/perl:= )
	socks5? ( >=net-proxy/dante-1.1.18 )"

DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig"

RDEPEND="
	${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-irc )
	perl? ( !net-im/silc-client )"

RESTRICT="test"

S="${WORKDIR}/${REAL_P}"

src_configure() {
	econf \
		--with-perl-lib=vendor \
		--enable-true-color \
		$(use_with proxy) \
		$(use_with perl) \
		$(use_with socks5 socks)
}

src_install() {
	default
	use perl && perl_delete_localpod
	prune_libtool_files --modules
}
