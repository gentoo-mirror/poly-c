# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: b7417a1b6064bbdd2ce050e0cc745bcb6f434132 $
    
EAPI=6
GNOME_ORG_MODULE="gtk-doc"
PYTHON_COMPAT=( python3_{6,7} )

inherit gnome.org python-single-r1

DESCRIPTION="Automake files from gtk-doc"
HOMEPAGE="https://www.gtk.org/gtk-doc/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-util/itstool
	virtual/pkgconfig
	!<dev-util/gtk-doc-${GNOME_ORG_PVP}
"
# This ebuild doesn't even compile anything, causing tests to fail when updating (bug #316071)
RESTRICT="test"

src_install() {
	emake DESTDIR="${D}" install-pylibdataDATA

	python_doexe gtkdoc-rebase

	python_fix_shebang "${ED}"

	insinto /usr/share/aclocal
	doins buildsystems/autotools/gtk-doc.m4
}
