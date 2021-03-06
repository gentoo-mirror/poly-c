# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit autotools poly-c_ebuilds

#WANT_AUTOMAKE="1.7"

DESCRIPTION="Ameter is an Alsa meter plugin"
HOMEPAGE="http://laugeo.free.fr/ameter.html"
SRC_URI="http://laugeo.free.fr/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND=">=media-libs/alsa-lib-1.0.11_rc2
	media-libs/libsdl
	media-libs/sdl-image"

src_prepare() {
	default
	eautoreconf
}
