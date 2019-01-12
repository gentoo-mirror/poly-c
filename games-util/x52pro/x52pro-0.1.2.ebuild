# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit toolchain-funcs

DESCRIPTION="MFD+LED library for the SAITEK X52 Pro Flight Sytem"
HOMEPAGE="http://plasma.hasenleithner.at/x52pro/"
SRC_URI="http://plasma.hasenleithner.at/${PN}/${P}.tar.gz
	https://www.gentoofan.org/gentoo/misc/${P}.tar.gz"
LICENSE="LGPL2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libusb-compat"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.1.2-gentoo.patch"
	"${FILESDIR}/${PN}-0.1.2-udevrules.patch"
)

src_compile() {
	emake CC="$(tc-getCC)"
}

pkg_postinst() {
	udevadm control --reload-rules && udevadm trigger --subsystem-match=usb
}
