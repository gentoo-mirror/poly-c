# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Cooledit is a full featured multiple window text editor"
HOMEPAGE="http://freshmeat.net/projects/cooledit/"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/apps/editors/X/cooledit/${P}.tar.gz
	https://dev.gentoo.org/~hwoarang/distfiles/${PN}-3.17.17-nopython.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="nls"

RDEPEND="x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libXau"
DEPEND="${RDEPEND}
	x11-libs/libXpm"

PATCHES=(
	"${FILESDIR}"/${PN}-3.17.17-gcc4.patch
	"${FILESDIR}"/${PN}-3.17.17-asneeded.patch
	#"${FILESDIR}"/${PN}-3.17.17-implicit_declarations.patch
	"${FILESDIR}"/${PN}-3.17.17-interix.patch
	"${FILESDIR}"/${PN}-3.17.17-interix5.patch
	#"${FILESDIR}"/${PN}-3.17.17-copy.patch
	"${WORKDIR}"/${PN}-3.17.17-nopython.patch
	"${FILESDIR}"/${P}-version.patch
)

src_prepare() {
	default
	sed -i -e "/Python.h/d" "${S}"/editor/_coolpython.c || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	[[ ${CHOST} == *-interix* ]] && export ac_cv_header_wchar_h=no

	# Fix for bug 40152 (04 Feb 2004 agriffis)
	addwrite /dev/ptym/clone:/dev/ptmx
	econf $(use_enable nls)
}
