# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

PV="${PV%_*}"
P="${PN}-${PV}"

inherit gstreamer poly-c_ebuilds

DESCRIPTION="AAC audio decoder plugin."
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/faad2-2.7-r3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"
