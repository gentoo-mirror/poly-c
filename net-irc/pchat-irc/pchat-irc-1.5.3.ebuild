# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat/xchat-2.8.8-r2.ebuild,v 1.16 2011/10/27 06:42:00 tetromino Exp $

EAPI=5

inherit eutils versionator gnome2 autotools

MY_PN="pchat"

DESCRIPTION="Graphical IRC client"
# Icons are from http://half-left.deviantart.com/art/XChat-IRC-Icon-200804640
SRC_URI="https://bitbucket.org/ZachThibeau/pchat-dev/downloads/${MY_PN}-${PV}.tar.xz"
HOMEPAGE="http://pchat-irc.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="dbus fastscroll +gtk ipv6 libnotify mmx nls ntlm perl python spell ssl tcl"

RDEPEND=">=dev-libs/glib-2.6.0:2
	gtk? ( >=x11-libs/gtk+-2.10.0:2 )
	ssl? ( >=dev-libs/openssl-0.9.6d )
	perl? ( >=dev-lang/perl-5.8.0 )
	python? ( =dev-lang/python-2* )
	tcl? ( dev-lang/tcl )
	dbus? ( >=dev-libs/dbus-glib-0.71 )
	spell? ( app-text/gtkspell:2 )
	libnotify? ( x11-libs/libnotify )
	ntlm? ( net-libs/libntlm )
	x11-libs/pango"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.16
	nls? ( sys-devel/gettext )"

S="${WORKDIR}"

pkg_setup() {
	# Added for to fix a sparc seg fault issue by Jason Wever <weeve@gentoo.org>
	if [[ ${ARCH} = sparc ]] ; then
		replace-flags "-O[3-9]" "-O2"
	fi
}

src_prepare() {
	pushd src &>/dev/null || die
	epatch "${FILESDIR}"/xchat-input-box4.patch \
		"${FILESDIR}"/xchat-2.8.4-interix.patch \
		"${FILESDIR}"/xchat-2.8.8-libnotify07.patch \
		"${FILESDIR}"/xchat-2.8.8-dbus.patch \
		"${FILESDIR}"/xchat-2.8.8-cflags.patch

	# use libdir/xchat/plugins as the plugin directory
	if [ $(get_libdir) != "lib" ] ; then
		sed -i -e 's:${prefix}/lib/pchat:${libdir}/pchat:' \
			"${S}"/configure.in || die
	fi

	# xchat sourcecode ships with po/Makefile.in.in from gettext-0.17
	# which fails with >=gettext-0.18
	cp "${EPREFIX}"/usr/share/gettext/po/Makefile.in.in "${S}"/po/ || die

	eautoreconf
}

src_configure() {
	# xchat's configure script uses sys.path to find library path
	# instead of python-config (#25943)
	unset PYTHONPATH

	if [[ ${CHOST} == *-interix* ]]; then
		# this -Wl,-E option for the interix ld makes some checks
		# false positives, so set those here.
		export ac_cv_func_strtoull=no
		export ac_cv_func_memrchr=no
	fi

	econf \
		--enable-shm \
		$(use_enable dbus) \
		$(use_enable ipv6) \
		$(use_enable mmx) \
		$(use_enable nls) \
		$(use_enable ntlm) \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable spell spell gtkspell) \
		$(use_enable ssl openssl) \
		$(use_enable tcl) \
		$(use_enable gtk gtkfe) \
		$(use_enable !gtk textfe) \
		$(use_enable fastscroll xft)
}

src_install() {
	USE_DESTDIR=1 gnome2_src_install || die "make install failed"

	# install plugin development header
	insinto /usr/include/pchat
	doins src/common/pchat-plugin.h || die "doins failed"

	dodoc ChangeLog README* || die "dodoc failed"

	# remove useless desktop entry when gtk USE flag is unset
	if ! use gtk ; then
		rm "${ED}"/usr/share/applications -rf
	fi

	# Don't install .la files
	find "${ED}" -name '*.la' -delete
}

pkg_postinst() {
	if ! use gtk ; then
		elog "You have disabled the gtk USE flag. This means you don't have"
		elog "the GTK-GUI for pchat but only a text interface called \"pchat-text\"."
	fi

	gnome2_icon_cache_update
}
