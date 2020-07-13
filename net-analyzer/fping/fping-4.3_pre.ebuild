# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit fcaps poly-c_ebuilds

DESCRIPTION="A utility to ping multiple hosts at once"
HOMEPAGE="https://fping.org/"
SRC_URI="https://fping.org/dist/${MY_P}.tar.gz"

LICENSE="fping"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="ipv6 suid"

FILECAPS=( cap_net_raw+ep usr/sbin/fping )
PATCHES=(
	"${FILESDIR}/${PN}-4.3-disable-ipv6_build_fix.patch"
)

src_configure() {
	econf $(use_enable ipv6)
}

src_install() {
	default

	if use suid; then
		fperms u+s /usr/sbin/fping
	fi

	if use ipv6; then
		dosym fping /usr/sbin/fping6
	fi
}
