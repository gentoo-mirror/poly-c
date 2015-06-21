# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils games poly-c_ebuilds

DESCRIPTION="A game similar to Super Mario Bros."
HOMEPAGE="http://super-tux.sourceforge.net"
SRC_URI="http://supertux.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="opengl curl debug"

RDEPEND="dev-games/physfs
	dev-libs/boost
	media-libs/glew
	media-libs/libsdl[joystick]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl-image[png,jpeg]
	x11-libs/libXt
	curl? ( >=net-misc/curl-7.21.7 )
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e "/Icon=/s/supertux.png/supertux2/" \
		-e "/Categories=/s/=/=Application;/" \
		-i supertux2.desktop || die
}

src_configure() {
	local mycmakeargs="-DWERROR=OFF \
		-DINSTALL_SUBDIR_BIN=games/bin \
		-DINSTALL_SUBDIR_DOC=share/doc/${P} \
		$(cmake-utils_use_enable opengl OPENGL) \
		$(cmake-utils_use_enable debug SQDBG) \
		$(cmake-utils_use debug DEBUG)"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	pushd "${D}/usr/share/pixmaps" &>/dev/null || die
	local ext
	for ext in png xpm ; do
		mv ${PN}{,2}.${ext} || die
	done
	popd &>/dev/null || die

	prepgamesdirs
}
