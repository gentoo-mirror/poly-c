# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs poly-c_ebuilds

DESCRIPTION="Public-domain version of lzip compressor"
HOMEPAGE="http://www.nongnu.org/lzip/pdlzip.html"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/lzip/pdlzip/${MY_P}.tar.gz
	http://download.savannah.gnu.org/releases/lzip/pdlzip/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~x86-fbsd"
IUSE=""

src_configure() {
	# not autotools-based
	./configure \
		--prefix="${EPREFIX}"/usr \
		CC="$(tc-getCC)" \
		CPPFLAGS="${CPPFLAGS}" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}
