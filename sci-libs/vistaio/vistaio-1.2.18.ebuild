# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit  cmake-utils

DESCRIPTION="Vista file IO library"
HOMEPAGE="http://mia.sf.net/"
SRC_URI="mirror://sourceforge/mia/vistaio-${PV}.tar.xz"
RESTRICT="primaryuri"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPENDS="app-arch/xz-utils"
