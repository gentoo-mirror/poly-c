# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Advanced rhythm game, designed for both home and arcade use"
HOMEPAGE="https://www.stepmania.com/"
SRC_URI="https://github.com/stepmania/stepmania/archive/v${PV/_beta/-b}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT default-songs? ( CC-BY-NC-4.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +default-songs alsa oss pulseaudio jack ffmpeg gles2 +gtk +mp3 +ogg +jpeg networking wav parport crash-handler cpu_flags_x86_sse2"

REQUIRED_USE="|| ( alsa oss pulseaudio jack )"
RDEPEND="
	app-arch/bzip2
	dev-libs/libpcre
	sys-libs/zlib
	media-libs/glew:=
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
		x11-libs/gtk+:2
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
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/${P/_beta/-b}"

PATCHES=(
	"${FILESDIR}/${P}-system_ffmpeg_build.patch"
)

src_prepare() {
	# Remove third-party librairies
	sed -i 's;add_subdirectory(extern);;' CMakeLists.txt || die

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
		-DWITH_GTK2="$(usex gtk)"
		-DWITH_JACK="$(usex jack)"
		-DWITH_JPEG="$(usex jpeg)"
		-DWITH_LTO="NO"
		-DWITH_MINIMAID="NO"
		-DWITH_MP3="$(usex mp3)"
		-DWITH_NETWORKING="$(usex networking)"
		-DWITH_OGG="$(usex ogg)"
		-DWITH_OSS="$(usex oss)"
		-DWITH_PARALLEL_PORT="$(usex parport)"
		-DWITH_PORTABLE_TOMCRYPT="YES"
		-DWITH_PROFILING="NO"
		-DWITH_PULSEAUDIO="$(usex pulseaudio)"
		-DWITH_SSE2="$(usex cpu_flags_x86_sse2)"
		-DWITH_SYSTEM_FFMPEG="$(usex ffmpeg)"
		-DWITH_TTY="NO"
		-DWITH_WAV="$(usex wav)"
	)
	cmake_src_configure
}
