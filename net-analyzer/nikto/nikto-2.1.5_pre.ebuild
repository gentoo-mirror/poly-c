# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils poly-c_ebuilds

DESCRIPTION="Web Server vulnerability scanner."
HOMEPAGE="http://www.cirt.net/nikto2"
SRC_URI="http://www.cirt.net/source/nikto/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND="dev-lang/perl
		net-analyzer/nmap
		ssl? (
			dev-libs/openssl
			dev-perl/Net-SSLeay
		)
		>=net-libs/libwhisker-2.5"

RDEPEND="${DEPEND}"

src_prepare() {
	#rm docs/._* || die "removing osx files failed"
	rm plugins/LW2.pm || die "removing bundled lib LW2.pm failed"
	epatch "${FILESDIR}"/${MY_P}-PL.patch || die "patch failed"
}

src_install() {

	dodir /etc/nikto || die "dodir failed"
	insinto /etc/nikto
	doins "${FILESDIR}/nikto.conf" || die "doins failed"

	dobin nikto.pl || die "dobin failed"
	dosym /usr/bin/nikto.pl /usr/bin/nikto || die "dobin failed"

	dodir /usr/share/nikto || die "dodir failed"
	insinto /usr/share/nikto
	doins docs/nikto.dtd || die "dodoc failed"

	dodir /var/lib/nikto || die "dodir failed"
	insinto /var/lib/nikto
	doins -r templates plugins || die "doins failed"

	dodoc docs/*.txt || die "dodoc failed"
	dohtml docs/nikto_manual.html || die "dohtml failed"
	doman docs/nikto.1 || die "doman failed"
}

pkg_postinst() {
	elog 'Default configuration file is "/etc/nikto/nikto.conf"'
}
