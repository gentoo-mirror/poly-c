# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 77337142ec368ef43c179461f5ca0beb09d5cd21 $

EAPI=7

inherit cmake-utils desktop

DESCRIPTION="Advanced DRI Configurator"
HOMEPAGE="https://github.com/jlHertel/adriconf"
if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jlHertel/adriconf.git"
else
	SRC_URI="https://github.com/jlHertel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3"
SLOT="0"

IUSE="wayland"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-cpp/libxmlpp
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/libsigc++:2
	media-libs/mesa
	sys-apps/pciutils
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	wayland? ( media-libs/mesa[egl] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default
	sed '/^Version/d' -i flatpak/br.com.jeanhertel.${PN}.desktop || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_XWAYLAND="$(usex wayland)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	insinto /usr/share/appdata
	newins {flatpak/br.com.jeanhertel.,}${PN}.appdata.xml

	newmenu {flatpak/br.com.jeanhertel.,}${PN}.desktop

	newicon {flatpak/br.com.jeanhertel.,}${PN}.png
}
