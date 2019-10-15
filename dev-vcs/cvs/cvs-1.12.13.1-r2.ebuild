# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pam toolchain-funcs eapi7-ver

DESCRIPTION="Concurrent Versions System - source code revision control tools"
HOMEPAGE="http://cvs.nongnu.org/"

DOC_PV="$(ver_cut 1-3)"
SRC_URI="mirror://gnu/non-gnu/cvs/source/feature/${PV}/${P}.tar.bz2
	doc? ( mirror://gnu/non-gnu/cvs/source/feature/${DOC_PV}/cederqvist-${DOC_PV}.html.tar.bz2
		mirror://gnu/non-gnu/cvs/source/feature/${DOC_PV}/cederqvist-${DOC_PV}.pdf
		mirror://gnu/non-gnu/cvs/source/feature/${DOC_PV}/cederqvist-${DOC_PV}.ps )"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="crypt doc kerberos nls pam server"
RESTRICT="test"

DEPEND=">=sys-libs/zlib-1.1.4
	kerberos? ( virtual/krb5 )
	pam? ( sys-libs/pam )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${P}.tar.bz2
	use doc && unpack cederqvist-${DOC_PV}.html.tar.bz2
}

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.12-cvsbug-tmpfix.patch
	"${FILESDIR}"/${PN}-1.12.12-install-sh.patch
	"${FILESDIR}"/${PN}-1.12.13.1-block-requests.patch
	"${FILESDIR}"/${PN}-1.12.13.1-hash-nameclash.patch # for AIX
	"${FILESDIR}"/${PN}-1.12.13.1-gl-mempcpy.patch # for AIX
	"${FILESDIR}"/${PN}-1.12.12-fix-massive-leak.patch
	"${FILESDIR}"/${PN}-1.12.13.1-use-include_next.patch
	"${FILESDIR}"/${PN}-1.12.13.1-fix-gnulib-SEGV-vasnprintf.patch
	# Applied by upstream:
	#"${FILESDIR}"/${PN}-1.12.13-openat.patch
	#"${FILESDIR}"/${PN}-1.12.13-zlib.patch

	# Own patches
	"${FILESDIR}"/${P}-allow_timeout_option_in_client.patch

	# Debian patches (taken from PLD Linux)
	"${FILESDIR}"/${PN}-debian-ext-exp.patch
	"${FILESDIR}"/${PN}-debian-homedir.patch
	"${FILESDIR}"/${PN}-debian-import-n-X.patch
)

DOCS=( BUGS ChangeLog{,.zoo} DEVEL-CVS FAQ HACKING MINOR-BUGS NEWS \
	PROJECTS README TESTS TODO )

src_prepare() {
	export CONFIG_SHELL=${BASH}  # configure fails without
	default
	sed -i "/^AR/s:ar:$(tc-getAR):" diff/Makefile.in lib/Makefile.in || die
}

src_configure() {
	if tc-is-cross-compiler ; then
		# Sane defaults when cross-compiling (as these tests want to
		# try and execute code).
		export cvs_cv_func_printf_ptr="yes"
	fi
	econf \
		--with-external-zlib \
		--with-tmpdir=${EPREFIX%/}/tmp \
		$(use_enable crypt encryption) \
		$(use_with kerberos gssapi) \
		$(use_enable nls) \
		$(use_enable pam) \
		$(use_enable server) \
		$(use_enable server proxy)
}

src_install() {
	# Not installed into emacs site-lisp because it clobbers the normal C
	# indentations.
	DOCS+=( cvs-format.el )

	if use doc; then
		DOCS+=( "${DISTDIR}"/cederqvist-${PV}.{pdf,ps} )
		HTML_DOCS=( ../cederqvist-${PV}.html/. )
	fi

	default

	use doc && dosym cvs.html /usr/share/doc/${PF}/html/index.html

	if use server; then
		newdoc "${FILESDIR}"/cvs-1.12.12-cvs-custom.c cvs-custom.c
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/cvspserver.xinetd.d cvspserver
		newenvd "${FILESDIR}"/01-cvs-env.d 01cvs
	fi

	newpamd "${FILESDIR}"/cvs.pam-include-1.12.12 cvs
}
