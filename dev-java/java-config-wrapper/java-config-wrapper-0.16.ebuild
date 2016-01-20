# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 7e8286f4bd776000c0744b7f4f8c2e9182388ace $

EAPI=5

inherit eutils

DESCRIPTION="Wrapper for java-config"
HOMEPAGE="https://www.gentoo.org/proj/en/java"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="!<dev-java/java-config-1.3"
RDEPEND="app-portage/portage-utils
	>=sys-apps/gentoo-functions-0.5"

src_prepare() {
	epatch "${FILESDIR}"/${P}-dont_source_functions_sh_from_etc_initd.patch
}

src_compile() {
	:;
}

src_install() {
	dobin src/shell/* || die
	dodoc AUTHORS || die
}
