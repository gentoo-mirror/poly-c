# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

MY_P="linuxcli_V$(ver_rs 3 '_')"

DESCRIPTION="CLI utility to manage Areca RAID controllers"
HOMEPAGE="https://www.areca.com.tw/support/downloads.html#linux"
#SRC_URI="${MY_P}.zip"
SRC_URI="http://www.areca.us/support/s_linux/driver/cli/${MY_P}.zip"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="${DEPEND}"

#RESTRICT="fetch"

S="${WORKDIR}/${MY_P}"

#pkg_nofetch() {
#	elog "Download the client file ${A} from
#	https://www.areca.com.tw/support/downloads.html#linux"
#	elog "and place it in your DISTDIR."
#}

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
