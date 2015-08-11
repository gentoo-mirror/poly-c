# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic poly-c_ebuilds

DESCRIPTION="Advanced TFTP implementation client/server"
HOMEPAGE="http://sourceforge.net/projects/atftp/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="selinux tcpd readline pcre"

DEPEND="tcpd? ( sys-apps/tcp-wrappers )
	selinux? ( sec-policy/selinux-tftp )
	readline? ( sys-libs/readline )
	pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}
	!net-ftp/netkit-tftp
	!net-ftp/tftp-hpa"

src_prepare() {
	# remove upstream's broken CFLAGS
	sed -i.orig -e \
		'/^CFLAGS="-g -Wall -D_REENTRANT"/d' \
		"${S}"/configure
}

src_compile() {
	append-flags -D_REENTRANT -DRATE_CONTROL
	econf \
		$(use_enable tcpd libwrap) \
		$(use_enable readline libreadline) \
		$(use_enable pcre libpcre) \
		--enable-mtftp
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	emake install DESTDIR="${D}"
	newinitd "${FILESDIR}"/atftp.init atftp
	newconfd "${FILESDIR}"/atftp.confd atftp

	dodoc README* BUGS FAQ Changelog INSTALL TODO
	dodoc "${S}"/docs/*

	docinto test
	cd test
	dodoc load.sh mtftp.conf pcre_pattern.txt test.sh test_suite.txt
}
