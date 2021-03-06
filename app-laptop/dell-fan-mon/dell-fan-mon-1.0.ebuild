# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Fan control for some Dell laptops"
HOMEPAGE="https://github.com/ru-ace/dell-fan-mon"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ru-ace/dell-fan-mon.git"
else	
	SRC_URI="https://github.com/ru-ace/dell-fan-mon/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DOCS=( readme.md )

src_prepare() {
	default

	sed \
		-e '/^CFLAGS/s@:=.*$@+=-fstack-protector-strong@' \
		-e '/^LDFLAGS/s@:=@+=@' \
		-i Makefile || die

	tc-export CC
}

src_install() {
	dosbin ${PN}
	doman ${PN}.1
	dodoc ${DOCS[@]}

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}
}
