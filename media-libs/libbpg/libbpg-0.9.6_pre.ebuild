# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils poly-c_ebuilds

DESCRIPTION="BPG (Better Portable Graphics) is a new image format"
HOMEPAGE="http://bellard.org/bpg/"
SRC_URI="http://bellard.org/bpg/${MY_P}.tar.gz"
LICENSE="LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="x265"

RDEPEND="${DEPEND}
	media-libs/libjpeg-turbo
	media-libs/libpng:0
	x265? ( media-libs/x265:= )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9.6-numa_linking.patch

	sed \
		-e '/^prefix=/s@/usr/local@/usr@' \
		-e "/^CFLAGS:=/s@-Os@${CFLAGS}@" \
		-e "/^LDFLAGS=/s@-g@${LDFLAGS}@" \
		-e '/install/s@$(prefix)@$(DESTDIR)usr@' \
		-e '/install/s@-s@@' \
		-i Makefile || die

	if use x265 ; then
		sed \
			-e '/^#USE_X265=/s@#@@' \
			-i Makefile || die
	fi
}

src_install() {
	dodir /usr/bin
	default
}
