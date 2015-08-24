# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://github.com/${PN}/${PN}.git"
[[ ${PV} == "9999" ]] && GIT_ECLASS="git-r3"

inherit cmake-utils games fdo-mime ${GIT_ECLASS}

DESCRIPTION="Wolfenstein: Enemy Territory 2.60b compatible client/server"
HOMEPAGE="http://www.etlegacy.com/"

if [[ ${PV} == "9999" ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV/_rc/rc}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3 RTCW-ETEULA"
SLOT="0"
IUSE="+opengl dedicated omnibot +curl +vorbis +openal +freetype lua curses autoupdate renderer2 renderer-gles ipv6 irc renderer-dynamic crouch +gettext jansson"
REQUIRED_USE="omnibot? ( x86 )"

RESTRICT="mirror"

# TODO for 2.71 Release: switch to libsdl2
# TODO 2.60 servers and omnibot require 32bit client : converto to multilib, and add dep on games-fps/enemy-territory-omnibot and (abi_x86_32 or x86)
# TODO find out which libsdl useflags we realy need to depend on
# TODO add debug use for CMAKE_BUILD_TYPE=debug

if [[ ${PV} == "9999" ]]; then
	LUADEPEND="lua? ( dev-lang/lua:5.2 )"
else
	LUADEPEND="lua? ( >=dev-lang/lua-5.1 )"
fi

UIDEPEND=">=media-libs/glew-1.10.0
	media-libs/libsdl2[sound,video,X]
	virtual/jpeg:0
	virtual/opengl
	curl? ( net-misc/curl )
	freetype? ( media-libs/freetype )
	gettext? ( sys-devel/gettext )
	jansson? ( dev-libs/jansson )
	renderer-gles? ( media-libs/mesa[gles1] )
	openal? ( media-libs/openal )
	vorbis? ( media-libs/libvorbis )
	${LUADEPEND}"

DEPEND="!games-fps/etlegacy-bin
	opengl? ( ${UIDEPEND} )
	!dedicated? ( ${UIDEPEND} )"

RDEPEND="${DEPEND}"

QA_TEXTRELS="usr/share/games/etlegacy/legacy/omni-bot/omnibot_et.so"

S="${WORKDIR}/${P/_rc/rc}"

src_configure() {
	# path and build type
	# see TODO
	mycmakeargs+=(
		"-DCMAKE_BUILD_TYPE=Release"
		"-DCMAKE_INSTALL_PREFIX=/usr"
		"-DINSTALL_DEFAULT_BASEDIR=${GAMES_DATADIR}/${PN}"
		"-DINSTALL_DEFAULT_BINDIR=${GAMES_BINDIR}"
		"-DINSTALL_DEFAULT_MODDIR=${GAMES_DATADIR}/${PN}"
	)

	# see TODO
	mycmakeargs+=(
		"-DCMAKE_LIBRARY_PATH=$(get_libdir)"
		"-DCMAKE_INCLUDE_PATH=/usr/include"
		"-DCROSS_COMPILE32=0"
	)

	# what to build
	mycmakeargs+=(
		$(cmake-utils_use_build dedicated SERVER)
		$(cmake-utils_use_build opengl CLIENT)
		"-DBUILD_MOD=1"
		"-DBUILD_MOD_PK3=1"
		"-DBUILD_PAK3_PK3=1"
	)

	# no bundled libs
	mycmakeargs+=(
		"-DBUNDLED_LIBS=0"
		"-DBUNDLED_SDL=0"
		"-DBUNDLED_CURL=0"
		"-DBUNDLED_JPEG=0"
		"-DBUNDLED_LUA=0"
		"-DBUNDLED_OGG_VORBIS=0"
		"-DBUNDLED_GLEW=0"
		"-DBUNDLED_FREETYPE=0"
		"-DBUNDLED_JANSSON=0"
	)

	# features
	mycmakeargs+=(
		$(cmake-utils_use curl FEATURE_CURL)
		$(cmake-utils_use vorbis FEATURE_OGG_VORBIS)
		$(cmake-utils_use openal FEATURE_OPENAL)
		$(cmake-utils_use freetype FEATURE_FREETYPE)
		$(cmake-utils_use lua FEATURE_LUA)
		$(cmake-utils_use irc FEATURE_IRC_CLIENT)
		$(cmake-utils_use ipv6 FEATURE_IPV6)
		$(cmake-utils_use curses FEATURE_CURSES)
		$(cmake-utils_use gettext FEATURE_GETTEXT)
	       	$(cmake-utils_use jansson FEATURE_JANSSON)
		"-DFEATURE_ANTICHEAT=1"
		"-DFEATURE_AUTOUPDATE=1"
		"-DFEATURE_CROUCH=0"
	)

	# renderers
	mycmakeargs+=(
		$(cmake-utils_use renderer2 FEATURE_RENDERER2)
		$(cmake-utils_use renderer-gles FEATURE_RENDERER_GLES)
		$(cmake-utils_use renderer-dynamic FEATURE_DYNAMIC)
	)

	# see TODO
	mycmakeargs+=(
		$(cmake-utils_use omnibot FEATURE_OMNIBOT)
		$(cmake-utils_use omnibot INSTALL_OMNIBOT)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	mkdir -p "${D}/$(games_get_libdir)/${PN}"
	mv "${D}/${GAMES_DATADIR}/${PN}/legacy/"*.so "${D}/$(games_get_libdir)/${PN}"

	local so
	for so in "${D}/$(games_get_libdir)/${PN}"/*.so ; do
	dosym "$(games_get_libdir)/${PN}/${so##*}" \
                        "${GAMES_DATADIR}/${PN}/legacy/${so##*}"
	done

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	fdo-mime_desktop_database_update

	elog "Copy genuine ET files pak0.pk3, pak1.pk3 and pak2.pk3"
	elog "to ${GAMES_DATADIR}/${PN}/etmain in order so start"
	elog "the game."
	elog
	elog "If you are using opensource drivers you should consider installing: "
	elog "    media-libs/libtxc_dxtn"
}
