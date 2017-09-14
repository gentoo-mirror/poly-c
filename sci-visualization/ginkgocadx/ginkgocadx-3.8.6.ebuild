# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils wxwidgets

DESCRIPTION="An advanced DICOM viewer and dicomizer"
HOMEPAGE="https://github.com/gerddie/ginkgocadx"
SRC_URI="https://github.com/gerddie/ginkgocadx/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=sci-libs/vtk-6.2[rendering,-opengl2]
	>=sci-libs/itk-4.8
	dev-db/sqlite
	dev-libs/openssl:0
	|| (
		>=sci-libs/dcmtk-3.6.1_pre20150924
		>=sci-libs/dcmtk-3.6.2-r1[c++11]
	)
	>=x11-libs/wxGTK-3.0.1:3.0[opengl]
	x11-libs/gtk+:2
	!media-gfx/ginkgocadx
	"
RDEPEND="${DEPEND}"

pkg_setup() {
	if [ "$(wx-config --release)" = 3.0 ] ; then
		die "Pick wxwidgets-3.0 in 'eselect wxwidgets'"
	fi
}