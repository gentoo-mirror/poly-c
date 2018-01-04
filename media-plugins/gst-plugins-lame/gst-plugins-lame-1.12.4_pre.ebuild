# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-ugly

PV="${PV%_*}"
P="${PN}-${PV}"
S="${WORKDIR}/${P}"

inherit gstreamer

DESCRIPTION="MP3 encoder plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=media-sound/lame-3.99.5-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
