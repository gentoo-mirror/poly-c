# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit python-r1 qmake-utils

DESCRIPTION="Configuring any YubiKey over all USB transports."
HOMEPAGE="https://github.com/Yubico/yubikey-manager-qt"
SRC_URI="https://github.com/Yubico/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	app-crypt/yubikey-manager
"

RDEPEND="
	${CDEPEND}
"

DEPEND="
	${CDEPEND}
"

src_prepare() {
	default

	sed 's@<\(QtSingleApplication\)>@<QtSolutions/\1>@' \
		-i ykman-gui/main.cpp || die

	sed -e '/pip/d' -e '/pymodules/d' -i ykman-gui/ykman-gui.pro || die
}

src_compile() {
	eqmake5 $(qmake-utils_find_pro_file)
}
