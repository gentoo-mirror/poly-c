# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PATCH_PV="2.26.1"
PATCHVER="1.0"
ELF2FLT_VER=""
PV="${PV%_*}"
inherit toolchain-binutils

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd -sparc-fbsd ~x86-fbsd"

SRC_URI="mirror://kernel/linux/devel/binutils/binutils-${PV}.tar.bz2
	mirror://kernel/linux/devel/binutils/test/binutils-${PV}.tar.bz2
	mirror://gnu/binutils/binutils-${PV}.tar.bz2
	mirror://gentoo/binutils-${PATCH_PV}-patches-${PATCHVER}.tar.xz
	http://dev.gentoo.org/~vapier/dist/binutils-${PATCH_PV}-patches-${PATCHVER}.tar.xz"

EPATCH_EXCLUDE+="
		00_all_0001-Add-mips-and-s390-build-targets-for-gold.patch
		00_all_0002-ld-Add-a-linker-configure-option-enable-relro.patch
		00_all_0003-ld-tests-make-address-matches-more-flexible.patch
"

src_prepare() {
	rm -r zlib || die
	toolchain-binutils_src_prepare
}
