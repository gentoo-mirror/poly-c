# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

PYVER="2.7"

DESCRIPTION="GDCM is an implementation of the DICOM standard."
HOMEPAGE="http://gdcm.sourceforge.net/"
SRC_URI="mirror://sourceforge/gdcm/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc vtk python"

RDEPEND="
	app-text/poppler
	dev-libs/expat
	dev-libs/json-c
	dev-libs/libxml2
	dev-libs/openssl:0=
	media-libs/charls
	media-libs/openjpeg:2
	sys-libs/zlib
	vtk? ( >=sci-libs/vtk-6.3 )
	"

DEPEND="
	app-arch/xz-utils
	app-text/docbook-xsl-ns-stylesheets
	dev-libs/libxslt
	doc? ( app-doc/doxygen )
	python? (
		${PYTHON_DEPS}
		>=dev-lang/swig-3.0
		>=sci-libs/vtk-6.3[python]
	)
	${RDEPEND}
"
src_configure() {
	local mycmakeargs=(
		-DGDCM_DOXYGEN_NO_FOOTER=ON
		-DGDCM_BUILD_APPLICATIONS=ON
		-DGDCM_BUILD_SHARED_LIBS=ON
		-DGDCM_USE_PVRG=ON
		-DGDCM_USE_SYSTEM_PVRG=OFF
		-DGDCM_BUILD_TESTING=OFF
		-DGDCM_USE_SYSTEM_EXPAT=ON
		-DGDCM_USE_SYSTEM_UUID=ON
		-DGDCM_USE_SYSTEM_ZLIB=ON
		-DGDCM_USE_SYSTEM_OPENJPEG=ON
		-DGDCM_USE_SYSTEM_OPENSSL=ON
		-DGDCM_USE_SYSTEM_CHARLS=ON
		-DGDCM_USE_SYSTEM_POPPLER=ON
		-DGDCM_USE_SYSTEM_LIBXML2=ON
		-DGDCM_USE_SYSTEM_JSON=ON
		-DGDCM_USE_PARAVIEW=OFF
		-DGDCM_USE_ACTIVIZ=OFF
		-DGDCM_USE_SYSTEM_PAPYRUS3=OFF
		-DGDCM_USE_SYSTEM_SOCKETXX=OFF
		-DGDCM_USE_VTK="$(usex vtk)"
	)

	if use python ; then
		mycmakeargs+=(
			-DPython_ADDITIONAL_VERSIONS=${PYVER}
			-DGDCM_INSTALL_PYTHONMODULE_DIR=lib/python${PYVER}/site-packages
			-DGDCM_WRAP_PYTHON=ON
		)
	fi

	cmake-utils_src_configure
}
