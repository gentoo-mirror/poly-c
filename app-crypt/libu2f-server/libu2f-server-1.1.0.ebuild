# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 15c7230119c7c5fca0a025e3d39545b346e17dd4 $

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="Yubico Universal 2nd Factor (U2F) server C Library"
HOMEPAGE="https://developers.yubico.com/libu2f-server/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0/0.1"
KEYWORDS="amd64 x86"
IUSE="libressl static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	libressl? ( dev-libs/libressl:=[${MULTILIB_USEDEP}] )
	dev-libs/hidapi[${MULTILIB_USEDEP}]
	dev-libs/json-c:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-libs/check[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-disable-help2man-gengetopt-checks.patch"
	"${FILESDIR}/${PN}-1.1.0-jsonc014.patch"
)

src_prepare() {
	default
	eautoreconf
	touch man/u2f-server.1 || die # do not rebuild the man page
}

multilib_src_configure() {
	myeconfargs=(
		--disable-h2a # tarball already contains the manpage
		$(use_enable static-libs static)
		$(use_enable test tests)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${D}" -name '*.la' -delete || die
}
