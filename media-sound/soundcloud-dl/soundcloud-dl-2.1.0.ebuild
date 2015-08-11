# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="https://github.com/lukapusic/soundcloud-dl"
SRC_URI="https://github.com/lukapusic/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="app-shells/bash
	dev-python/eyeD3
	net-misc/curl
	sys-apps/coreutils
	sys-apps/grep
	sys-apps/sed"

src_install() {
	default
	dobin scdl
	dodoc .scdl.cfg
}

pkg_postinst() {
	elog "A sample configuration can be found in"
	elog ""
	elog "  /usr/share/doc/${PF}/.scdl.cfg"
	elog ""
	elog "To use ${PN} copy the config file into your HOME directory and"
	elog "adjust the file to your needs."
}
