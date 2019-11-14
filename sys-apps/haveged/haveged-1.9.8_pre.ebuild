# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit systemd poly-c_ebuilds

DESCRIPTION="A simple entropy daemon using the HAVEGE algorithm"
HOMEPAGE="http://www.issihosts.com/haveged/"
#SRC_URI="https://github.com/jirka-h/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
SRC_URI="https://github.com/jirka-h/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="selinux static-libs"

RDEPEND="
	!<sys-apps/openrc-0.11.8
	selinux? ( sec-policy/selinux-entropyd )
"

# threads are broken right now, but eventually
# we should add $(use_enable threads)
src_configure() {
	econf \
		$(use_enable static-libs static) \
		--bindir=/usr/sbin \
		--enable-nistest \
		--disable-threads
}

src_install() {
	default

	# Install gentoo ones instead
	newinitd "${FILESDIR}"/haveged-init.d.3 haveged
	newconfd "${FILESDIR}"/haveged-conf.d haveged

	systemd_newunit "${FILESDIR}"/service.gentoo ${PN}.service
	insinto /etc
	doins "${FILESDIR}"/haveged.conf
}
