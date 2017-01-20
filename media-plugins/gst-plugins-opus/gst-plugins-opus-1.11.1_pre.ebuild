# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

PV="${PV%_*}"
P="${PN}-${PV}"
S="${WORKDIR}/${P}"

inherit autotools gstreamer

DESCRIPTION="GStreamer plugin for Opus audio codec support"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

COMMON_DEPEND=">=media-libs/opus-1.0.2-r2:=[${MULTILIB_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
	media-libs/gst-plugins-base:${SLOT}[${MULTILIB_USEDEP},ogg]
"
DEPEND="${COMMON_DEPEND}"

PATCHES=(
	"${FILESDIR}/${P/${PN##*-}/bad}-configure.patch"
)

src_prepare() {
	default
	eautoreconf
}
