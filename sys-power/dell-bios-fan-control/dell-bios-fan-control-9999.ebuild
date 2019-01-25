# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple tool to enable or disable the SMBIOS fan (auto) fan control on Dell"
HOMEPAGE="https://github.com/TomFreudenberg/dell-bios-fan-control"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TomFreudenberg/dell-bios-fan-control"
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-2"
SLOT="0"

IUSE=""

src_prepare() {
	default
	sed 's@$(CC)@$(CC) $(CFLAGS) $(LDFLAGS)@' -i Makefile || die

	tc-export CC
}

src_install() {
	dosbin dell-bios-fan-control
	dodoc README.md
}
