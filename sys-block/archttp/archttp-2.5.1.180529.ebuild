# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="Linuxhttp_V$(ver_rs 3 '_')"

DESCRIPTION="CLI utility to manage Areca RAID controllers"
HOMEPAGE="https://www.areca.com.tw/support/downloads.html#linux"
SRC_URI="http://www.areca.us/support/s_linux/http/${MY_P}.zip"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="${DEPEND}"

RESTRICT="mirror"

S="${WORKDIR}/${MY_P}"

src_install() {
	local dir bin

	case ${ARCH} in
		amd64)
			dir="x86_64"
			bin="${PN}64"
		;;
		x86)
			dir="i386"
			bin="${PN32}"
		;;
		*)
			die "This arch is not supported."
		;;
	esac

	dodir /opt/${PN}
	exeinto /opt/${PN}
	newexe "${S}/${dir}/${bin}" ${PN}
	dosym ../${PN}/${PN} /opt/bin/${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
