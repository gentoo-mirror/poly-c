# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="The NIFTI IO Library"
HOMEPAGE="http://sourceforge.net/projects/niftilib/"
SRC_URI="mirror://sourceforge/niftilib/${P}.tar.gz"
LICENSE="public-domain"

KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/findlibm.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_INSTALL_PREFIX=/usr
	)
	cmake-utils_src_configure
}
