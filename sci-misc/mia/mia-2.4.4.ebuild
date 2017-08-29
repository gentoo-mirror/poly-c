# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit  cmake-utils

DESCRIPTION="Library and tools for medical image processing"
HOMEPAGE="http://mia.sf.net/"
SRC_URI="mirror://sourceforge/mia/${P}.tar.xz"
RESTRICT="primaryuri"

IUSE="doc itpp tbb +vtk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-cpp/eigen
	dev-libs/boost
	dev-libs/libxml2
	media-libs/libpng
	media-libs/openexr
	media-libs/tiff
	sci-libs/dcmtk
	sci-libs/gts
	sci-libs/fftw:3.0
	sci-libs/gsl
	sci-libs/hdf5
	sci-libs/maxflow
	sci-libs/nifticlib
	sci-libs/nlopt
	virtual/blas
	virtual/jpeg:62
	itpp? ( sci-libs/itpp )
	tbb? ( dev-cpp/tbb )
	vtk? ( sci-libs/vtk )
"

DEPEND="
	app-arch/xz-utils
	dev-python/lxml
	doc? (
		app-doc/doxygen[dot,latex]
		dev-libs/libxslt
		media-gfx/graphviz
	)
	"

src_configure() {
	local mycmakeargs=(
		-DALWAYS_CREATE_DOC="$(usex doc)"
		-DMIA_CREATE_MANPAGES="ON"
		-DMIA_CREATE_NIPYPE_INTERFACES="ON"
		-DSTRICT_DEPENDECIES="TRUE"
		-DWITH_ITPP="$(usex itpp)"
		-DWITH_TBB="$(usex tbb)"
		-DWITH_VTKIO="$(usex vtk)"
	)
	cmake-utils_src_configure
}
