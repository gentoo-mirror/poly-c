# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="Advanced rhythm game, designed for both home and arcade use"
HOMEPAGE="https://www.stepmania.com/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/stepmania/stepmania.git"
else
	SRC_URI="https://github.com/stepmania/stepmania/archive/v${PV/_beta/-b}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="MIT default-songs? ( CC-BY-NC-4.0 )"
SLOT="0"
IUSE="doc +default-songs alsa oss pulseaudio jack ffmpeg gles2 +gtk +mp3 +ogg +jpeg networking wav parport crash-handler cpu_flags_x86_sse2"

REQUIRED_USE="|| ( alsa oss pulseaudio jack )"
RDEPEND="
	app-arch/bzip2
	dev-libs/libpcre
	dev-libs/libtomcrypt
	media-libs/glew:=
	sys-libs/zlib
	virtual/opengl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libva
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg )
	gtk? (
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/pango
	)
	jack? ( media-sound/jack-audio-connection-kit )
	mp3? ( media-libs/libmad )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/${P/_beta/-b}"

#PATCHES=(
#	"${FILESDIR}/${PN}-9999-includes.patch"
#)

src_prepare() {
	# Remove third-party librairies
	sed -i 's;add_subdirectory(extern);;' CMakeLists.txt || die

	# "Fix" linking against system lua
	local PKGCONFIG="$(tc-getPKG_CONFIG)" lua_ver lua_libs
	for lua_ver in lua5.{4..1} lua ; do
		if ${PKGCONFIG} --exists ${lua_ver} ; then
			lua_libs="$(${PKGCONFIG} --libs ${lua_ver} | sed 's@-l\(lua[[:digit:]\.]*\).*@\1@')"
			break
		fi
	done
	[[ -z "${lua_libs}" ]] && die
	sed \
		-e "s@lua-5\.1@${lua_libs}@" \
		-i src/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Minimaid tries to use pre-built static libraries (x86 only, often fails to link)
	# TTY input fails to compile
	local mycmakeargs=(
		-DWITH_ALSA="$(usex alsa)"
		-DWITH_CRASH_HANDLER="$(usex crash-handler)"
		-DWITH_FFMPEG="$(usex ffmpeg)"
		-DWITH_FULL_RELEASE="NO"
		-DWITH_GLES2="$(usex gles2)"
		-DWITH_GPL_LIBS="YES"
		-DWITH_GTK3="$(usex gtk)"
		-DWITH_JACK="$(usex jack)"
		-DWITH_JPEG="$(usex jpeg)"
		-DWITH_LTO="NO"
		-DWITH_MINIMAID="NO"
		-DWITH_MP3="$(usex mp3)"
		-DWITH_NETWORKING="$(usex networking)"
		-DWITH_OGG="$(usex ogg)"
		-DWITH_OSS="$(usex oss)"
		-DWITH_PARALLEL_PORT="$(usex parport)"
		-DWITH_PROFILING="NO"
		-DWITH_PULSEAUDIO="$(usex pulseaudio)"
		-DWITH_SSE2="$(usex cpu_flags_x86_sse2)"
		-DWITH_SYSTEM_FFMPEG="$(usex ffmpeg)"
		-DWITH_SYSTEM_GLEW="YES"
		-DWITH_SYSTEM_JPEG="$(usex jpeg)"
		#-DWITH_SYSTEM_JSONCPP="YES"
		-DWITH_SYSTEM_MAD="YES"
		-DWITH_SYSTEM_OGG="$(usex ogg)"
		#-DWITH_SYSTEM_PCRE="YES"
		#-DWITH_SYSTEM_PNG="YES"
		-DWITH_SYSTEM_TOMCRYPT="YES"
		-DWITH_SYSTEM_TOMMATH="YES"
		-DWITH_SYSTEM_ZLIB="YES"
		-DWITH_TTY="NO"
		-DWITH_WAV="$(usex wav)"
	)
	cmake_src_configure
}
