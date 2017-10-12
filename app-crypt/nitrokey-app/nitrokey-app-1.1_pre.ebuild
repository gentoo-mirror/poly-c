# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils udev poly-c_ebuilds

DESCRIPTION="Cross platform personalization tool for the Nitrokey"
HOMEPAGE="https://github.com/Nitrokey/nitrokey-app"
SRC_URI="https://github.com/Nitrokey/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.1-lib_include_fixes.patch"
)

mycmakeargs=( -DHAVE_LIBAPPINDICATOR=NO )

src_prepare() {
	cmake-utils_src_prepare
	sed \
		-e "s:DESTINATION lib/udev/rules.d:DESTINATION $(get_udevdir)/rules.d:" \
		-e '/^add_subdirectory (libnitrokey)$/d' \
		-i CMakeLists.txt || die

	sed \
		-e '/libnitrokey/d' \
		-e '/cppcodec/d' \
		-i resources.qrc || die
}

pkg_postinst() {
	udev_reload
}
