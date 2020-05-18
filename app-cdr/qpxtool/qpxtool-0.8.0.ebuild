# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 2184a1651c3e4166cba1197b4d935e8547b261e5 $

EAPI=7

inherit toolchain-funcs

DESCRIPTION="CD/DVD quality checking utilities"
HOMEPAGE="http://qpxtool.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	media-libs/libpng:0=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qtchooser
"

DOCS="AUTHORS ChangeLog README SupportedDevices TODO"

PATCHES=(
	"${FILESDIR}/${P}-combined_fixes.patch"
	"${FILESDIR}/${PN}-0.8.0-nostrip.patch"
	"${FILESDIR}/${PN}-0.8.0-no_compressed_manpages.patch"
)

src_configure() {
	tc-export CXX
	./configure --prefix=/usr || die
}

src_install() {
	emake DESTDIR="${D}" cli_install
	emake DESTDIR="${D}" -j1 gui_install

	einstalldocs
}
