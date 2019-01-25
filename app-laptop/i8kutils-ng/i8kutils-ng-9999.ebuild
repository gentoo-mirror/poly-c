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
	tk? ( dev-lang/tk:0 )
"
RDEPEND="${DEPEND}
	sys-power/acpi"

DOCS=( README.i8kutils )

src_prepare() {
	default
	tc-export CC
}

src_install() {
	dobin i8kctl i8kfan
	doman i8kctl.1
	dodoc README.i8kutils

	newinitd "${FILESDIR}"/i8k.init-r1 i8k
	newconfd "${FILESDIR}"/i8k.conf i8k

	if use tk; then
		dobin i8kmon
		doman i8kmon.1
		dodoc i8kmon.conf
		systemd_dounit "${FILESDIR}"/i8kmon.service
	else
		cat >> "${ED}"/etc/conf.d/i8k <<- EOF

		# i8kmon disabled because the package was installed without USE=tk
		NOMON=1
		EOF
	fi
}
