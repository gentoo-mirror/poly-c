# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils poly-c_ebuilds

REAL_PN="megaglest"
DESCRIPTION="Data files for the cross-platform 3D realtime strategy game MegaGlest"
HOMEPAGE="http://www.megaglest.org/"
SRC_URI="https://github.com/MegaGlest/megaglest-data/releases/download/${MY_PV}/megaglest-data-${MY_PV}.tar.xz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DOCS=( docs/AUTHORS.data.txt docs/CHANGELOG.txt docs/README.txt )

S="${WORKDIR}/${REAL_PN}-${MY_PV}"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		#-DMEGAGLEST_BIN_INSTALL_PATH="${GAMES_BINDIR}"
		#-DMEGAGLEST_DATA_INSTALL_PATH="${GAMES_DATADIR}/${REAL_PN}"
		-DMEGAGLEST_ICON_INSTALL_PATH="/usr/share/pixmaps"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	use doc && HTML_DOCS="docs/glest_factions/"
	cmake-utils_src_install
}