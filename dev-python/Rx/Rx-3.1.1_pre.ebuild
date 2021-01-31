# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 virtualx poly-c_ebuilds

REAL_P="RxPY"
DESCRIPTION="Reactive Extensions for Python"
HOMEPAGE="http://reactivex.io/"
SRC_URI="https://github.com/ReactiveX/${REAL_P}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${REAL_P}-${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}
