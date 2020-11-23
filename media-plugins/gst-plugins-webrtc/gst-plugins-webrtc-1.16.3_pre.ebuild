# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

PV="${PV%_*}"
P="${PN}-${PV}"

inherit gstreamer poly-c_ebuilds

DESCRIPTION="WebRTC plugins for GStreamer"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=media-libs/gst-plugins-base-${MY_PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-bad-${MY_PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/webrtc-audio-processing-0.2[${MULTILIB_USEDEP}]
	<media-libs/webrtc-audio-processing-0.4
	>=net-libs/libnice-0.1.14[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="webrtc webrtcdsp"
GST_PLUGINS_BUILD_DIR="webrtc webrtcdsp"

S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"

src_prepare() {
	default
	gstreamer_system_link gst-libs/gst/webrtc:gstreamer-webrtc
	gstreamer_system_link gst-libs/gst/sctp:gstreamer-sctp
	gstreamer_system_link gst-libs/gst/audio:gstreamer-bad-audio
}
