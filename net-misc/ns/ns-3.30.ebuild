# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE='threads(+)'

inherit python-single-r1 waf-utils

MY_P="${PN}-allinone-${PV}"

DESCRIPTION="A discrete-event network simulator for Internet systems."
HOMEPAGE="https://www.nsnam.org/"
SRC_URI="https://www.nsnam.org/release/${MY_P}.tar.bz2"
LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug examples gtk test"

RDEPEND="${PYTHON_DEPEND}
	dev-db/sqlite
	dev-libs/boost
	dev-libs/libxml2
	sci-libs/gsl:=
	gtk? (
		dev-libs/atk
		dev-libs/glib:2
		media-libs/fontconfig
		media-libs/freetype
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:3
		x11-libs/pango
	)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}/${P}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local myconf=()

	use gtk || myconf+=( --disable-gtk )

	myconf+=(
		$(usex debug '-d debug' '-d release')
		$(use_enable examples)
		$(use_enable test tests)
		--boost-mt
		--enable-mpi
	)
	waf-utils_src_configure "${myconf[@]}"
}
