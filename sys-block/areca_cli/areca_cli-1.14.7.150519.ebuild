# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

MY_P="linuxcli_V$(replace_version_separator 3 '_')"

DESCRIPTION="CLI utility to manage Areca RAID controllers"
HOMEPAGE="http://www.areca.com.tw/support/s_linux/linux.htm"
SRC_URI="http://www.areca.us/support/s_linux/cli/${MY_P}.zip"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	local dir bin

	case ${ARCH} in
		amd64)
			dir="x86_64"
			bin="cli64"
		;;
		x86)
			dir="i386"
			bin="cli"
		;;
		*)
			die "This arch is not supported."
		;;
	esac

	dodir /opt/${PN}
	exeinto /opt/${PN}
	newexe "${S}/${dir}/${bin}" areca_cli
	dosym ../${PN}/areca_cli /opt/bin/areca_cli
}
