# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools poly-c_ebuilds

DESCRIPTION="Platform independent library providing basic system functions"
HOMEPAGE="http://libhx.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/libHX-${MY_PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0/32" # libHX.so version
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

DEPEND="app-arch/xz-utils"
RDEPEND=""

S="${WORKDIR}/libHX-${MY_PV}"

PATCHES=( "${FILESDIR}/${PN}-3.22-no-lyx.patch" )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	if use doc; then
		dodoc doc/*.txt
	else
		dodoc doc/changelog.txt
		rm "${ED}/usr/share/doc/${PF}/"*.pdf || die
	fi

	find "${ED}" -name "*.la" -delete || die
}
