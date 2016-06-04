# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gkrellm-plugin

MY_P="gkrellm2-cpupower-${PV}"

DESCRIPTION="GKrellm plugin for changing CPU frequencies via cpupower"
HOMEPAGE="https://github.com/sainsaar/gkrellm2-cpupower"
SRC_URI="https://github.com/sainsaar/gkrellm2-cpupower/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

RDEPEND="sys-power/cpupower"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

S="${WORKDIR}/${MY_P}"

PLUGIN_SO="cpupower.so"

src_prepare() {
	eapply ${FILESDIR}/*.patch
	eapply_user
}

src_install() {
	gkrellm-plugin_src_install
	dosbin cpufreqnextgovernor
	emake DESTDIR="${D}" install-sudo
}
