# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal poly-c_ebuilds

if [[ ${MY_PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/mstorsjo/${PN}.git"
	[[ ${MY_PV%9999} != "" ]] && EGIT_BRANCH="release/${MY_PV%.9999}"
	inherit autotools git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
	if [[ ${MY_PV%_p*} != ${MY_PV} ]]; then # Gentoo snapshot
		SRC_URI="mirror://gentoo/${MY_P}.tar.xz"
	else # Official release
		SRC_URI="mirror://sourceforge/opencore-amr/${MY_P}.tar.gz"
	fi
fi

DESCRIPTION="Fraunhofer AAC codec library"
HOMEPAGE="https://sourceforge.net/projects/opencore-amr/"
LICENSE="FraunhoferFDK"
# subslot == N where N is libfdk-aac.so.N
SLOT="0/2"

IUSE="static-libs examples"

src_prepare() {
	default
	[[ ${MY_PV} == *9999* ]] && eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable examples example)
	)
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		mv "${ED%/}/usr/bin/"{,fdk-}aac-enc || die
	fi

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	use examples && einfo "aac-enc was renamed to fdk-aac-enc to prevent file collision with other packages"
}
