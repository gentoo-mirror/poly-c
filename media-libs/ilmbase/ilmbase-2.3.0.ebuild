# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 8e86f6eadb1b7ccf1d7f4f8018c1384e32b0f54e $

EAPI=6
inherit multilib-minimal

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="https://github.com/openexr/openexr/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/24" # based on SONAME
KEYWORDS="amd64 -arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="static-libs"

DEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.0-testBox.patch
	#"${FILESDIR}"/${PN}-2.3.0-avoid_bashisms.patch
)

DOCS=( AUTHORS ChangeLog NEWS README.md )
MULTILIB_WRAPPED_HEADERS=( /usr/include/OpenEXR/IlmBaseConfig.h )

multilib_src_configure() {
	# Disable use of ucontext.h wrt #482890
	if use hppa || use ppc || use ppc64; then
		export ac_cv_header_ucontext_h=no
	fi

	CONFIG_SHELL="/bin/bash" \
	ECONF_SOURCE=${S} econf "$(use_enable static-libs static)"
}

multilib_src_install_all() {
	einstalldocs

	# package provides pkg-config files
	find "${D}" -name '*.la' -delete || die
}
