# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# polyc_x.eclass: eclass for all X ebuilds and their dependencies created by me, Polynomial-C
# eclass testes with x11-libs/pixman

inherit poly-c_ebuilds

MY_P=${QT5_MODULE}-everywhere-src-${MY_PV}
SRC_URI="https://download.qt.io/official_releases/qt/${MY_PV%.*}/${MY_PV/_/-}/submodules/${MY_P}.tar.xz"
S=${WORKDIR}/${MY_P}
