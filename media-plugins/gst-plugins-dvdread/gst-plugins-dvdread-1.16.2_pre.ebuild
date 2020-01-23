# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-ugly

PV="${PV%_*}"
P="${PN}-${PV}"

inherit autotools gstreamer poly-c_ebuilds

DESCRIPTION="DVD read plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/libdvdread-4.2.0-r1:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"
PATCHES=( "${FILESDIR}/${GST_ORG_MODULE}-1.16.2-make43.patch" )

src_prepare() {
	default
	eautoreconf
}
