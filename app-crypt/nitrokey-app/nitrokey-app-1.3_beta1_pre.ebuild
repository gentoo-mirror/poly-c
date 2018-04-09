# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils udev gnome2-utils xdg-utils poly-c_ebuilds

REAL_PV="${MY_PV/_beta/-beta.}"

DESCRIPTION="Cross platform personalization tool for the Nitrokey"
HOMEPAGE="https://github.com/Nitrokey/nitrokey-app"
SRC_URI="https://github.com/Nitrokey/${PN}/archive/v${REAL_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
[[ "${PV}" = *_beta* ]] || \
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/libnitrokey-3.2_pre
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5"
DEPEND="
	${RDEPEND}
	dev-libs/cppcodec
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${REAL_PV}"

src_prepare() {
	cmake-utils_src_prepare
	sed \
		-e "s@[[:space:]]${PN}.debug@@" \
		-e '/REGEX REPLACE/d' \
		-e 's@"\(lib/udev/rules.d\)"@"/\1"@' \
		-e 's@"\(etc/bash_completion.d\)"@"/\1"@' \
		-e "/PROJECT_VERSION/s@\"[[:alnum:]\.-]\+\"@\"${REAL_PV}\"@" \
		-i CMakeLists.txt || die

	sed \
		-e '/libnitrokey/d' \
		-e '/cppcodec/d' \
		-i resources.qrc || die
}

src_configure() {
	local mycmakeargs=(
		-DADD_GIT_INFO=FALSE
		-DERROR_ON_WARNING=NO
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	udev_reload
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_posrtrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}