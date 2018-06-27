# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit autotools user poly-c_ebuilds

DESCRIPTION="arpalert is used for monitoring ethernet networks"
HOMEPAGE="http://www.arpalert.org/"
SRC_URI="http://www.arpalert.org/src/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug syslog"
DEPEND=""

pkg_setup() {
	enewuser ${PN} -1 -1 -1 nogroup \
		|| die "failed to create user \"${PN}\""
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--localstatedir=/var
		$(use_enable debug)
		$(use_with syslog)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc CHANGES README VERSION
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/lib/${PN}
	chown ${PN} "${ED}"/var/lib/${PN} || die "chown failed"
}

pkg_postrm() {
	elog "After removing this package from your system, run"
	elog "\"userdel -f ${PN}\""
	elog "to remove ${PN}-user, too."
}
