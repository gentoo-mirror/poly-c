# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://gitlab.com/ixion/ixion.git"

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

[[ ${MY_PV} == 9999 ]] && GITECLASS="git-r3 autotools"
inherit eutils python-single-r1 ${GITECLASS} poly-c_ebuilds
unset GITECLASS

DESCRIPTION="General purpose formula parser & interpreter"
HOMEPAGE="https://gitlab.com/ixion/ixion"
[[ ${MY_PV} == 9999 ]] || SRC_URI="http://kohei.us/files/ixion/src/${MY_P}.tar.xz"

LICENSE="MIT"
SLOT="0/0.12" # based on SONAME of libixion.so
[[ ${MY_PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="debug python static-libs +threads"

RDEPEND="
	dev-libs/boost:=
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	>=dev-util/mdds-1.2.0:1=
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	[[ ${MY_PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable python) \
		$(use_enable static-libs static) \
		$(use_enable threads)
}

src_install() {
	default

	prune_libtool_files --all
}
