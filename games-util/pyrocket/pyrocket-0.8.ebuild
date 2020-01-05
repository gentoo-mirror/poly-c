# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="PyGTK control interface for Striker II and Dream Cheeky USB foam dart launchers"
HOMEPAGE="https://github.com/stadler/pyrocket"
SRC_URI="https://github.com/stadler/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"

IUSE=""

S="${WORKDIR}/${P}/src"

RDEPEND="${DEPEND}
	dev-python/pygtk
	dev-python/pyusb
	dev-python/pygame
	media-libs/opencv[python]"

#src_install() {
#	exeinto /usr/bin
#	doexe ${PN}
#
#	insinto /usr/$(get_libdir)/$(eselect python show --python2)/site-packages
#	doins rocket*.py
#	
#	insinto /usr/share/pixmaps
#	doins ${PN}.xpm
#
#	insinto /usr/share/${PN}
#	doins *.png *.svg
#
#	insinto /lib/udev/rules.d
#	doins 40-rocketlauncher.rules
#}
