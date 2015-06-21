# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"

inherit python

MY_P="${PN}_${PV}"

DESCRIPTION="PyGTK control interface for Striker II and Dream Cheeky USB foam dart launchers"
HOMEPAGE="http://code.google.com/p/pyrocket/"
SRC_URI="http://pyrocket.googlecode.com/files/${MY_P}.orig.tar.gz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"

IUSE=""

S="${WORKDIR}/${P}.orig"

RDEPEND="${DEPEND}
	dev-python/pygtk
	dev-python/pyusb
	dev-python/pygame
	media-libs/opencv[python]"

src_install() {
	exeinto /usr/bin
	doexe ${PN}

	insinto /usr/$(get_libdir)/$(eselect python show --python2)/site-packages
	doins rocket*.py
	
	insinto /usr/share/pixmaps
	doins ${PN}.xpm

	insinto /usr/share/${PN}
	doins *.png *.svg

	insinto /lib/udev/rules.d
	doins 40-rocketlauncher.rules
}
