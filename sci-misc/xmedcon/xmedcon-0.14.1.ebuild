# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Medical Image Conversion Utility"
HOMEPAGE="http://xmedcon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk png"

RDEPEND="
	gtk? ( x11-libs/gtk+:2 )
	png? ( media-libs/libpng:= )
"

DEPEND="$RDEPEND"

src_configure() {
	local myeconfargs=(
		$(use_enable gtk gui)
		$(use_enable png)
	)
	econf ${myeconfargs[@]}
}

src_install() {
	default

	dodoc AUTHORS COPYING* INSTALL NEWS README REMARKS

	dodir /usr/share/pixmaps
	insinto /usr/share/pixmaps
	doins "${S}/etc/xmedcon.png"
}
