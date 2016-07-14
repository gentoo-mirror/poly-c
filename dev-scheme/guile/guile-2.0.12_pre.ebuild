# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic poly-c_ebuilds

WANT_AUTOMAKE=1.12

DESCRIPTION="GNU Ubiquitous Intelligent Language for Extensions"
HOMEPAGE="http://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${MY_P}.tar.gz"

LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="debug debug-malloc +deprecated +networking nls +regex +threads"

RDEPEND="
	>=dev-libs/boehm-gc-7.0[threads?]
	dev-libs/gmp
	dev-libs/libffi
	dev-libs/libltdl
	>=dev-libs/libunistring-0.9.3
	sys-devel/gettext"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

SLOT="12"

src_configure() {
	# see bug #178499
	filter-flags -ftree-vectorize

	#will fail for me if posix is disabled or without modules -- hkBst
	econf \
		--disable-error-on-warning \
		--disable-static \
		--enable-posix \
		$(use_enable networking) \
		$(use_enable regex) \
		$(use_enable deprecated) \
		$(use_enable nls) \
		--disable-rpath \
		$(use_enable debug-malloc) \
		$(use_enable debug guile-debug) \
		$(use_with threads) \
		--with-modules
}

src_install() {
	default

	use debug || rm "${ED}"/usr/$(get_libdir)/*.scm

	dodoc AUTHORS ChangeLog GUILE-VERSION HACKING NEWS README THANKS

	# necessary for registering slib, see bug 206896
	keepdir /usr/share/guile/site

	
}

pkg_config() {
	if has_version dev-scheme/slib; then
		einfo "Registering slib with guile"
		install_slib_for_guile
	fi
}

_pkg_prerm() {
	rm -f "${EROOT}"/usr/share/guile/site/slibcat
}
