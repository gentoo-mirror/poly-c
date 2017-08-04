# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="C client library for Redis"
HOMEPAGE="https://github.com/octo/credis"
SRC_URI="https://github.com/octo/${PN}/archive/v0.2.3.tar.gz -> ${P}.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.3-gentoo.patch
)

src_install() {
	dolib libcredis.so

	insinto /usr/include
	doins credis.h
}
