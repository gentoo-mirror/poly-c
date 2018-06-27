# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit desktop scons-utils subversion

ESVN_REPO_URI="svn://bos.seul.org/svn/bos/bos/trunk"

DESCRIPTION="Futuristic real-time strategy game"
HOMEPAGE="http://www.boswars.org/"
#SRC_URI="http://www.boswars.org/dist/releases/${P}-src.tar.gz
#mirror://gentoo/bos.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/lua
	media-libs/libsdl[sound,video]
	media-libs/libpng
	media-libs/libvorbis
	media-libs/libtheora
	media-libs/libogg
	virtual/opengl
	x11-libs/libX11"

S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6.1-gentoo.patch
	"${FILESDIR}"/${PN}-2.6.1-scons-blows.patch
)

src_prepare() {
	rm -f doc/{README-SDL.txt,guichan-copyright.txt}
	default
	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		engine/include/stratagus.h \
		|| die "sed stratagus.h failed"
	sed -i \
		-e "/-O2/s:-O2.*math:${CXXFLAGS} -Wall:" \
		SConstruct \
		|| die "sed SConstruct failed"
}

src_compile() {
	escons
}

src_install() {
	newbin build/${PN}-release ${PN}
	insinto /usr/share/${PN}
	doins -r campaigns graphics intro languages maps patches scripts \
		sounds units
	newicon "${FILESDIR}"/bos.png ${PN}.png
	make_desktop_entry ${PN} "Bos Wars"
	dodoc CHANGELOG COPYRIGHT.txt README.txt
	docinto html
	dodoc -r doc/*.html
}
