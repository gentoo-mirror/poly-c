# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils poly-c_ebuilds

PATCH="${PN}-2.0.2-gentoo.patch"

DESCRIPTION="cutmp3 is a small and fast command line MP3 editor."
HOMEPAGE="http://www.puchalla-online.de/cutmp3.html"
SRC_URI="http://www.puchalla-online.de/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde"
RDEPEND="sys-libs/readline:0=
	sys-libs/ncurses:0=
	media-sound/mpg123"
DEPEND=""

src_prepare() {
	sed -e "s:@VERSION@:${MY_PV}:" "${FILESDIR}/${PATCH}" \
		> "${T}/${PATCH}" \
			|| die "sed ${PATCH} failed"
	eapply "${T}/${PATCH}"
	eapply_user
}

src_install() {
	emake install || die "emake failed"
	if use kde ; then
		insinto /usr/share/apps/konqueror/servicemenus
		doins ${PN}.desktop
	fi
}
