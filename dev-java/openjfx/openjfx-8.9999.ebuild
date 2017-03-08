# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 mercurial

DESCRIPTION="Open source JavaFX"
HOMEPAGE="http://wiki.openjdk.java.net/display/OpenJFX/Main"

EHG_REPO_URI="http://hg.openjdk.java.net/openjfx/8u/rt/"

LICENSE="GPL-2+"
SLOT="8u"
#KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	dev-java/antlr:3
	=dev-java/gradle-bin-1.8*
	dev-java/junit:4
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-gradle_find_icedtea.patch
)

src_prepare() {
	default

	sed \
		-e "/^BUILD_JAVADOC/s@false@$(usex doc true false@)" \
		-e "/^NUM_COMPILE_THREADS/s@%NUM%@$(sed 's@.*-j[[:space:]]*\([[:digit:]]\{1,3\}\).*@\1@' <<< "${MAKEOPTS}")@" \
	#	"${FILESDIR}"/gradle.properties \
		> "${S}"/gradle.properties || die

	sed \
		-e '/antlr/s@3\.1\.3@3.2@g' -i build.gradle || die
}

src_compile() {
	gradle native
}
