# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="collection of various tools using ssh"
HOMEPAGE="https://github.com/vaporup/ssh-tools/"
SRC_URI="https://github.com/vaporup/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-apps/help2man"
RDEPEND="net-misc/openssh"
PDEPEND="app-misc/colordiff"

create_man() {
	[[ -z "${1}" ]] && die "file name required"
	[[ -z "${2}" ]] && die "Description required"

	help2man -n "${2}" -S SSH-TOOLS -N --version-string "${PV}" -o "${S}"/man/${1}.1 "${S}"/${1} || die
}

src_compile() {
	mkdir man || die
	create_man ssh-ping "check if host is reachable using ssh_config"
	create_man ssh-version "shows version of the SSH server you are connecting to"
	create_man ssh-diff "diff a file over SSH"
	create_man ssh-facts "get some facts about the remote system"
}

src_install() {
	dobin ssh-*
	doman man/*.1
}
