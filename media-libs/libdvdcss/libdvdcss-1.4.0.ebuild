# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: a7c535995883a8a171da01c8240b523b70124726 $

EAPI=5

inherit autotools-multilib

DESCRIPTION="A portable abstraction library for DVD decryption"
HOMEPAGE="http://www.videolan.org/developers/libdvdcss.html"
SRC_URI="http://download.videolan.org/pub/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="1.2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

#DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	EPATCH_OPTS="-R" \
	epatch "${FILESDIR}/${PN}-1.3.99-remove_raw_dvd_access.patch"

	autotools-multilib_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
		--htmldir=/usr/share/doc/${PF}/html
	)

	autotools-multilib_src_configure
}
