# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 688f948c5f3067e775bfab5057e8047f467a9ca9 $

EAPI=7

MY_PV="$(ver_rs 3 -)"
MY_P="${PN}-debian-${MY_PV}"

DESCRIPTION="setuid-root program"
HOMEPAGE="http://www.ucolick.org/~will/#super"
#SRC_URI="http://www.ucolick.org/~will/RUE/${PN}/${P}-tar.gz -> ${P}.tar.gz"
SRC_URI="https://salsa.debian.org/debian/super/-/archive/debian/${MY_PV}/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="pam"

RDEPEND="pam? ( sys-libs/pam )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eapply debian/patches
}

src_configure() {
	econf $(use_enable pam)
}
