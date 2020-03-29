# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE="gst-plugins-ugly"

PV="${PV%_*}"
P="${PN}-${PV}"
S="${WORKDIR}/${P}"

inherit autotools gstreamer poly-c_ebuilds

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2+" # some split plugins are LGPL but combining with a GPL library
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}_pre:${SLOT}[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}_pre:${SLOT}[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
"

PATCHES=( "${FILESDIR}/${PN}-1.16.2-make43.patch" )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	gstreamer_multilib_src_configure

	if multilib_is_native_abi; then
		ln -s "${S}"/docs/plugins/html docs/plugins/html || die
	fi

}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS README RELEASE"
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
