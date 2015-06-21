# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils games distutils-r1

DESCRIPTION="WxPython launcher for FS-UAE"
HOMEPAGE="http://fs-uae.net/"
SRC_URI="http://fs-uae.net/fs-uae/devel/${PV}dev/${P}dev.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/wxpython
	dev-python/pygame
	dev-python/pyside"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}dev"


src_install() {
	distutils-r1_src_install
	make_desktop_entry ${PN} "FS-UAE Launcher" fs-uae
}
