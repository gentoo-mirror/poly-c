# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils autotools poly-c_ebuilds
WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

DESCRIPTION="arpalert is used for monitoring ethernet networks"
HOMEPAGE="http://www.arpalert.org/"
SRC_URI="http://www.arpalert.org/src/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug syslog"
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	# use global CFLAGS
	#sed -e 's:CFLAGS:MY_CFLAGS:g' -e 's:-O2:$(CFLAGS):' -e 's: -O2::g' \
	#	-i "${S}"/Makefile.in || die "sed Makefile.in failed"
	eautoreconf
}

src_compile() {
	econf \
		--localstatedir=/var \
		$(use_enable debug) \
		$(use_with syslog) \
			|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGES README VERSION
	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die "failed to install init.d file"
	keepdir /var/lib/${PN}
	chown ${PN} "${D}"/var/lib/${PN} || eerror "chown failed"
}

pkg_setup() {
	enewuser ${PN} -1 -1 -1 nogroup \
		|| die "failed to create user \"${PN}\""
}

pkg_postrm() {
	elog "After removing this package from your system, run"
	elog "\"userdel -f ${PN}\""
	elog "to remove ${PN}-user, too."
}
