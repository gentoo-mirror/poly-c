# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="zip manipulation library found in the zlib distribution"
HOMEPAGE="https://github.com/nmoinvaz/minizip"
SRC_URI="https://github.com/nmoinvaz/minizip/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ZLIB"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="bzip2 libressl lzma ssl test +zlib"

RDEPEND="
	!sys-libs/zlib[minizip]
	bzip2? ( app-arch/bzip2 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	zlib? ( sys-libs/zlib[-minizip] )
"

DEPEND="${RDEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TEST="$(usex test)"
		-DBUILD_UNIT_TEST="$(usex test)"
		-DINSTALL_INC_DIR="/usr/include/${PN}"
		-DUSE_COMPAT=ON
		-DUSE_ZLIB="$(usex zlib)"
		-DUSE_BZIP2="$(usex bzip2)"
		-DUSE_LZMA="$(usex lzma)"
		-DUSE_OPENSSL="$(usex ssl)"
	)
	cmake-utils_src_configure
}
