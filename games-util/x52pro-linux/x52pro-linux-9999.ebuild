# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 65ea285b3cab02a5a25d0cadfed6c0f21613eeab $

EAPI=6

SCM=
[[ "${PV}" = 9999 ]] && SCM="git-r3"

inherit autotools ${SCM}

DESCRIPTION="Saitek X52pro drivers & controller mapping software for Linux"
HOMEPAGE="https://github.com/nirenjan/x52pro-linux"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="ftp://foo.example.org/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="https://github.com/nirenjan/x52pro-linux.git"
fi

LICENSE="GPL2"
SLOT="0"
IUSE=""

DEPEND="virtual/libusb"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
