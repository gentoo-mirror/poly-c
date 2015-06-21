# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="C client library for Redis"
HOMEPAGE="http://code.google.com/p/credis/"
SRC_URI="http://credis.googlecode.com/files/${P}.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.2.3-gentoo.patch
}

src_install() {
	dolib libcredis.so

	insinto /usr/include
	doins credis.h
}
