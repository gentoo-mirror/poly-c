# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Utilities library used by Belledonne Communications softwares like belle-sip, mediastreamer2 and linphone."
HOMEPAGE="http://www.linphone.org/"
SCM=""
if [[ ${PV} == *9999* ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="git://git.linphone.org/bctoolbox.git"
else
	inherit autotools poly-c_ebuilds
	SRC_URI="https://github.com/BelledonneCommunications/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl polarssl"

RDEPEND="
	ssl? (
		polarssl? ( net-libs/polarssl )
		!polarssl? ( net-libs/mbedtls )
	)
"
DEPEND="
	${RDEPEND}
	dev-util/cunit
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(usex ssl $(use_enable polarssl) --disable-polarssl) \
		$(usex ssl $(use_enable !polarssl mbedtls) --disable-mbdtls)
}
