# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
inherit readme.gentoo-r1 distutils-r1 poly-c_ebuilds

DESCRIPTION="Python library and command line tool for configuring a YubiKey"
HOMEPAGE="https://developers.yubico.com/yubikey-manager/"
SRC_URI="https://developers.yubico.com/${PN}/Releases/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-crypt/libu2f-host
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/pyscard[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7)
	sys-auth/ykpers
"

python_test() {
	esetup.py test
}

python_install_all() {
	local DOC_CONTENTS

	distutils-r1_python_install_all

	DOC_CONTENTS="
		The 'openpgp' command may require the package 'app-crypt/ccid'
		to be installed on the system. Furthermore, make sure that pcscd
		daemon is running and has correct access permissions to USB
		devices.
	"

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
