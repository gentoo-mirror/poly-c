# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit poly-c_ebuilds

DESCRIPTION="QAMix is a configurable mixer for ALSA. Interfaces for AC 97 cards and Soundblaster Live are provided."
SRC_URI="http://mesh.dl.sourceforge.net/sourceforge/alsamodular/${MY_P}.tar.bz2"
HOMEPAGE="http://alsamodular.sourceforge.net/"

SLOT="0"
LICENSE="GPL"
KEYWORDS="~x86"

DEPEND="=x11-libs/qt-3*"

src_compile() {
    sed \
       -e "s:/usr/lib/qt3:${QTDIR}:" \
       -e "s:-O2 -g:${CXXFLAGS}:" \
       < make_qamix > Makefile

    emake || die
}
			

src_install () {
    dobin qamix || die

    insinto /usr/share/${PN}
    doins *.xml
    
    
    dodoc LICENSE README
}
