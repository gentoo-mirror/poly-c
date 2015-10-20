# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# poly-c_gtk.eclass: eclass for some special gnome ebuilds.
# eclass testes with dev-libs/vala-common dev-libs/gobject-introspection-common

inherit poly-c_ebuilds

SRC_URI="mirror://gnome/sources/${GNOME_ORG_MODULE}/${GNOME_ORG_PVP}/${GNOME_ORG_MODULE}-${MY_PV}.tar.${GNOME_TARBALL_SUFFIX}"
S="${WORKDIR}/${GNOME_ORG_MODULE}-${MY_PV}"
