# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 77337142ec368ef43c179461f5ca0beb09d5cd21 $

EAPI=7

inherit cmake-utils

DESCRIPTION="DXT compression library"
HOMEPAGE="https://sourceforge.net/projects/libsquish/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_prepare() {
	sed \
		-e "/\bARCHIVE\b/s@lib@$(get_libdir)@" \
		-e "/\bLIBRARY\b/s@lib@$(get_libdir)@" \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}
