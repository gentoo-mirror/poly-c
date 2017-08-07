# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="HTTP request/response parser for python in C"
HOMEPAGE="https://html5-parser.readthedocs.io"
SRC_URI="https://github.com/kovidgoyal/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/lxml
	dev-libs/libxml2
"

RDEPEND="${DEPEND}"
