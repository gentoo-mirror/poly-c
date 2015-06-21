# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

MY_P="Transcoder_${PV}"

DESCRIPTION="Transcoder is a video converter for Linux using GTK+ as GUI toolkit and ffmpeg as backend."
HOMEPAGE="http://transcoder84.sourceforge.net/"
SRC_URI="mirror://sourceforge/transcoder84/${MY_P}.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_configure() {
	:
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
