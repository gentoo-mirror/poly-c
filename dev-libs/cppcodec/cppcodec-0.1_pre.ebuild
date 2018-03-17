# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
inherit cmake-utils poly-c_ebuilds

DESCRIPTION="C++11 library to encode/decode base64, base64url, base32, base32hex and hex"
HOMEPAGE="https://github.com/tplgy/cppcodec"

if [[ ${MY_PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tplgy/cppcodec.git"

	# Disable pulling in catch
	EGIT_SUBMODULES=()
else
	SRC_URI="https://github.com/tplgy/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test"

DEPEND="
	test? (
		virtual/pkgconfig
		>=dev-cpp/catch-2.2.0
	)"

PATCHES=(
	"${FILESDIR}/${PN}-0.1-includes_fix.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake-utils_src_configure
}
