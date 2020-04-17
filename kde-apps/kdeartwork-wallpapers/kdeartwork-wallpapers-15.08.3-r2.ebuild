# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: bfb5b223ec3b0e0002476e72e99fbf0ed74bdece $

EAPI=7

RESTRICT="binchecks strip"

MY_P="${PN/-*}-${PV}"

ECM_NONGUI="true"
ECM_DEBUG="false"
inherit ecm

DESCRIPTION="Wallpapers from KDE"
HOMEPAGE="https://www.kde.org"
SRC_URI="mirror://kde/Attic/applications/${PV}/src/${MY_P}.tar.xz"
KEYWORDS="amd64 x86"
IUSE=""
SLOT="5"
LICENSE="LGPL-3"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}-kf5-port.patch" )

src_configure() {
	local mycmakeargs=(
		-DDISABLE_ALL_OPTIONAL_SUBDIRECTORIES=TRUE
		-DBUILD_wallpapers=TRUE
		-DBUILD_HighResolutionWallpapers=TRUE
	)

	ecm_src_configure
}
