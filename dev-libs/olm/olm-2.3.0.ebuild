# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An implementation of the Double Ratchet cryptographic ratchet in C++"
HOMEPAGE="https://git.matrix.org/git/olm/about/"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI=""
else
	SRC_URI="https://git.matrix.org/git/${PN}/snapshot/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="debug"

src_prepare() {
	default
	sed \
		-e '/^LDFLAGS/d' \
		-e 's@-Wall -Werror@@' \
		-e "s@\$(PREFIX)/lib@\$(PREFIX)/$(get_libdir)@g" \
		-i Makefile || die
	if ! use debug ; then
		sed '/^all:/s@ debug@@' -i Makefile || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" AR="$(tc-getAR)"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${ED}" install
}
