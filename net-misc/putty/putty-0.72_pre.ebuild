# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils gnome2-utils toolchain-funcs poly-c_ebuilds

DESCRIPTION="A Free Telnet/SSH Client"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/putty/"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc +gtk gtk2 ipv6 gssapi"
SRC_URI="
	https://dev.gentoo.org/~jer/${PN}-icons.tar.bz2
	https://the.earth.li/~sgtatham/${PN}/latest/${MY_P}.tar.gz
"

RDEPEND="
	!net-misc/pssh
	gtk? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf
		x11-libs/libX11
		x11-libs/pango
		gtk2? ( x11-libs/gtk+:2 )
		!gtk2? ( x11-libs/gtk+:3[X] )
	)
	gssapi? ( virtual/krb5 )
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig
"

src_prepare() {
	default

	sed -i \
		-e 's|-Werror||g' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	cd "${S}"/unix || die
	econf \
		$(use_with gssapi) \
		$(usex gtk --with-gtk= --without-gtk $(usex gtk2 2 3 ) )
}

src_compile() {
	cd "${S}"/unix || die
	emake AR=$(tc-getAR) $(usex ipv6 '' COMPAT=-DNO_IPV6)
}

src_install() {
	dodoc doc/puttydoc.txt

	if use doc; then
		docinto html
		dodoc doc/*.html
	fi

	cd "${S}"/unix || die
	default

	if use gtk ; then
		for i in 16 22 24 32 48 64 128 256; do
			newicon -s ${i} "${WORKDIR}"/${PN}-icons/${PN}-${i}.png ${PN}.png
		done

		# install desktop file provided by Gustav Schaffter in #49577
		make_desktop_entry ${PN} PuTTY ${PN} Network
	fi
}

pkg_preinst() {
	use gtk && gnome2_icon_savelist
}

pkg_postinst() {
	use gtk && gnome2_icon_cache_update
}

pkg_postrm() {
	use gtk && gnome2_icon_cache_update
}
