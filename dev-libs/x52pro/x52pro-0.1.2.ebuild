# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="MFD+LED library for the SAITEK X52 Pro Flight Sytem"
HOMEPAGE="http://plasma.hasenleithner.at/x52pro/"
SRC_URI="http://plasma.hasenleithner.at/${PN}/${P}.tar.gz"
LICENSE="GPL-2+ LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( dev-libs/libusb dev-libs/libusbx )"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"

	sed "s@%LIBDIR%@$(get_libdir)@" -i Makefile || die
	sed 's@SYSFS@ATTRS@g;s@plugdev@usb@g' -i 99-x52pro.rules || die
}

src_configure() {
	return 0
}
