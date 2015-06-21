# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# polyc_x.eclass: eclass for all X ebuilds and their dependencies created by me, Polynomial-C
# eclass testes with x11-libs/pixman

inherit poly-c_ebuilds

SRC_URI="${SRC_URI/${P}/${MY_P}}"
