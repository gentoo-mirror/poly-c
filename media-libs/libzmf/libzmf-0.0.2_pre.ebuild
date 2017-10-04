# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit poly-c_ebuilds

EGIT_REPO_URI="git://gerrit.libreoffice.org/libzmf"
[[ ${MY_PV} == 9999 ]] && inherit git-r3 autotools

DESCRIPTION="Library for parsing Zoner Callisto/Draw documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libzmf"
[[ ${MY_PV} == 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${MY_P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
[[ ${MY_PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

IUSE="debug doc test tools"

RDEPEND="
	dev-libs/icu:=
	dev-libs/librevenge
	media-libs/libpng:0=
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.56
	doc? ( app-doc/doxygen )
	test? ( dev-util/cppunit )
"

src_prepare() {
	default
	[[ ${MY_PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		$(use_enable debug) \
		$(use_with doc docs) \
		$(use_enable test tests) \
		$(use_enable tools)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
