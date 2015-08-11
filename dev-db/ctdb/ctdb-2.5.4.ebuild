# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib-minimal

DESCRIPTION="A cluster implementation of the TDB database used to store temporary data"
HOMEPAGE="http://ctdb.samba.org/"
SRC_URI="ftp://ftp.samba.org/pub/ctdb/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=">=dev-libs/popt-1.16-r2[${MULTILIB_USEDEP}]
	>=sys-libs/tdb-1.2.11
	>=sys-libs/talloc-2.1.0
	>=sys-libs/tevent-0.9.1"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch_user

	# custom, broken Makefile
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--localstatedir="${EPREFIX}/var" \
		--with-logdir="${EPREFIX}/var/log/${PN}"
}

multilib_src_install_all() {
	einstalldocs
	dohtml web/* doc/*.html

	dodir /var/lib/ctdb
	dodir /var/run/ctdb
	dodir /var/log/ctdb

	newenvd "${FILESDIR}"/55ctdb.env 55ctdb
	newinitd "${FILESDIR}"/ctdb.initd-r1 ctdb

	insinto /etc/ctdb 
	doins "${FILESDIR}"/ctdbd.conf 
}
