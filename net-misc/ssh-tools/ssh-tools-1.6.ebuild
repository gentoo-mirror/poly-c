# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="collection of various tools using ssh"
HOMEPAGE="https://github.com/vaporup/ssh-tools/"
SRC_URI="https://github.com/vaporup/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="sys-apps/help2man"
RDEPEND="net-misc/openssh"
DEPEND="${RDEPEND}"
PDEPEND="app-misc/colordiff"

create_man() {
	[[ -z "${1}" ]] && die "file name required"
	[[ -z "${2}" ]] && die "Description required"

	help2man -n "${2}" -S SSH-TOOLS -N --version-string "${PV}" -o "${S}"/man/${1}.1 "${S}"/${1} || die
}

src_compile() {
	mkdir man || die
	create_man ssh-ping "Check if host is reachable using ssh_config"
	create_man ssh-version "Shows version of the SSH server you are connecting to"
	create_man ssh-diff "Diff a file over SSH"
	create_man ssh-facts "Get some facts about the remote system"
	create_man ssh-hostkeys "Prints server host keys in several formats"
	create_man ssh-certinfo "Show validity and information of SSH certificates"
	create_man ssh-keyinfo "Prints keys in several formats"
}

src_install() {
	dobin ssh-*
	doman man/*.1
}
