# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-info toolchain-funcs eutils

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/K1773R/numad.git"
	inherit git-r3
else
	SRC_URI="https://github.com/K1773R/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 -arm -s390 ~x86"
fi

DESCRIPTION="The NUMA daemon that manages application locality"
HOMEPAGE="http://fedoraproject.org/wiki/Features/numad"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

CONFIG_CHECK="~NUMA ~CPUSETS"

PATCHES=(
	"${FILESDIR}/${P}-destdir.patch"
)

src_prepare() {
	default
	sed \
		-e '/^[[:space:]]*update-rc.d/d' \
		-e '/^[[:space:]]*service/d' \
		-e '/\/etc\/init.d/d' \
		-e 's@/etc/default@/etc/conf.d@' \
		-e 's@/bin@/sbin@' \
		-i Makefile || die
	sed \
		-e 's@/usr/bin@/usr/sbin@g' \
		-i ${PN}.8 || die

	tc-export CC
}

src_configure() {
	:
}

src_compile() {
	emake CFLAGS="${CFLAGS} -std=gnu99"
}

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/${PN}.rc ${PN}
}
