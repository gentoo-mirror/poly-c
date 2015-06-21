# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# polyc_gtk.eclass: eclass for all gtk ebuilds and their dependencies created by me, Polynomial-C
# eclass testes with dev-libs/atk x11-libs/pango =x11-libs/gtk+-2.8*

inherit poly-c_ebuilds

MY_PVP=(${MY_PV//[-\._]/ })
SRC_URI="mirror://gnome/sources/${PN}/${MY_PVP[0]}.${MY_PVP[1]}/${MY_P}.tar.${GNOME_TARBALL_SUFFIX}"
