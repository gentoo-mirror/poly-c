# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 77337142ec368ef43c179461f5ca0beb09d5cd21 $

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Libpurple protocol plugin for matrix"
HOMEPAGE="https://github.com/matrix-org/purple-matrix"
if [[ "${PV}" ==  9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/matrix-org/${PN}.git"
else
	SRC_URI="https://github.com/matrix-org/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE=""
SLOT="0"

IUSE=""

RDEPEND="
	dev-db/sqlite
	dev-libs/glib:2
	dev-libs/json-glib
	net-im/pidgin
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_compile() {
	emake CC="$(tc-getCC)" PKG_CONFIG="$(tc-getBUILD_PKG_CONFIG)"
}
