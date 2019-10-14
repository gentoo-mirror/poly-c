# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 074bee78290222a183d62946398af47dbe7a3267 $

EAPI=5
inherit flag-o-matic

DESCRIPTION="Pulseaudio Volume Control, GTK based mixer for Pulseaudio"
HOMEPAGE="https://freedesktop.org/software/pulseaudio/pavucontrol/"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ~ppc64 ~sparc x86"
IUSE="gtk2 nls"

RDEPEND="
	gtk2? (
		>=dev-cpp/gtkmm-2.16:2.4
		>=media-libs/libcanberra-0.16[gtk]
	)
	!gtk2? (
		>=dev-cpp/gtkmm-3.0:3.0
		>=media-libs/libcanberra-0.16[gtk3]
	)
	>=dev-libs/libsigc++-2.2:2
	>=media-sound/pulseaudio-3[glib]
	virtual/freedesktop-icon-theme
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"

src_configure() {
	append-cxxflags -std=c++11 #567216
	econf \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html \
		--disable-lynx \
		$(use_enable !gtk2 gtk3) \
		$(use_enable nls)
}
