# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit poly-c_ebuilds

DESCRIPTION="Web Server vulnerability scanner."
HOMEPAGE="http://www.cirt.net/nikto2"
SRC_URI="https://github.com/sullo/nikto/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND="
	dev-lang/perl
	net-analyzer/nmap
	ssl? (
		dev-libs/openssl
		dev-perl/Net-SSLeay
	)
	>=net-libs/libwhisker-2.5
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/program"

PATCHES=(
)

src_prepare() {
	#rm docs/._* || die "removing osx files failed"
	rm plugins/LW2.pm || die "removing bundled lib LW2.pm failed"
	eapply -p2 "${FILESDIR}"/${MY_P}-PL.patch
	eapply_user
}

src_install() {
	insinto /etc/nikto
	doins "${FILESDIR}/nikto.conf"

	dobin nikto.pl
	dosym /usr/bin/nikto.pl /usr/bin/nikto

	insinto /usr/share/nikto
	doins docs/nikto.dtd

	insinto /var/lib/nikto
	doins -r templates plugins

	dodoc docs/*.txt
	docinto html
	dodoc docs/nikto_manual.html
	doman docs/nikto.1
}

pkg_postinst() {
	elog 'Default configuration file is "/etc/nikto/nikto.conf"'
}
