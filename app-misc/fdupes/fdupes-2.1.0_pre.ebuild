# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs poly-c_ebuilds

DESCRIPTION="Identify/delete duplicate files residing within specified directories"
HOMEPAGE="https://github.com/adrianlopezroche/fdupes"
SRC_URI="https://github.com/adrianlopezroche/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="+ncurses"

RDEPEND="
	dev-libs/libpcre2[pcre32]
	ncurses? ( sys-libs/ncurses:0= )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-ncurses_pkgconfig.patch"
	"${FILESDIR}/${PN}-2.1.0-ncurses_keypad.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with ncurses)
}

src_compile() {
	emake CC=$(tc-getCC)
}
