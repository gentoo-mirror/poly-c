# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 77337142ec368ef43c179461f5ca0beb09d5cd21 $

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="Diablo build for modern operating systems"
HOMEPAGE="https://github.com/diasurgical/devilutionX"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/diasurgical/devilutionX.git"
else
	SRC_URI="https://github.com/diasurgical/devilutionX/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="-* ~amd64 ~x86"
fi

LICENSE="public-domain"
SLOT="0"

IUSE="debug"

RDEPEND="
	dev-libs/libsodium[abi_x86_32]
	media-libs/libsdl2[abi_x86_32]
	media-libs/sdl2-mixer[abi_x86_32]
	media-libs/sdl2-ttf[abi_x86_32]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	if use amd64 ; then
		multilib_toolchain_setup x86
		append-cflags -m32
		append-cxxflags -m32
	fi

	local mycmakeargs=(
		-DBINARY_RELEASE=ON
		-DDEBUG="$(usex debug)"
	)
	cmake-utils_src_configure
}

src_install() {
	dobin ${BUILD_DIR}/${PN}
}
