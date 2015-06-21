# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/ledger/ledger-3.1.ebuild,v 1.5 2015/06/07 08:09:57 jlec Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="A double-entry accounting system with a command-line reporting interface"
HOMEPAGE="http://ledger-cli.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ledger/ledger/commit/48aec0f093ff6494a3e4f7cd5166cb4a27c16814.patch -> ${PN}-3.1-boost158_fix1.patch
	https://github.com/ledger/ledger/commit/68c9d649caa2c7c7f222613efe86576c379a5a7a.patch -> ${PN}-3.1-boost158_fix2.patch"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/boost:=
	dev-libs/gmp:0
	dev-libs/mpfr:0
"
DEPEND="${RDEPEND}
	dev-libs/utfcpp
"

DOCS=(README.md)

src_prepare() {
	epatch "${DISTDIR}/${P}-boost158_fix1.patch" \
		"${DISTDIR}/${P}-boost158_fix2.patch"
}
