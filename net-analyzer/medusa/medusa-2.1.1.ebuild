# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A Modular,Parallel,Multiprotocol, Network Login Auditor"
HOMEPAGE="http://www.foofus.net/jmk/medusa/medusa.html"
SRC_URI="http://www.foofus.net/jmk/tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug ncp postgres +ssh2 subversion afp"

RDEPEND="ssh2? ( net-libs/libssh2 )
	ncp? ( net-fs/ncpfs )
	postgres? ( dev-db/postgresql-base:8.4 )
	subversion? ( dev-vcs/subversion )
	dev-libs/openssl
	afp? ( net-fs/afpfs-ng )"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--with-default-mod-path="/usr/lib/${PN}/modules" \
		$(use_enable debug) \
		$(use_enable ssh2 module-ssh) \
		$(use_enable ncp module-ncp) \
		$(use_enable postgres module-postgres) \
		$(use_enable subversion module-svn) \
		$(use_enable afp module-afp)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README TODO ChangeLog
	dohtml doc/*.html
}
