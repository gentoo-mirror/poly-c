# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-base

PV="${PV%_*}"
P="${PN}-${PV}"
S="${WORKDIR}/${P}"

inherit gstreamer

DESCRIPTION="Opus audio parser plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

COMMON_DEPEND=">=media-libs/opus-1.1:=[${MULTILIB_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-base-${PV}_pre:${SLOT}[${MULTILIB_USEDEP},ogg]
"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	gstreamer_system_link \
		gst-libs/gst/tag:gstreamer-tag \
		gst-libs/gst/pbutils:gstreamer-pbutils \
		gst-libs/gst/audio:gstreamer-audio
}
