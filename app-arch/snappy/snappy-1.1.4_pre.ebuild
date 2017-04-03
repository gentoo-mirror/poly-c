# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools multilib-minimal poly-c_ebuilds

DESCRIPTION="A high-speed compression/decompression library by Google"
HOMEPAGE="https://github.com/google/snappy"
SRC_URI="https://github.com/google/${PN}/releases/download/${MY_PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
# Fails to build on x86
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 -x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="static-libs"

src_prepare() {
	# Avoid automagic lzo and gzip by not checking for it
	sed -i '/^CHECK_EXT_COMPRESSION_LIB/d' configure.ac || die

	# don't install unwanted files
	sed -i 's/COPYING INSTALL//' Makefile.am || die

	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--without-gflags
		--disable-gtest
		$(use_enable static-libs static)
	)

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_install_all() {
	find "${ED%/}"/usr/lib* -name '*.la' -delete || die
}
