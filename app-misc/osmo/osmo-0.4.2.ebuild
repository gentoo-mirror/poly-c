# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 77337142ec368ef43c179461f5ca0beb09d5cd21 $

EAPI=7

DESCRIPTION="Handy personal organizer"
HOMEPAGE="http://clayo.org/osmo/"
SRC_URI="mirror://sourceforge/${PN}-pim/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	app-text/gspell
	dev-libs/glib:2
	dev-libs/libical
	dev-libs/libxml2
	net-libs/webkit-gtk:4
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/pango
"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)
	econf "${myeconfargs[@]}"
}
