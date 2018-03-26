# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit cmake-utils gnome2-utils unpacker versionator xdg-utils

DESCRIPTION="Wolfenstein: Enemy Territory 2.60b compatible client/server"
HOMEPAGE="http://www.etlegacy.com/"

# We need the game files from the original enemy-territory release
ET_RELEASE="2.60b"
SRC_URI="mirror://3dgamers/wolfensteinet/et-linux-${ET_RELEASE/b}.x86.run
	mirror://idsoftware/et/linux/et-linux-${ET_RELEASE/b}.x86.run
	ftp://ftp.red.telefonica-wholesale.net/GAMES/ET/linux/et-linux-${ET_RELEASE/b}.x86.run"

if [[ ${PV} = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/${PN}/${PN}.git"
else
	SRC_URI+=" https://github.com/${PN}/${PN}/archive/v${PV/_rc/rc}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3 RTCW-ETEULA"
SLOT="0"
IUSE="+opengl dedicated omnibot +curl +vorbis +openal +freetype lua curses autoupdate renderer2 renderer-gles ipv6 irc +gettext jansson"
REQUIRED_USE="omnibot? ( x86 )"

RESTRICT="mirror"

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

src_unpack() {
	if [[ "${PV}" = 9999 ]] ; then
		git-r3_src_unpack
	else
		default
	fi
	mkdir et && cd et || die
	unpack_makeself et-linux-${ET_RELEASE/b}.x86.run
}

src_prepare() {
	default
	if [[ "${PV}" != 9999 ]] ; then
		sed -e "/^set(ETLEGACY_VERSION_MINOR/s@[[:digit:]]\+@$(get_version_component_range 2)@" \
			-i cmake/ETLVersion.cmake || die
	fi
	sed -e 's@[-_]dirty@@' -i cmake/ETLVersion.cmake || die
}

src_configure() {
	mycmakeargs=(
		# path and build type
		#-DCMAKE_BUILD_TYPE="Release"
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DINSTALL_DEFAULT_BASEDIR="/usr/share/${PN}"
		-DINSTALL_DEFAULT_BINDIR="/usr/bin"
		-DINSTALL_DEFAULT_MODDIR="/usr/share/${PN}"

		-DCMAKE_LIBRARY_PATH="/usr/$(get_libdir)"
		-DCMAKE_INCLUDE_PATH="/usr/include"
		-DCROSS_COMPILE32="0"
		# what to build
		-DBUILD_CLIENT="$(usex opengl)"
		-DBUILD_MOD="1"
		-DBUILD_MOD_PK3="1"
		-DBUILD_PAK3_PK3="1"
		-DBUILD_SERVER="$(usex dedicated)"
		# no bundled libs
		-DBUNDLED_LIBS="0"
		-DBUNDLED_SDL="0"
		-DBUNDLED_CURL="0"
		-DBUNDLED_JPEG="0"
		-DBUNDLED_LUA="0"
		-DBUNDLED_OGG_VORBIS="0"
		-DBUNDLED_GLEW="0"
		-DBUNDLED_FREETYPE="0"
		-DBUNDLED_JANSSON="0"
		# features
		-DFEATURE_CURL="$(usex curl)"
		-DFEATURE_OGG_VORBIS="$(usex vorbis)"
		-DFEATURE_OPENAL="$(usex openal)"
		-DFEATURE_FREETYPE="$(usex freetype)"
		-DFEATURE_LUA="$(usex lua)"
		-DFEATURE_IRC_CLIENT="$(usex irc)"
		-DFEATURE_IPV6="$(usex ipv6)"
		-DFEATURE_CURSES="$(usex curses)"
		-DFEATURE_GETTEXT="$(usex gettext)"
		-DFEATURE_JANSSON="$(usex jansson)"
		-DFEATURE_ANTICHEAT="1"
		-DFEATURE_AUTOUPDATE="1"
		-DFEATURE_CROUCH="0"
		# renderers
		-DFEATURE_RENDERER2="$(usex renderer2)"
		-DFEATURE_RENDERER_GLES="$(usex renderer-gles)"

		-DFEATURE_OMNIBOT="$(usex omnibot)"
		-DINSTALL_OMNIBOT="$(usex omnibot)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodir "/usr/$(get_libdir)/${PN}"
	mv "${ED%/}/usr/share/${PN}/legacy/"*.so "${ED%/}/usr/$(get_libdir)/${PN}"

	#local so
	#for so in "${D}/$(games_get_libdir)/${PN}"/*.so ; do
	#dosym "$(games_get_libdir)/${PN}/${so##*}" \
        #                "${GAMES_DATADIR}/${PN}/legacy/${so##*}"
	#done
	dosym "../../../$(get_libdir)/${PN}" "/usr/share/${PN}/legacy/${PN}"

	# Install the game files
	insinto /usr/share/etlegacy/etmain
	doins "${WORKDIR}"/et/etmain/pak[012].pk3
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	elog "Copy genuine ET files pak0.pk3, pak1.pk3 and pak2.pk3"
	elog "to /usr/share/${PN}/etmain in order so start"
	elog "the game."
	elog
	elog "If you are using opensource drivers you should consider installing: "
	elog "    media-libs/libtxc_dxtn"
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
