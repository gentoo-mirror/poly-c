# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson poly-c_ebuilds

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="http://pipewire.org/"
SRC_URI="https://github.com/PipeWire/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gstreamer docs"

RDEPEND="
	media-libs/alsa-lib
	media-libs/sbc
	media-video/ffmpeg
	sys-apps/dbus
	virtual/libudev
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
"
DEPEND="
	${RDEPEND}
	app-doc/xmltoman
	docs? ( app-doc/doxygen )
"

src_configure() {
	local emesonargs=(
		-Denable_gstreamer="$(usex gstreamer true false)"
		-Denable_man="true"
		-Denable_docs="$(usex docs true false)"
	)
	meson_src_configure
}
