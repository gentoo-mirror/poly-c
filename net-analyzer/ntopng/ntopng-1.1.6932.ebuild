# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools versionator

MY_PV="$(replace_version_separator 2 '_')"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Next generation network traffic analyzer"
HOMEPAGE="http://www.ntop.org/"
SRC_URI="mirror://sourceforge/ntop/${PN}/${MY_P}.tgz
	mirror://sourceforge/ntop/${PN}/${PN}-data-${MY_PV}.tgz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/credis-0.2.3
	dev-libs/json-c
	>=net-analyzer/rrdtool-1.4.7
	>=net-libs/zeromq-3.2.3
	virtual/pkgconfig"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}
