# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs ${SCM} poly-c_ebuilds

DESCRIPTION="A suite of programs to modify openttd/Transport Tycoon Deluxe's GRF files"
HOMEPAGE="http://dev.openttdcoop.org/projects/grfcodec"
SRC_URI="http://binaries.openttd.org/extra/${PN}/${MY_PV}/${MY_P}-source.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="media-libs/libpng:0"
DEPEND="
	${RDEPEND}
	!games-util/nforenum
	dev-lang/perl
	dev-libs/boost
"

src_prepare() {
	default

	# Set up Makefile.local so that we respect CXXFLAGS/LDFLAGS
	cat > Makefile.local <<-__EOF__
		CXX=$(tc-getCXX)
		BOOST_INCLUDE=/usr/include
		CXXFLAGS=${CXXFLAGS}
		LDOPT=${LDFLAGS}
		UPX=
		V=1
		FLAGS=
		EXE=
	__EOF__
	sed -i -e 's/-O2//g' Makefile || die
}

src_install() {
	dobin grfcodec grfid grfstrip nforenum
	doman docs/*.1
	dodoc changelog.txt docs/*.txt
}
