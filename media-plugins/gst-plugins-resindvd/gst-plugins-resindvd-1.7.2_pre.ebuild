# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

PV="${PV%_*}"
P="${PN}-${PV}"
S="${WORKDIR}/${P}"

inherit gstreamer

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

RDEPEND="
	>=media-libs/libdvdnav-4.2.0-r1[${MULTILIB_USEDEP}]
	>=media-libs/libdvdread-4.2.0-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
