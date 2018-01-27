# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dhewm/${PN}.git"
else
	[[ ${PV} = *_rc* ]] || \
	KEYWORDS="~amd64 ~x86"
	MY_PV="${PV/_rc/_RC}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/dhewm/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="A Doom 3 GPL source modification."
HOMEPAGE="https://github.com/dhewm/dhewm3"

LICENSE="GPL-3"
SLOT="0"
IUSE="curl dedicated +sdl2"

DEPEND="
		media-libs/libogg
		media-libs/libvorbis
		media-libs/openal
		sys-libs/zlib
		virtual/jpeg:*
		curl? ( net-misc/curl )
		!sdl2? ( >=media-libs/libsdl-1.2[opengl,video] )
		sdl2? ( media-libs/libsdl2[opengl,video] )
"
RDEPEND="${DEPEND}"

src_prepare() {
		CMAKE_USE_DIR="${S}/neo"
		cmake-utils_src_prepare
}

src_configure() {
		local mycmakeargs=(
				"-DBASE=$(usex !dedicated)"
				"-DCORE=$(usex !dedicated)"
				"-DD3XP=$(usex !dedicated)"
				"-DDEDICATED=ON"
				"-DSDL2=$(usex sdl2)"
		)
		cmake-utils_src_configure
}

#src_install() {
#		dodir "/usr/share/${PN}"
#		cmake-utils_src_install
#}

pkg_postinst() {
		einfo "Install game data files to \"${ROOT%/}/usr/share/${PN}\" ."
		ewarn "${PN} is only compatible with Doom 3 (/mod) data files."
}
