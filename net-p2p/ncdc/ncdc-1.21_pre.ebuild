# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs poly-c_ebuilds

DESCRIPTION="ncurses directconnect client"
HOMEPAGE="https://dev.yorhel.nl/ncdc"
SRC_URI="https://dev.yorhel.nl/download/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="geoip"

RDEPEND="app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/glib:2
	net-libs/gnutls
	sys-libs/ncurses:0[unicode]
	sys-libs/zlib
	geoip? ( dev-libs/geoip )"
DEPEND="${RDEPEND}
	dev-util/makeheaders
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${MY_P}-tinfo.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with geoip)
}

src_compile() {
	emake AR="$(tc-getAR)"
}