# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
inherit multiprocessing

MY_P=${PN}-$(ver_cut 1-2).beta
DESCRIPTION="city/country simulation game for X and opengl"
HOMEPAGE="https://sourceforge.net/projects/lincity-ng.berlios/"
SRC_URI="mirror://sourceforge/lincity-ng.berlios/${MY_P}.tar.bz2"

LICENSE="GPL-2 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="virtual/opengl
	sys-libs/zlib
	dev-libs/libxml2
	media-libs/libsdl[sound,joystick,opengl,video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	media-libs/sdl-gfx
	dev-games/physfs"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/ftjam"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_compile() {
	jam -q -dx -j $(makeopts_jobs) || die "jam failed"
}

src_install() {
	jam -sDESTDIR="${D}" \
		 -sappdocdir="/usr/share/doc/${PF}" \
		 -sapplicationsdir="/usr/share/applications" \
		 -spixmapsdir="/usr/share/pixmaps" \
		 install \
		 || die "jam install failed"
	rm "${ED}"/usr/share/doc/${PF}/COPYING* || die
}