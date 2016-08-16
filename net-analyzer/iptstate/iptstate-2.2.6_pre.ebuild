# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs poly-c_ebuilds

DESCRIPTION="IP Tables State displays states being kept by iptables in a top-like format"
HOMEPAGE="http://www.phildev.net/iptstate/"
SRC_URI="https://github.com/jaymzh/iptstate/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"

RDEPEND="
	>=sys-libs/ncurses-5.7-r7:0=
	>=net-libs/libnetfilter_conntrack-0.0.50
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.2.5-gentoo.patch
	tc-export CXX PKG_CONFIG
}

src_install() {
	emake PREFIX="${D}"/usr install
	dodoc BUGS Changelog CONTRIB README.md WISHLIST
}
