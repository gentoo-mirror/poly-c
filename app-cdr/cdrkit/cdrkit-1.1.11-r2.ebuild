# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 9a857f44f5f9c8d9153d7de19e2ed6d9d40a7140 $

EAPI=7
inherit cmake flag-o-matic

DESCRIPTION="A set of tools for CD/DVD reading and recording, including cdrecord"
HOMEPAGE="http://cdrkit.org"
SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="debug hfs unicode"

RDEPEND="app-arch/bzip2
	!<app-cdr/cdrtools-99
	dev-libs/libcdio-paranoia:=
	sys-apps/file
	sys-libs/zlib
	unicode? ( virtual/libiconv )
	kernel_linux? ( sys-libs/libcap )"
DEPEND="${RDEPEND}
	hfs? ( sys-apps/file )"

PATCHES=(
	"${FILESDIR}"/${P}-cmakewarn.patch
	"${FILESDIR}"/${P}-paranoiacdda.patch
	"${FILESDIR}"/${P}-paranoiacdio.patch
)

src_prepare() {
	cmake_src_prepare

	echo '.so wodim.1' > ${T}/cdrecord.1 || die
	echo '.so genisoimage.1' > ${T}/mkisofs.1 || die
	echo '.so icedax.1' > ${T}/cdda2wav.1 || die
	echo '.so readom.1' > ${T}/readcd.1 || die
}

src_configure() {
	# gcc10 workaround
	append-cflags -fcommon

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dosym wodim /usr/bin/cdrecord
	dosym genisoimage /usr/bin/mkisofs
	dosym icedax /usr/bin/cdda2wav
	dosym readom /usr/bin/readcd

	dodoc ABOUT Changelog FAQ FORK TODO doc/{PORTABILITY,WHY}

	local x
	for x in genisoimage plattforms wodim icedax; do
		docinto ${x}
		dodoc doc/${x}/*
	done

	insinto /etc
	newins wodim/wodim.dfl wodim.conf
	newins netscsid/netscsid.dfl netscsid.conf

	insinto /usr/include/scsilib
	doins include/*.h
	insinto /usr/include/scsilib/usal
	doins include/usal/*.h
	dosym usal /usr/include/scsilib/scg

	doman "${T}"/*.1
}
