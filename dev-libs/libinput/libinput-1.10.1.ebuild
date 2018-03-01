# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 44cea37f06a636f2dad3784f91f6c69a0dc57499 $

EAPI=6
inherit meson udev

DESCRIPTION="Library to handle input devices in Wayland"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libinput/"
SRC_URI="https://www.freedesktop.org/software/${PN}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0/10"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc input_devices_wacom test"
# Tests require write access to udev rules directory which is a no-no for live system.
# Other tests are just about logs, exported symbols and autotest of the test library.
RESTRICT="test"

RDEPEND="
	input_devices_wacom? ( >=dev-libs/libwacom-0.20 )
	>=dev-libs/libevdev-1.3
	>=sys-libs/mtdev-1.1
	virtual/libudev
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		>=app-doc/doxygen-1.8.3
		>=media-gfx/graphviz-2.38.0
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.10.0-hysteresis_timeout.patch"
)

#	test? (
#		>=dev-libs/check-0.9.10
#		dev-util/valgrind
#		sys-libs/libunwind )

src_configure() {
	# gui can be built but will not be installed
	local emesonargs=(
		-Ddebug-gui=false
		-Ddocumentation="$(usex doc true false)"
		-Dlibwacom="$(usex input_devices_wacom true false)"
		-Dtests="$(usex test true false)"
		-Dudev-dir="$(get_udevdir)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use doc ; then
		docinto html
		dodoc -r "${BUILD_DIR}"/html/.
	fi
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
