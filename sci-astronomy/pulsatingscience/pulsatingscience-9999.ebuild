# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 129f61dcdb296c77af1e8e1100091e02cce7515e $

EAPI=7

inherit qmake-utils git-r3

DESCRIPTION="3D binary pulsar animation and outreach application"
HOMEPAGE="https://gitlab.aei.uni-hannover.de/einsteinathome/pulsatingscience"
EGIT_REPO_URI="https://gitlab.aei.uni-hannover.de/einsteinathome/pulsatingscience.git"
LICENSE="GPL-3+"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${PN}-qt_include_fixes.patch"
)

src_compile() {
	lrelease ${PN}.pro || die
	eqmake5
	emake
}
