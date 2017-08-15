# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools bash-completion-r1

DESCRIPTION="Configurable embedded Linux firmware update creator and runner"
HOMEPAGE="https://github.com/fhunleth/fwup"
SRC_URI="https://github.com/fhunleth/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-arch/libarchive[zlib]
	>=dev-libs/confuse-2.8
	dev-libs/libsodium
"
DEPEND="
	${RDEPEND}
	sys-apps/help2man
	virtual/pkgconfig
"

src_prepare() {
	default
	eautoreconf
}
