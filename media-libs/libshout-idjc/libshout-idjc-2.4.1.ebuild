# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="Libshout-idjc is libshout plus some extensions for IDJC"
HOMEPAGE="http://sourceforge.net/projects/idjc/files/libshout-idjc/"
SRC_URI="mirror://sourceforge/idjc/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="speex static-libs"

RDEPEND="media-libs/libogg
	media-libs/libvorbis
	speex? ( media-libs/speex )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.1-namespace.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable speex)
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files
}
