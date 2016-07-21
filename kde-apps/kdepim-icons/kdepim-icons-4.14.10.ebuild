# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 99bfee8c633a54701fcd7253723af594cfb913b6 $

EAPI=5

KMNAME="kdepim"
EGIT_BRANCH="KDE/4.14"
KMMODULE="icons"
inherit kde4-meta

DESCRIPTION="KDE PIM icons"
IUSE=""
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"

DEPEND="$(add_kdeapps_dep kdepimlibs 'akonadi(+)')"
RDEPEND=""
