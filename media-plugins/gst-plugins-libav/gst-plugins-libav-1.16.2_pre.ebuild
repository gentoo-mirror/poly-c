# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eapi7-ver multilib-minimal poly-c_ebuilds

REAL_PN="gst-libav"
REAL_PV="$(ver_cut 1-3)"
REAL_P="${REAL_PN}-${REAL_PV}"

DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="https://gstreamer.freedesktop.org/src/${REAL_PN}/${REAL_P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~x86"
IUSE="+orc"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-video/ffmpeg-4:0=[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${REAL_P}"

RESTRICT="test" # FIXME: tests seem to get stuck at one point; investigate properly

src_prepare() {
	default
	eautoreconf # remove with a proper release without build system touching patchset
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-maintainer-mode
		--with-package-name="Gentoo GStreamer ebuild"
		--with-package-origin="https://www.gentoo.org"
		--with-system-libav
		--disable-fatal-warnings
		$(use_enable orc)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	# Don't build with -Werror; verbose build
	emake ERROR_CFLAGS= V=1
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
