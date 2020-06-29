# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 65ea285b3cab02a5a25d0cadfed6c0f21613eeab $

EAPI=7

inherit autotools udev

DESCRIPTION="Saitek X52pro drivers & controller mapping software for Linux"
HOMEPAGE="https://github.com/nirenjan/x52pro-linux"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="https://github.com/nirenjan/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nirenjan/x52pro-linux.git"
fi

LICENSE="GPL2"
SLOT="0"
IUSE=""

DEPEND="virtual/libusb"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die

	insinto $(get_udevdir)/rules.d
	doins udev/60-saitek-x52-x52pro.rules
}
