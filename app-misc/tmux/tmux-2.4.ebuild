# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 4d84d63538c323cf9b031f314b86ec3448b3b36f $

EAPI=6

inherit autotools flag-o-matic versionator

DESCRIPTION="Terminal multiplexer"
HOMEPAGE="http://tmux.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug selinux utempter vim-syntax kernel_FreeBSD kernel_linux"

CDEPEND="
	dev-libs/libevent:0=
	|| (
		=dev-libs/libevent-2.0*
		>=dev-libs/libevent-2.1.5-r4
	)
	utempter? (
		kernel_linux? ( sys-libs/libutempter )
		kernel_FreeBSD? ( || ( >=sys-freebsd/freebsd-lib-9.0 sys-libs/libutempter ) )
	)
	sys-libs/ncurses:0="
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-libs/libevent:=
	selinux? ( sec-policy/selinux-screen )
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)"

DOCS=( CHANGES FAQ README TODO )

SRC_URI+="
	https://github.com/tmux/tmux/commit/2c9bdd9e326723fb392aed4d8df12cba7ef34f1f.patch -> ${PN}-2.4-memleaks_1.patch
	https://github.com/tmux/tmux/commit/1e0eb914d945e0f287716d56669d0de409e86e59.patch -> ${PN}-2.4-memleak_2.patch
	https://github.com/tmux/tmux/commit/c48d09ec8870ac218d6cc2bbec638d59839eda27.patch -> ${PN}-2.4-term_config_update.patch
	https://github.com/tmux/tmux/commit/03d01eabb5c5227f56b6b44d04964c1328802628.patch -> ${PN}-2.4-grid_colors.patch
	https://github.com/tmux/tmux/commit/d520dae6ac9acf980d48fbc8307ac83a5cee2938.patch -> ${PN}-2.4-term_copy_n_paste.patch
	https://github.com/tmux/tmux/commit/54e2205e545d72d8d9ccaadfd4d1212bafb2f41b.patch -> ${PN}-2.4-konsole_scroll_region.patch
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4-flags.patch

	# usptream fixes (can be removed with next version bump)
	"${DISTDIR}/${P}-memleaks_1.patch"
	"${DISTDIR}/${P}-memleak_2.patch"
	"${DISTDIR}/${P}-term_config_update.patch"
	"${DISTDIR}/${P}-grid_colors.patch"
	"${DISTDIR}/${P}-term_copy_n_paste.patch"
	"${DISTDIR}/${P}-konsole_scroll_region.patch"
)

src_prepare() {
	# bug 438558
	# 1.7 segfaults when entering copy mode if compiled with -Os
	replace-flags -Os -O2

	# regenerate aclocal.m4 to support earlier automake versions
	rm aclocal.m4 || die

	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc
		$(use_enable debug)
		$(use_enable utempter)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	einstalldocs

	dodoc example_tmux.conf
	docompress -x /usr/share/doc/${PF}/example_tmux.conf

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}"/tmux.vim
	fi
}

pkg_postinst() {
	if ! version_is_at_least 1.9a ${REPLACING_VERSIONS:-1.9a}; then
		echo
		ewarn "Some configuration options changed in this release."
		ewarn "Please read the CHANGES file in /usr/share/doc/${PF}/"
		ewarn
		ewarn "WARNING: After updating to ${P} you will _not_ be able to connect to any"
		ewarn "older, running tmux server instances. You'll have to use an existing client to"
		ewarn "end your old sessions or kill the old server instances. Otherwise you'll have"
		ewarn "to temporarily downgrade to access them."
		echo
	fi
}
