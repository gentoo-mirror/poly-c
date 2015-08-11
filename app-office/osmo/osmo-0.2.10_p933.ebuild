# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic

MY_P="${P/_*}"

DESCRIPTION="A handy personal organizer"
HOMEPAGE="http://clayo.org/osmo/"
SRC_URI="mirror://sourceforge/${PN}-pim/${MY_P}.tar.gz
	http://www.gentoofan.org/files/${P}.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sync"

RDEPEND=">=x11-libs/gtk+-2.12:2
	>=dev-libs/libtar-1.2.11-r3
	dev-libs/libxml2:2
	dev-libs/libgringotts
	>=dev-libs/libical-0.33
	app-text/gtkspell:2
	gnome-extra/gtkhtml:2
	>=x11-libs/libnotify-0.7
	sync? ( app-pda/libsyncml )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${DISTDIR}"/${P}.patch.xz \
		"${FILESDIR}/${MY_P}-automake-1.13.patch"
	eautoreconf
}

src_configure() {
	append-flags -I/usr/include/libical

	econf \
		--disable-dependency-tracking \
		$(use_with libsyncml)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TRANSLATORS
}
