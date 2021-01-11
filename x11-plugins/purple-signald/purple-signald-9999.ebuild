# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 77337142ec368ef43c179461f5ca0beb09d5cd21 $

EAPI=7

inherit edos2unix toolchain-funcs

MY_PN="lib${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="libpurple/Pidgin plugin for signald"
HOMEPAGE="https://github.com/hoehermann/libpurple-signald"
if [[ "${PV}" ==  9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hoehermann/libpurple-signald.git"
else
	SRC_URI="https://github.com/hoehermann/lib${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE=""
SLOT="0"

IUSE=""

RDEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	net-im/pidgin
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default
	edos2unix Makefile
	sed 's@-g -ggdb@@' -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" PKG_CONFIG="$(tc-getBUILD_PKG_CONFIG)"
}
