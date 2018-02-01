# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 129f61dcdb296c77af1e8e1100091e02cce7515e $

EAPI=6

DESCRIPTION="Generate a LaTeX file for fingerprint slips"
HOMEPAGE="https://anonscm.debian.org/viewvc/pgp-tools/trunk/gpg-key2latex/gpg-key2latex"
SRC_URI="https://anonscm.debian.org/viewvc/pgp-tools/trunk/${PN}/${PN}?revision=${PV}&view=co -> ${P}"
LICENSE="GPL-3+"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/GnuPG-Interface"

S="${WORKDIR}"

src_install() {
	newbin "${DISTDIR}/${P}" ${PN}
}
