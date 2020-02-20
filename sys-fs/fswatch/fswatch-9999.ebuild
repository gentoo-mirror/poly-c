# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="cross-platform file change monitor with multiple backends"
HOMEPAGE="https://github.com/emcrisostomo/fswatch"
if [[ "${PV}" == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/emcrisostomo/fswatch"
else
	SRC_URI="https://github.com/emcrisostomo/${PN}/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE=""
SLOT="0"

IUSE="docker nls static-libs"

src_prepare() {
	default
	[[ "${PV}" == *9999 ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable docker)
		$(use_enable nls)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}
