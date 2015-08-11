# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

IUSE=""

MY_P=${PN/-/_}_v${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="no-ip.com dynamic DNS updater"
HOMEPAGE="http://www.no-ip.com"
SRC_URI="http://www.no-ip.com/client/linux/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
RESTRICT="nomirror"

DEPEND="virtual/libc"

src_unpack() {
	# use this when noip removes the package from their HP
	#tar -xzf ${FILESDIR}/${MY_P}.tar.gz -C ${WORKDIR}
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/noip.c.patch || die
}

pkg_config() {
	cd /tmp
	einfo "Answer the following questions."
	(no-ip.sh && mv no-ip.conf /etc/no-ip.conf) || die
	ln -s /etc/no-ip.conf /usr/lib/no-ip.conf >& /dev/null
}

src_compile() {
	emake || die
}

src_install() {
	into /usr
	dosbin noip
	dosbin no-ip.sh
	docinto ${P}
	dodoc README.FIRST
	exeinto /etc/init.d
	newexe "${FILESDIR}"/noip.start noip
	prepalldocs
}

pkg_postinst() {

	elog "Configuration can be done manually via:"
	elog "/usr/sbin/no-ip.sh; or "
	elog "first time you use the /etc/init.d/noip script; or"
	elog "by using this ebuild's config option."
}
