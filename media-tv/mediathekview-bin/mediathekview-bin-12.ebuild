# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit java-pkg-2

MY_PV="${PV}"

DESCRIPTION="Download files from the public broadcasting services"
HOMEPAGE="http://zdfmediathk.sourceforge.net/"
SRC_URI="mirror://sourceforge/zdfmediathk/Entwicklerversion/MediathekView_${MY_PV}.zip"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8
	media-video/vlc
	media-video/flvstreamer
	>=dev-java/commons-compress-1.12_pre:0
	>=dev-java/commons-lang-3.4_pre:3.3
	dev-java/jgoodies-common:1.8
	dev-java/jgoodies-forms:1.8
	dev-java/xz-java:0
	"

S="${WORKDIR}"

src_prepare() {
	local mylib
	local jarlibs=(
		lib/commons-compress-1.12.jar
		lib/commons-lang3-3.4.jar
		lib/jgoodies-common-1.8.0.jar
		lib/jgoodies-forms-1.8.0.jar
		lib/xz.jar
	)
	for mylib in ${jarlibs[@]} ; do
		if [[ -f "${mylib}" ]] ; then
			rm ${mylib} || die
		else
			eerror "${mylib} no longer shipped."
			die
		fi
	done

	ewarn "Bundled libs remaining:"
	ewarn "$(find lib -name '*.jar' | sort)"

	default
}

src_compile() {
	:
}

src_install() {
	java-pkg_dojar MediathekView.jar
	java-pkg_dojar lib/*.jar

	exeinto /usr/share/${PN}/lib/bin/
	doexe bin/flv.sh || die

	java-pkg_register-dependency commons-compress commons-compress.jar
	java-pkg_register-dependency commons-lang-3.3 commons-lang.jar
	java-pkg_register-dependency jgoodies-common-1.8 jgoodies-common.jar
	java-pkg_register-dependency jgoodies-forms-1.8 jgoodies-forms.jar
	java-pkg_register-dependency xz-java xz.jar

	java-pkg_dolauncher ${PN} --main mediathek.Main
}
