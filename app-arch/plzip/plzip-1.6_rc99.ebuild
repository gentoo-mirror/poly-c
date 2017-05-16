# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs poly-c_ebuilds

DESCRIPTION="Parallel lzip compressor"
HOMEPAGE="http://www.nongnu.org/lzip/plzip.html"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/lzip/${PN}/${MY_P/_/-}.tar.gz
	http://download.savannah.gnu.org/releases/lzip/${PN}/${MY_P/_/-}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-arch/lzlib:0="
DEPEND=${RDEPEND}

S="${WORKDIR}/${MY_P/_/-}"

src_configure() {
	# not autotools-based
	./configure \
		--prefix="${EPREFIX}"/usr \
		CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}
