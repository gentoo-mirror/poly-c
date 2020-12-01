# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

PV="${PV%_*}"
P="${PN}-${PV}"

inherit gstreamer poly-c_ebuilds

DESCRIPTION="Beats-per-minute detection and pitch controlling plugin for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libsoundtouch-1.7.1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"