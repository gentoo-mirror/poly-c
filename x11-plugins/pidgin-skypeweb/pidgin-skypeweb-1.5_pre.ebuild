# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit poly-c_ebuilds

DESCRIPTION="SkypeWeb Plugin for Pidgin"
HOMEPAGE="https://github.com/EionRobb/skype4pidgin"
SRC_URI="https://github.com/EionRobb/skype4pidgin/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="net-im/pidgin
	dev-libs/json-glib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/skype4pidgin-${MY_PV}/skypeweb"

pkg_postinst(){
	elog "If you get error message like 'Failed getting Magic T value':"
	elog "Go to https://web.skype.com ; Log In and follow the instructions to enable your account!"
}
