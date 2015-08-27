# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id $

EAPI=5

inherit autotools eutils

DESCRIPTION="sudosh is a sudo shell, filter and can be used as a login shell"
HOMEPAGE="http://sourceforge.net/projects/sudosh2"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=""
DEPENDS="virtual/logger"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf --with-defshell
}

pkg_postinst() {
	einfo "Configure sudosh to be used with sudo"
	einfo "====================================="
	einfo "1) configure /etc/sudoers to allow system administrators to execute"
	einfo "/usr/bin/sudosh"
	einfo ""
	einfo "Example entry to /etc/sudoers:"
	einfo ""
	einfo "-- /etc/sudoers begin --"
	einfo "User_Alias      ADMINS=admin1,admin2,admin3"
	einfo "User_Alias      DBAS=dba1,dba2,dba3"
	einfo "Cmnd_Alias      SUDOSH=/usr/bin/sudosh"
	einfo ""
	einfo "ADMINS          ALL=SUDOSH"
	einfo "DBAS            ALL=(oracle)/usr/bin/sudosh"
	einfo ""
	einfo "-- /etc/sudoers end --"
			
	einfo "Updating /etc/shells"
	grep -v "^/usr/bin/sudosh$" /etc/shells > "${T}"/shells
	echo "/usr/bin/sudosh" >> "${T}"/shells
	mv "${T}"/shells /etc/shells || \
		eerror "Failed to update /etc/shells"
}

pkg_postrm() {
	einfo "Updating /etc/shells"
	grep -v "^/usr/bin/sudosh$" /etc/shells > "${T}"/shells
	mv "${T}"/shells /etc/shells || \
		eerror "Failed to update /etc/shells"
}
