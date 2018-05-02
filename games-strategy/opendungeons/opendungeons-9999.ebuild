# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils desktop

MY_PN=OpenDungeons

DESCRIPTION="An open source, real time strategy game based on the Dungeon Keeper series"
HOMEPAGE="http://opendungeons.github.io/"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenDungeons/OpenDungeons.git"
else
	SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
IUSE=""

RDEPEND=">=dev-games/cegui-0.8.0[ogre,opengl]
	>=dev-games/ogre-1.9.0:=[freeimage,ois,opengl]
	dev-games/ois
	dev-libs/boost:=
	media-libs/freetype:2
	media-libs/glew:=
	>=media-libs/libsfml-2
	media-libs/libsndfile
	media-libs/openal
	virtual/jpeg
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CMAKE_IN_SOURCE_BUILD=1

src_prepare() {
	default
	sed '/-Werror/d' -i CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DOD_DATA_PATH=/usr/share/${MY_PN}
		-DOD_BIN_PATH=/usr/bin/
		-DOD_SHARE_PATH=/usr/share
		)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon "${FILESDIR}"/${PN}.svg
	make_desktop_entry ${MY_PN} ${PN} ${PN}
}
