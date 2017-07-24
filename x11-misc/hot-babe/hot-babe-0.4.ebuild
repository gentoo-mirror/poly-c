# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Cairo and Compositing version of hot-babe CPU monitor"
HOMEPAGE="https://github.com/allanlw/hot-babe"
SRC_URI="https://github.com/allanlw/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-0.4-makefile.patch"
)

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}