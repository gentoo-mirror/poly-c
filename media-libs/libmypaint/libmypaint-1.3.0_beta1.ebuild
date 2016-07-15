# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools toolchain-funcs python-single-r1 multilib versionator

MY_PV="$(replace_version_separator 3 '-' ${PV/beta/beta.})"

DESCRIPTION="libmypaint, a.k.a. \"brushlib\", is a library for making brushstrokes which is used by MyPaint and other projects."
HOMEPAGE="http://mypaint.org"
SRC_URI="https://github.com/mypaint/libmypaint/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="ISC"

IUSE="introspection"

RDEPEND="dev-libs/json-c
	${PYTHON_DEPS}
	media-libs/babl
	media-libs/gegl:0.3[introspection?]
	introspection? ( dev-libs/gobject-introspection )"

DEPEND="${RDEPEND}
	sys-apps/sed"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default
	eautoreconf
}
