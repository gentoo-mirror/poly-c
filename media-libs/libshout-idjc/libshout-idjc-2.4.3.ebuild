# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

DESCRIPTION="Libshout-idjc is libshout plus some extensions for IDJC"
HOMEPAGE="https://sourceforge.net/projects/libshoutidjc.idjc.p/"
SRC_URI="mirror://sourceforge/${PN/-}.idjc.p/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="speex static-libs"

RDEPEND="media-libs/libogg
	media-libs/libvorbis
	speex? ( media-libs/speex )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable speex)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" -name "*.la" -delete || die
}
