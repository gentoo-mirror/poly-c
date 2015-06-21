# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN="EWAHBoolArray"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A compressed bitmap class in C++"
HOMEPAGE="https://github.com/lemire/EWAHBoolArray"
SRC_URI="https://github.com/lemire/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
