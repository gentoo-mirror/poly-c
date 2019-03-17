# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: f8dedbb1ce77f5ba39062e396c8d6f26757f7a44 $

EAPI=5

inherit xorg-2 poly-c_x

DESCRIPTION="X Window System initializer"

LICENSE="${LICENSE} GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="+minimal systemd"

RDEPEND="
	!<x11-base/xorg-server-1.8.0
	x11-apps/xauth
	x11-libs/libX11
	!systemd? ( sys-apps/openrc )
"
DEPEND="${RDEPEND}"
PDEPEND="x11-apps/xrdb
	!minimal? (
		x11-apps/xclock
		x11-apps/xsm
		x11-terms/xterm
		x11-wm/twm
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.3-gentoo-customizations.patch"
	"${FILESDIR}/${PN}-1.4.0-startx-current-vt.patch"
)

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		--with-xinitdir="${EPREFIX}"/etc/X11/xinit
	)
	xorg-2_src_configure
}

src_install() {
	xorg-2_src_install

	exeinto /etc/X11
	doexe "${FILESDIR}"/chooser.sh "${FILESDIR}"/startDM.sh
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}"/Xsession
	exeinto /etc/X11/xinit
	newexe "${FILESDIR}"/xserverrc.2 xserverrc
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}"/00-xhost

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/Xsession.desktop
}

pkg_postinst() {
	xorg-2_pkg_postinst
	if ! has_version 'x11-apps/xinit'; then
		ewarn "If you use startx to start X instead of a login manager like gdm/kdm,"
		ewarn "you can set the XSESSION variable to anything in /etc/X11/Sessions/ or"
		ewarn "any executable. When you run startx, it will run this as the login session."
		ewarn "You can set this in a file in /etc/env.d/ for the entire system,"
		ewarn "or set it per-user in ~/.bash_profile (or similar for other shells)."
		ewarn "Here's an example of setting it for the whole system:"
		ewarn "    echo XSESSION=\"Gnome\" > /etc/env.d/90xsession"
		ewarn "    env-update && source /etc/profile"
	fi
}