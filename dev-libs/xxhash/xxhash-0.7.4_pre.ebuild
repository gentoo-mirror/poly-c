# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs poly-c_ebuilds

DESCRIPTION="Extremely fast non-cryptographic hash algorithm"
HOMEPAGE="http://www.xxhash.net"
SRC_URI="https://github.com/Cyan4973/xxHash/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD-2 GPL-2+"
# https://abi-laboratory.pro/tracker/timeline/xxhash
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-macos"
IUSE="static-libs"

S="${WORKDIR}/xxHash-${MY_PV}"

src_compile() {
	PREFIX="${EPREFIX}/usr" \
	LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
	emake AR="$(tc-getAR)" CC="$(tc-getCC)"
}

src_install() {
	PREFIX="${EPREFIX}/usr" \
	LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
	MANDIR="${EPREFIX}/usr/share/man/man1" \
	emake DESTDIR="${D}" install

	if ! use static-libs ; then
		rm "${ED}"/usr/$(get_libdir)/libxxhash.a || die
	fi
}
