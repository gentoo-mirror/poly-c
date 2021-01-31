# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_SINGLE_IMPL=1
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Anno-like real time strategy game"
HOMEPAGE="http://www.unknown-horizons.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/distro[${PYTHON_MULTI_USEDEP}]
		dev-python/future[${PYTHON_MULTI_USEDEP}]
		dev-python/pillow[${PYTHON_MULTI_USEDEP}]
		dev-python/pyyaml[${PYTHON_MULTI_USEDEP}]
	')
	games-engines/fifengine[python,${PYTHON_SINGLE_USEDEP}]
	games-engines/fifechan
	${PYTHON_DEPS}
"

DEPEND="
	${RDEPEND}
	$(python_gen_cond_dep '
		test? (
			dev-python/greenlet[${PYTHON_MULTI_USEDEP}]
			dev-python/polib[${PYTHON_MULTI_USEDEP}]
			dev-python/isort[${PYTHON_MULTI_USEDEP}]
			dev-python/pylint[${PYTHON_MULTI_USEDEP}]
			dev-python/mock[${PYTHON_MULTI_USEDEP}]
			dev-python/nose[${PYTHON_MULTI_USEDEP}]
			dev-python/pycodestyle[${PYTHON_MULTI_USEDEP}]
		)
	')
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_test() {
	${PYTHON} ./run_tests.py
}

src_compile() {
	distutils-r1_src_compile build_i18n
}
