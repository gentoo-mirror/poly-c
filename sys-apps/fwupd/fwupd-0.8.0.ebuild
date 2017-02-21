# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 879789548a237c504a7cfc28e8c7b58d68f3246b $

EAPI=6

inherit autotools

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="http://www.fwupd.org"
SRC_URI="https://github.com/hughsie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="colorhug doc nls"

# Has automagic dependency on >=sys-auth/polkit-0.114
# which has not yet been released
DEPEND="
	app-crypt/gpgme
	virtual/pkgconfig
	colorhug? ( >=x11-misc/colord-1.2.12:0= )
	doc? ( dev-util/gtk-doc )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# Don't look for gtk-doc if doc USE is unset
	if ! use doc ; then
		sed 's@^GTK_DOC_CHECK@#\0@' -i configure.ac || die
		sed '/gtk-doc\.make/d' \
			-i {.,docs/{libdfu,libfwupd}}/Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		# requires libtbtfwu which is not packaged yet
		--disable-thunderbolt
		$(use_enable colorhug)
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}
