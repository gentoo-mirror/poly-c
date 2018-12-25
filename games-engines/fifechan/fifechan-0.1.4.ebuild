# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Lightweight cross platform GUI C++ library designed for games"
HOMEPAGE="http://fifengine.github.io/fifechan/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fifengine/fifechan"
else
	SRC_URI="https://github.com/fifengine/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="allegro +opengl +sdl irrlicht"

DEPEND="
	x11-libs/libXext
	irrlicht? (
		dev-games/irrlicht
	)
	sdl? (
		media-libs/libsdl2
		media-libs/sdl-ttf
		media-libs/sdl2-image[png]
	)
	opengl? (
		virtual/opengl
		virtual/glu
	)
	allegro? (
		media-libs/allegro:0
	)
"
RDEPEND="${DEPEND}"

usx() { usex $* ON OFF; }

src_configure() {
	local mycmakeargs=(
		-DENABLE_ALLEGRO=$(usx allegro)
		-DENABLE_OPENGL=$(usx opengl)
#		-DENABLE_OPENGL_CONTRIB=$(usx opengl)
		-DENABLE_SDL=$(usx sdl)
		-DENABLE_SDL_CONTRIB=$(usx sdl)
		-DENABLE_IRRLICHT=$(usx irrlicht)
	)
	cmake-utils_src_configure
}
