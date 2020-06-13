# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: e7d9995f840f953c91e1855d8030ec85e8a492af $

EAPI=7

EGIT_BRANCH="frameworks"
inherit cmake kde.org

DESCRIPTION="Plasma Network Monitor"
HOMEPAGE="https://kde-apps.org/content/show.php?content=12956"
LICENSE="GPL-2"
IUSE="wifi"
SLOT="0"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="amd64 x86"
	SRC_URI="https://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"
fi

DEPEND="
	dev-libs/libnl:3
	dev-qt/qtdbus:5
	dev-qt/qtgui
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets
	dev-qt/qtxml
	kde-frameworks/kconfig
	kde-frameworks/kconfigwidgets
	kde-frameworks/kcoreaddons
	kde-frameworks/kdbusaddons
	kde-frameworks/kdelibs4support
	kde-frameworks/kglobalaccel
	kde-frameworks/kguiaddons
	kde-frameworks/ki18n
	kde-frameworks/kio
	kde-frameworks/knotifications
	kde-frameworks/knotifyconfig
	kde-frameworks/kwidgetsaddons
	kde-frameworks/kwindowsystem
	kde-frameworks/kxmlgui
	kde-frameworks/plasma
	kde-plasma/libksysguard:=
	sys-apps/net-tools
	wifi? ( net-wireless/wireless-tools )
"
RDEPEND="${DEPEND}
	!net-misc/knemo:4
"

PATCHES=(
	"${FILESDIR}/${PN}-0.8.0_pre20161211-frameworks-5630.patch" #697780
)

src_prepare() {
	cmake_src_prepare

	# unused dependency
	sed -e "/KCMUtils/d" -i CMakeLists.txt -i src/kcm/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DNO_WIRELESS_SUPPORT=$(usex !wifi)
	)

	cmake_src_configure
}
