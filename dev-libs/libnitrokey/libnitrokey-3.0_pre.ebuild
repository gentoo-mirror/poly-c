# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils poly-c_ebuilds

DESCRIPTION="Communicate with Nitrokey stick devices in a clean and easy manner"
HOMEPAGE="https://github.com/Nitrokey/libnitrokey"
SRC_URI="https://github.com/Nitrokey/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="LGPL-3"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-libs/hidapi
"

DEPEND="
	${RDEPEND}
	dev-cpp/catch
"

PATCHES=(
	"${FILESDIR}/${PN}-3.0-unittest_fixes.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCOMPILE_TESTS="$(usex test)"
	)
	cmake-utils_src_configure
}
