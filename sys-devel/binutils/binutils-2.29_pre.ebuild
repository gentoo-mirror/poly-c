# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCHVER="1.2"
ELF2FLT_VER=""
PV="${PV%_*}"
inherit toolchain-binutils

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd -sparc-fbsd ~x86-fbsd"

SRC_URI="mirror://kernel/linux/devel/binutils/binutils-${PV}.tar.bz2
	mirror://kernel/linux/devel/binutils/test/binutils-${PV}.tar.bz2
	mirror://gnu/binutils/binutils-${PV}.tar.bz2
	mirror://gentoo/binutils-2.28-patches-${PATCHVER}.tar.xz
	http://dev.gentoo.org/~vapier/dist/binutils-2.28-patches-${PATCHVER}.tar.xz
	http://dev.gentoo.org/~tamiko/distfiles/binutils-2.28-patches-${PATCHVER}.tar.xz
"

EPATCH_EXCLUDE+="
		00_all_0004-gold-ld-enable-gnu-hash-by-default.patch
		00_all_0009-CVE-2017-8394.patch
		00_all_0008-CVE-2017-8393.patch
		00_all_0007-CVE-2017-8398.patch
		00_all_0010-CVE-2017-8395.patch
		00_all_0011-CVE-2017-8396-CVE-2017-8397.patch
		00_all_0013-CVE-2017-9038.patch
		00_all_0014-CVE-2017-9039.patch
		00_all_0015-CVE-2017-9040-CVE-2017-9042.patch
		00_all_0016-CVE-2017-9041.patch
		00_all_0017-CVE-2017-7614.patch
		00_all_0018-CVE-2017-6965.patch
		00_all_0019-CVE-2017-6966.patch
		00_all_0020-CVE-2017-6969.patch
"