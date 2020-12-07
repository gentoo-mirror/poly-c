# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtomcrypt/Attic/libtomcrypt-1.17-r6.ebuild,v 1.3 2012/04/23 18:04:57 pacho dead $

EAPI=7

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="modular and portable cryptographic toolkit"
HOMEPAGE="https://www.libtom.net/LibTomCrypt/"
SRC_URI="https://github.com/libtom/${PN}/releases/download/v${PV}/crypt-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND="dev-libs/libtommath"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/ghostscript-gpl
		virtual/latex-base
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.18.2-gentoo.patch"
)

src_prepare() {
	use doc || sed -i '/^install:/s:docs::' makefile

	default

	sed -i \
		-e "s@--mode=link gcc@--mode=link $(tc-getCC) ${LDFLAGS} --tag CC $(tc-getCC)@g" \
		-e "s@ gcc@ $(tc-getCC)@g" \
		makefile.shared || die
}

src_compile() {
	append-flags -DLTM_DESC
	export LIBPATH="/usr/$(get_libdir)"
	EXTRALIBS="-ltommath" \
		CC="$(tc-getCC)" \
		PREFIX="${EPREFIX}/usr" \
		IGNORE_SPEED=1 \
		emake -f makefile.shared
}

src_test() {
	# Tests don't compile
	true
}

src_install() {
	emake -f makefile.shared DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc changes
	if use doc ; then
		dodoc doc/*
		docinto notes ; dodoc notes/*
		docinto demos ; dodoc demos/*
	fi

	find "${ED}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
}
