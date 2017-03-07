# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2

MY_PN=${PN%%-bin}
MY_PV=${PV/_pre/-milestone-}
MY_PV=${MY_PV/_rc/-rc-}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Build Tool"

SRC_URI="http://services.gradle.org/distributions/${MY_P}-all.zip"
HOMEPAGE="http://www.gradle.org/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/zip"
RDEPEND=">=virtual/jdk-1.5"

IUSE="source doc examples"

S="${WORKDIR}/${MY_P}"

src_install() {
	local gradle_home="${ROOT}/usr/share/${PN}"

	insinto "${gradle_home}"
	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc docs
	use examples && java-pkg_doexamples samples

	pushd lib &>/dev/null || die
	for jar in *.jar; do
		java-pkg_newjar ${jar} ${jar}
	done
	insinto "${gradle_home}/lib/plugins"
	doins plugins/*

	popd &>/dev/null || die

	cp -Rp bin "${D}/${gradle_home}" || die "failed to copy"

	dodir /usr/bin
	dosym "${gradle_home}/bin/gradle" /usr/bin/gradle
}
