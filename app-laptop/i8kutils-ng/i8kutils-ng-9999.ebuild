# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd toolchain-funcs

DESCRIPTION="Fan control for some Dell laptops"
HOMEPAGE="https://github.com/ru-ace/i8kutils"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ru-ace/i8kutils.git"
else	
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3"
SLOT="0"
IUSE="tk"

DEPEND="
	!app-laptop/i8kutils
"
RDEPEND="${DEPEND}
	sys-power/acpi"

DOCS=( README.i8kutils )

src_prepare() {
	default

	sed \
		-e '/^CFLAGS/s@:=.*$@+=-fstack-protector-strong@' \
		-e '/^LDFLAGS/s@:=@+=@' \
		-i Makefile || die

	tc-export CC
}

src_install() {
	dobin i8kctl i8kfan
	dosbin i8kmon-ng
	doman i8kctl.1 i8kmon-ng.1
	dodoc ${DOCS[@]}

	newinitd "${FILESDIR}"/i8kmon-ng.init i8kmon-ng
	newconfd "${FILESDIR}"/i8kmon-ng.conf i8kmon-ng
}
