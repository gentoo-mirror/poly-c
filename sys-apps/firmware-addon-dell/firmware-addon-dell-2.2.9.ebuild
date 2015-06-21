# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="*:2.5"

inherit eutils python autotools

DESCRIPTION="Additional firmware tools for dell computers"
HOMEPAGE="http://linux.dell.com/libsmbios/main/index.html"
SRC_URI="http://linux.dell.com/libsmbios/download/${PN}/${P}/${P}.tar.bz2"

LICENSE="GPL-2 OSL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-apps/firmware-tools
	sys-apps/firmware-extract
	sys-libs/libsmbios[python]
	app-arch/rpm[python]"
DEPEND="${RDEPEND}"

src_prepare() {
	# dist-lzma was removed from automake-1.12 (bug #422779)
	sed 's@dist-lzma@dist-xz@' -i "${S}"/configure.ac || die
	eautoreconf
}

src_configure() {
	econf
}

src_install() {
	emake install DESTDIR="${D}"
}

#pkg_postinst() {
#	python_mod_optimize /usr/share/smbios-utils
#}

#pkg_posrtm() {
#	python_mod_cleanup /usr/share/smbios-utils
#}
