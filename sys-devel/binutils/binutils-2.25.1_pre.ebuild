# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.25-r1.ebuild,v 1.1 2015/05/25 08:53:36 vapier Exp $

EAPI="4"

PV="${PV%_*}"
P="${PN}-${PV}"
RESTRICT="mirror"

PATCHVER="1.2"
ELF2FLT_VER=""
inherit toolchain-binutils

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd -sparc-fbsd ~x86-fbsd"

SRC_URI="mirror://gnu/binutils/binutils-${PV}.tar.bz2
	http://dev.gentoo.org/~vapier/dist/binutils-2.25-patches-${PATCHVER}.tar"

EPATCH_EXCLUDE="63_all_binutils-2.24.90-pt-pax-flags-20141022.patch"
