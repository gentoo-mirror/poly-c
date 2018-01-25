# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 0778efd94d9a99a807f266613481f741f9a113f7 $

EAPI=6
inherit autotools eutils user

MY_PN="${PN/emilia-/}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="SDL OpenGL pinball game"
HOMEPAGE="http://pinball.sourceforge.net/ https://github.com/sergiomb2/pinball"
SRC_URI="https://github.com/sergiomb2/pinball/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

# Drop the libtool dep once libltdl goes stable.
RDEPEND="
	media-libs/libsdl[joystick,opengl,video,X]
	virtual/opengl
	|| ( dev-libs/libltdl:0 <sys-devel/libtool-2.4.3-r2:2 )
"
DEPEND="
	${RDEPEND}
	x11-libs/libXt
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup gamestat
}

src_prepare() {
	default
	sed "/^AC_INIT/s@0\.3\.2@${PV}@" -i configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-cflags="${CFLAGS}"
		--with-cxxflags="${CXXFLAGS}"
		--with-x
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dosym /usr/bin/pinball /usr/bin/${PN}
	sed -i \
		-e 's:-I${prefix}/include/pinball:-I/usr/include/pinball:' \
		"${ED%/}"/usr/bin/pinball-config || die
	newicon data/pinball.xpm ${PN}.xpm
	make_desktop_entry emilia-pinball "Emilia pinball"

	# Don't install score files that are already in the root FS
	local scorefile
	for scorefile in $(find "${ED%/}"/var/games/${MY_PN} -name "highscores") ; do
		if [[ -f "${ROOT%/}/${scorefile/${ED%/}}" ]] ; then
			rm ${scorefile} || die
		else
			fowners root:gamestat "${scorefile/${ED%/}}"
			fperms 2660 "${scorefile/${ED%/}}"
		fi
	done
}

pkg_preinst() {
	# Preserving already existing highscore files from being overwritten.
	pushd "${ED}" &>/dev/null || die
	local scorefile
	for scorefile in $(find var/games/${MY_PN} -name "highscores") ; do
		if [[ -f "${EROOT%/}/${scorefile}" ]] ; then
			chown root:gamestat "${EROOT%/}/${scorefile}" || die
			chmod 2660 "${EROOT%/}/${scorefile}" || die
			continue
		fi
		mkdir -p "${EROOT%/}/${scorefile%/*}" || die
		mv "${scorefile}" "${EROOT%/}/${scorefile%/*}" || die
	done
	rm -rf var/games/${MY_PN}
	popd &>/dev/null || die
}

pkg_postinst() {
	einfo "Please add your user to the \"gamestat\" group in order to get write access"
	einfo "to the highscore files."
}
