# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 3c76118816bcebe121f239ab60223496d9ba866e $

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Utility to get detailed information about the CPU(s) using the
CPUID instruction"
HOMEPAGE="http://www.etallen.com/cpuid.html"
SRC_URI="http://www.etallen.com/${PN}/${P}.src.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${PN}-20170122-Makefile.patch
	"${FILESDIR}"/${PN}-20170122-sysmacros.patch
)

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	emake BUILDROOT="${D}" install || die "email install failed"
}
