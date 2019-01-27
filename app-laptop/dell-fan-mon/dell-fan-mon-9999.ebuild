# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd toolchain-funcs

DESCRIPTION="Fan control for some Dell laptops"
HOMEPAGE="https://github.com/ru-ace/dell-fan-mon"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ru-ace/dell-fan-mon.git"
else	
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3"
SLOT="0"
IUSE="tk"

RDEPEND="sys-power/acpi"
DEPEND="${RDEPEND}"

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
	dobin dell-fan-mon
	doman dell-fan-mon.1
	dodoc ${DOCS[@]}

	newinitd "${FILESDIR}"/i8kmon-ng.init dell-fan-mon
	newconfd "${FILESDIR}"/i8kmon-ng.conf dell-fan-mon
}
