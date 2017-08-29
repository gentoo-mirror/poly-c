# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="The DICOM Toolkit"
HOMEPAGE="http://dicom.offis.de/dcmtk.php.en"
SRC_URI="http://dicom.offis.de/download/${PN}/dcmtk${PV//.}/${P}.tar.gz"
LICENSE="BSD"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc png ssl tcpd +threads tiff xml zlib iconv"

RDEPEND="
	virtual/jpeg
	png? ( media-libs/libpng )
	ssl? ( dev-libs/openssl )
	tcpd? ( sys-apps/tcp-wrappers )
	tiff? ( media-libs/tiff )
	xml? ( dev-libs/libxml2:2 )
	zlib? ( sys-libs/zlib )
	iconv? ( virtual/libiconv )
	"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/soversion_abi.patch
)

src_prepare() {
	default

	# Unfortunately not multilib-strict compliant
	sed "/_OUTPUT_DIRECTORY/s@/lib@/$(get_libdir)@" \
		-i CMake/dcmtkPrepare.cmake || die
	sed "s@/lib\b@/$(get_libdir)@" -i CMake/3rdparty.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_INSTALL_PREFIX=/usr
		-DDCMTK_WITH_DOXYGEN="$(usex doc)"
		-DDCMTK_WITH_ICONV="$(usex iconv)"
		-DDCMTK_WITH_OPENSSL="$(usex ssl)"
		-DDCMTK_WITH_PNG="$(usex png)"
		-DDCMTK_WITH_THREADS="$(usex threads)"
		-DDCMTK_WITH_TIFF="$(usex tiff)"
		-DDCMTK_WITH_XML="$(usex xml)"
		-DDCMTK_WITH_ZLIB="$(usex zlib)"
	)
	cmake-utils_src_configure

	if use doc ; then
		cd doxygen || die
		econf
	fi
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		emake -C doxygen
	fi
}

src_install() {
	cmake-utils_src_install

	if use doc ; then
		#cd "${S}" || die
		doman doxygen/manpages/man1/*
		dohtml -r doxygen/htmldocs/*
	fi
}
