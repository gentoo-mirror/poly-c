# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCHVER="1.0"
ELF2FLT_VER=""
PV="${PV%_*}"
inherit toolchain-binutils

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd -sparc-fbsd ~x86-fbsd"

SRC_URI="mirror://kernel/linux/devel/binutils/binutils-${PV}.tar.bz2
	mirror://kernel/linux/devel/binutils/test/binutils-${PV}.tar.bz2
	mirror://gnu/binutils/binutils-${PV}.tar.bz2
	mirror://gentoo/binutils-2.29-patches-${PATCHVER}.tar.xz
	https://dev.gentoo.org/~tamiko/distfiles/binutils-2.29-patches-${PATCHVER}.tar.xz
	http://dev.gentoo.org/~vapier/dist/binutils-2.29-patches-${PATCHVER}.tar.xz"
