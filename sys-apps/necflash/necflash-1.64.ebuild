# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 2184a1651c3e4166cba1197b4d935e8547b261e5 $

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Firmware flasher for NEC and Optiarc DVD burner firmwares"
HOMEPAGE="https://github.com/Liggy/binflash/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Liggy/binflash.git"
else
	SRC_URI="https://github.com/Liggy/binflash/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/binflash-${PV}"
fi
LICENSE=""
SLOT="0"

IUSE=""

PATCHES=(
	"${FILESDIR}/${PN}-1.64-Makefile.patch"
)

src_compile() {
	tc-export CXX
	emake CFLAGS_OS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dosbin ${PN}
	dodoc README.md
}
