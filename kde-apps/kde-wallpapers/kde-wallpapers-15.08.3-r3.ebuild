# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 4930f5bab8a204a954d41b2d0941d53c8b5f4c0f $

EAPI=7

ECM_NONGUI="true"
ECM_DEBUG="false"

inherit ecm

DESCRIPTION="KDE wallpapers"
HOMEPAGE="https://www.kde.org"
SRC_URI="mirror://kde/Attic/applications/${PV}/src/${P}.tar.xz"
KEYWORDS="amd64 x86"
IUSE=""
SLOT="5"
LICENSE="LGPL-3"

PATCHES=( "${FILESDIR}/${PN}-15.08.0-kf5-port.patch" ) # bug 559156

src_install() {
	ecm_src_install
	rm -r "${ED}"/usr/share/wallpapers/Autumn || die
	rm -r "${ED}"/usr/share/wallpapers/Elarun || die
}
