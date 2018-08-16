# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 5719fc04d4c477e6eb96712b1fcea44c8f8acaed $

EAPI=6

inherit ltprune pam

DESCRIPTION="PAM module for authenticating against PKCS#11 tokens"
HOMEPAGE="https://github.com/opensc/pam_p11/wiki"
SRC_URI="https://github.com/OpenSC/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="virtual/pam
		dev-libs/libp11
		dev-libs/openssl:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}"/${P}-openssl-1.1.patch
)

src_configure() {
	econf --with-pamdir="$(getpam_mod_dir)"
}

src_install() {
	default
	prune_libtool_files --all
}
