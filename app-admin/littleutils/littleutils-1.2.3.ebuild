# Copyright 1999-2021 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit python-single-r1

DESCRIPTION="The littleutils are a collection of small and simple utilities"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
HOMEPAGE="https://sourceforge.net/projects/littleutils/"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="png"

RDEPEND="
	${PYTHON_DEPEND}
	media-libs/imlib2
	png? (
		media-libs/libpng:0
	)
"
DEPEND="${RDEPEND}
	png? (
		media-gfx/pngcrush
		media-gfx/pngrewrite
	)
"

S="${WORKDIR}/${PN}-${PV/a}"

src_configure() {
	ac_cv_path_PROGPYTHON="${PYTHON}" econf
}

src_install() {
	default
	# Following are colliding with app-admin/realpath:
	rm "${ED}/usr/bin/realpath"
	rm "${ED}/usr/share/man/man1/realpath.1"
}
