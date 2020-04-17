# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 11bf1eb9d4ead4f2637063f8430acb4a27d8e857 $

EAPI=7

MY_P="${PN/-*}-${PV}"

ECM_NONGUI="true"
ECM_DEBUG="false"
inherit ecm

DESCRIPTION="Weather aware wallpapers. Changes with weather outside"
HOMEPAGE="https://www.kde.org"
SRC_URI="mirror://kde/Attic/applications/${PV}/src/${MY_P}.tar.xz"
KEYWORDS="amd64 x86"
IUSE=""
SLOT="5"
LICENSE="LGPL-3"

RDEPEND="
	~kde-apps/kdeartwork-wallpapers-${PV}
"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}-kf5-port.patch" )

src_configure() {
	local mycmakeargs=(
		-DDISABLE_ALL_OPTIONAL_SUBDIRECTORIES=TRUE
		-DBUILD_WeatherWallpapers=TRUE
	)

	ecm_src_configure
}
