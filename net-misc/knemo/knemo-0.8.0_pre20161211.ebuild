# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: e7d9995f840f953c91e1855d8030ec85e8a492af $

EAPI=7

EGIT_BRANCH="frameworks"
inherit kde5

DESCRIPTION="Plasma Network Monitor"
HOMEPAGE="https://kde-apps.org/content/show.php?content=12956"
LICENSE="GPL-2"
IUSE="wifi"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	KEYWORDS="amd64 x86"
	SRC_URI="https://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"
fi

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_plasma_dep libksysguard)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsql 'sqlite')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/libnl:3
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
	kde5_src_prepare

	# unused dependency
	sed -e "/KCMUtils/d" -i CMakeLists.txt -i src/kcm/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DNO_WIRELESS_SUPPORT=$(usex !wifi)
	)

	kde5_src_configure
}