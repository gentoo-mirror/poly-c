# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# google-breakpad
# TODO: fribidi, libvorbis static

EAPI=7

# src_install() currently requires this
CMAKE_MAKEFILE_GENERATOR="emake"

LUA_COMPAT=( lua5-{1..2} )

# Only needed by certain features
VIRTUALX_REQUIRED="manual"

inherit cmake desktop flag-o-matic lua-single virtualx wxwidgets xdg-utils poly-c_ebuilds

DESCRIPTION="Cross-platform 3D realtime strategy game"
HOMEPAGE="http://www.megaglest.org/"
SRC_URI="https://github.com/MegaGlest/megaglest-source/releases/download/${MY_PV}/megaglest-source-${MY_PV}.tar.xz"

LICENSE="GPL-3 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +editor fribidi cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 static +streflop +tools +unicode wxuniversal +model-viewer videos"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	~games-strategy/${PN}-data-${PV}
	dev-libs/libxml2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libsdl[X,sound,joystick,opengl,video]
	media-libs/libvorbis
	media-libs/openal
	net-libs/gnutls
	sys-libs/zlib
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	x11-libs/libXext
	editor? ( x11-libs/wxGTK:3.0[X,opengl] )
	fribidi? ( dev-libs/fribidi )
	model-viewer? ( x11-libs/wxGTK:3.0[X] )
	!static? (
		dev-libs/xerces-c[icu]
		media-libs/ftgl
		media-libs/glew
		media-libs/libpng:0
		net-libs/libircclient
		>=net-libs/miniupnpc-1.8
		net-misc/curl
		virtual/jpeg:0
		)
	videos? ( media-video/vlc )"
DEPEND="${RDEPEND}
	static? (
		dev-libs/icu[static-libs]
		dev-libs/xerces-c[icu,static-libs]
		media-libs/ftgl[static-libs]
		media-libs/glew[static-libs]
		media-libs/libpng:0[static-libs]
		net-libs/libircclient[static-libs]
		net-libs/miniupnpc[static-libs]
		net-misc/curl[static-libs]
		virtual/jpeg:0[static-libs]
	)"

BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
	editor? ( ${VIRTUALX_DEPEND} )
	model-viewer? ( ${VIRTUALX_DEPEND} )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.13.0-static-build.patch
	"${FILESDIR}"/${PN}-3.11.1-cmake-lua.patch
)

src_prepare() {
	cmake_src_prepare

	if use editor || use model-viewer ; then
		WX_GTK_VER="3.0"
		setup-wxwidgets
	fi
}

src_configure() {
	if use cpu_flags_x86_sse3; then
		SSE=3
	elif use cpu_flags_x86_sse2; then
		SSE=2
	elif use cpu_flags_x86_sse; then
		SSE=1
	else
		SSE=0
	fi

	local mycmakeargs=(
		-DWANT_USE_FriBiDi="$(usex fribidi)"
		-DBUILD_MEGAGLEST_MAP_EDITOR="$(usex editor)"
		-DBUILD_MEGAGLEST_MODEL_IMPORT_EXPORT_TOOLS="$(usex tools)"
		-DBUILD_MEGAGLEST_MODEL_VIEWER="$(usex model-viewer)"
		-DWANT_USE_VLC="$(usex videos)"
		-DFORCE_LUA_VERSION="$(lua_get_version)"
		-DFORCE_MAX_SSE_LEVEL="${SSE}"
		#-DMEGAGLEST_BIN_INSTALL_PATH="${GAMES_BINDIR}"
		#-DMEGAGLEST_DATA_INSTALL_PATH="${GAMES_DATADIR}/${PN}"
		# icons are used at runtime, wrong default location share/pixmaps
		#-DMEGAGLEST_ICON_INSTALL_PATH="${GAMES_DATADIR}/${PN}"
		-DWANT_USE_FTGL=ON
		-DWANT_STATIC_LIBS="$(usex static)"
		-DWANT_USE_STREFLOP="$(usex streflop)"
		-DwxWidgets_USE_STATIC="$(usex static)"
		-DwxWidgets_USE_UNICODE="$(usex unicode)"
		-DwxWidgets_USE_UNIVERSAL="$(usex wxuniversal)"

		$(usex debug "-DBUILD_MEGAGLEST_UPNP_DEBUG=ON -DwxWidgets_USE_DEBUG=ON" "")
	)

	# support CMAKE_BUILD_TYPE=Gentoo
	#append-cppflags '-DCUSTOM_DATA_INSTALL_PATH=\\\"'${GAMES_DATADIR}/${PN}/'\\\"'

	cmake_src_configure
}

src_compile() {
	if use editor || use model-viewer; then
		# work around parallel make issues - bug #561380
		#MAKEOPTS="-j1 ${MAKEOPTS}" \
		virtx cmake_src_compile
	else
		cmake_src_compile
	fi
}

src_install() {
	# rebuilds some targets randomly without fast option
	emake -C "${BUILD_DIR}" DESTDIR="${D}" "$@" install/fast

	dodoc docs/{AUTHORS.source_code,CHANGELOG,README}.txt
	#doicon -s 48 ${PN}.png

	use editor &&
		make_desktop_entry ${PN}_editor "MegaGlest Map Editor"
	use model-viewer &&
		make_desktop_entry ${PN}_g3dviewer "MegaGlest Model Viewer"

}

pkg_postinst() {
	einfo
	elog 'Note about Configuration:'
	elog 'DO NOT directly edit glest.ini and glestkeys.ini but rather glestuser.ini'
	elog 'and glestuserkeys.ini in ~/.megaglest/ and create your user over-ride'
	elog 'values in these files.'
	elog
	elog 'If you have an older graphics card which only supports OpenGL 1.2, and the'
	elog 'game crashes when you try to play, try starting with "megaglest --disable-vbo"'
	elog 'Some graphics cards may require setting Max Lights to 1.'
	einfo

	xdg_icon_cache_update
}
