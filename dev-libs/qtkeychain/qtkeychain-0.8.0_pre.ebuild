# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils poly-c_ebuilds

DESCRIPTION="Qt API for storing passwords securely"
HOMEPAGE="https://github.com/frankosterfeld/qtkeychain"
SRC_URI="https://github.com/frankosterfeld/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

DOCS=( ChangeLog ReadMe.txt )

src_configure() {
	local mycmakeargs=(
		-DQTKEYCHAIN_STATIC=OFF
		-DBUILD_TRANSLATIONS=ON
		-DBUILD_WITH_QT4=OFF
	)
	cmake-utils_src_configure
}
