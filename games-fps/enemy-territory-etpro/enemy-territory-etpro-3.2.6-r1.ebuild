# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: fdef1bd42faf06657dbf5ba0656a39355256726e $

EAPI=2

GAME="enemy-territory"
MOD_DESC="a series of minor additions to Enemy Territory to make it more fun"
MOD_NAME="ETPro"
MOD_DIR="etpro"

inherit games games-mods

HOMEPAGE="http://bani.anime.net/etpro/"
SRC_URI="http://etpro.anime.net/etpro-${PV//./_}.zip"

LICENSE="all-rights-reserved"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"

QA_PREBUILT="${INS_DIR:1}/${MOD_DIR}/*so"

pkg_preinst() {
	if [ -d "${GAMES_PREFIX_OPT}/${GAME}/${MOD_DIR}" ] ; then
		rm -rf "${GAMES_PREFIX_OPT}/${GAME}/${MOD_DIR}"
	fi
}

pkg_postinst() {
	dosym "${dir}/${MOD_DIR}" "${GAMES_PREFIX_OPT}/${GAME}/${MOD_DIR}"
}
