# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Utilities used around Fedora Infrastructure to send and receive messages"
HOMEPAGE="https://github.com/fedora-infra/fedmsg"
SRC_URI="https://github.com/fedora-infra/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome X"

DEPEND="dev-lang/swig
	${PYHTON_DEPEND}"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.rst README.rst )
