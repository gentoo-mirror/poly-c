# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 193b66eeb7f0ed9e34af0ef294b8dc2fb332f6de $

EAPI=5
[[ ${PV} == 9999 ]] && SCM="autotools git-r3"
inherit games ${SCM}
unset SCM

DESCRIPTION="OpenSource 2D MMORPG client for Evol Online and The Mana World"
HOMEPAGE="http://manaplus.evolonline.org"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ManaPlus/ManaPlus.git"
else
	SRC_URI="http://download.evolonline.org/manaplus/download/${PV}/manaplus-${PV}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="mumble nls opengl pugixml +sdl2 test"

RDEPEND="
	>=dev-games/physfs-1.0.0
	media-fonts/dejavu
	media-fonts/liberation-fonts
	media-fonts/mplus-outline-fonts
	media-fonts/wqy-microhei
	media-libs/libpng:0=
	net-misc/curl
	sys-libs/zlib
	x11-apps/xmessage
	x11-libs/libX11
	x11-misc/xdg-utils
	mumble? ( media-sound/mumble )
	nls? ( virtual/libintl )
	opengl? ( virtual/opengl )
	pugixml? ( dev-libs/pugixml )
	!pugixml? ( dev-libs/libxml2 )
	sdl2? (
		media-libs/libsdl2[X,opengl?,video]
		media-libs/sdl2-gfx
		media-libs/sdl2-image[png]
		media-libs/sdl2-mixer[vorbis]
		media-libs/sdl2-net
		media-libs/sdl2-ttf
	)
	!sdl2? (
		media-libs/libsdl[X,opengl?,video]
		media-libs/sdl-gfx
		media-libs/sdl-image[png]
		media-libs/sdl-mixer[vorbis]
		media-libs/sdl-net
		media-libs/sdl-ttf
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	fi
}

src_configure() {
	CONFIG_SHELL=/bin/bash \
	egamesconf \
		--without-internalsdlgfx \
		--localedir=/usr/share/locale \
		--prefix="/usr" \
		--bindir="${GAMES_BINDIR}" \
		$(use_with mumble) \
		$(use_enable nls) \
		$(use_with opengl) \
		--enable-libxml=$(usex pugixml pugixml libxml ) \
		$(use_with sdl2) \
		$(use_enable test unittests)
}

src_install() {
	default
	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusans-bold.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusans.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSansMono-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusansmono-bold.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSansMono.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusansmono.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSerifCondensed-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavuserifcondensed-bold.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSerifCondensed.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavuserifcondensed.ttf
	dosym /usr/share/fonts/liberation-fonts/LiberationMono-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/liberationsansmono-bold.ttf
	dosym /usr/share/fonts/liberation-fonts/LiberationMono-Regular.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/liberationsansmono.ttf
	dosym /usr/share/fonts/liberation-fonts/LiberationSans-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/liberationsans-bold.ttf
	dosym /usr/share/fonts/liberation-fonts/LiberationSans-Regular.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/liberationsans.ttf
	dosym /usr/share/fonts/mplus-outline-fonts/mplus-1p-bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/mplus-1p-bold.ttf
	dosym /usr/share/fonts/mplus-outline-fonts/mplus-1p-regular.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/mplus-1p-regular.ttf
	dosym /usr/share/fonts/wqy-microhei/wqy-microhei.ttc "${GAMES_DATADIR}"/${PN}/data/fonts/wqy-microhei.ttf

	prepgamesdirs
}

src_test() {
	make check
}
