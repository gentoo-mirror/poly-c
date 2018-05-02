# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 meson poly-c_ebuilds

DESCRIPTION="Provides GObjects and helper methods to read and write AppStream metadata"
HOMEPAGE="https://people.freedesktop.org/~hughsient/appstream-glib/"
SRC_URI="https://people.freedesktop.org/~hughsient/${PN}/releases/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/8" # soname version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc +introspection nls stemmer"

RDEPEND="
	app-arch/gcab
	app-arch/libarchive
	dev-db/sqlite:3
	>=dev-libs/glib-2.45.8:2
	>=dev-libs/json-glib-1.1.1
	dev-libs/libyaml
	>=media-libs/fontconfig-2.11:1.0
	>=media-libs/freetype-2.4:2
	>=net-libs/libsoup-2.51.92:2.4
	sys-apps/util-linux
	>=x11-libs/gdk-pixbuf-2.31.5:2[introspection?]
	x11-libs/gtk+:3
	x11-libs/pango
	introspection? ( >=dev-libs/gobject-introspection-0.9.8:= )
	stemmer? ( dev-libs/snowball-stemmer )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.9
	>=sys-devel/gettext-0.19.7
	dev-util/gperf
"
# ${PN} superseeds appdata-tools, require dummy package until all ebuilds
# are migrated to appstream-glib
RDEPEND="${RDEPEND}
	!<dev-util/appdata-tools-0.1.8-r1
"

src_configure() {
	local emesonargs=(
		-Dbuilder="true"
		-Ddep11="true"
		-Dfonts="true"
		-Dgtk-doc="$(usex doc true false)"
		-Dintrospection="$(usex introspection true false)"
		-Dman="true"
		-Drpm="false"
		-Dstemmer="$(usex stemmer true false)"
	)
	meson_src_configure
}
