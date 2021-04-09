# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit poly-c_ebuilds

DESCRIPTION="FlightGear data files"
HOMEPAGE="https://www.flightgear.org/"
SRC_URI="mirror://sourceforge/flightgear/FlightGear-${MY_PV}-data.txz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/fgdata

src_install() {
	insinto /usr/share/flightgear
	rm -fr .git
	doins -r *
}