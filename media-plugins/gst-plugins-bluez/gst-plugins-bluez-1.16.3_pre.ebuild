# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

PV="${PV%_*}"
P="${PN}-${PV}"

inherit gstreamer poly-c_ebuilds

DESCRIPTION="AVDTP source/sink and A2DP sink plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=net-wireless/bluez-5[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
"

S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"
