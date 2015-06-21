# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils poly-c_ebuilds

PATCH="${PN}-2.0.2-gentoo.patch"

DESCRIPTION="cutmp3 is a small and fast command line MP3 editor."
HOMEPAGE="http://www.puchalla-online.de/cutmp3.html"
SRC_URI="http://www.puchalla-online.de/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde"
RDEPEND="sys-libs/readline
	sys-libs/ncurses
	media-sound/mpg123"
DEPEND=""

src_prepare() {
	sed -e "s:@VERSION@:${MY_PV}:" "${FILESDIR}/${PATCH}" \
		> "${T}/${PATCH}" \
			|| die "sed ${PATCH} failed"
	epatch "${T}/${PATCH}"
}

src_install() {
	emake install || die "emake failed"
	if use kde ; then
		insinto /usr/share/apps/konqueror/servicemenus
		doins ${PN}.desktop
	fi
}
