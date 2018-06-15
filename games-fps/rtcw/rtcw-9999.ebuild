# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils unpacker

DESCRIPTION="Return to Castle Wolfenstein - IORTCW Project"
HOMEPAGE="http://games.activision.com/games/wolfenstein/"
if [[ "${PV}" = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/iortcw/iortcw.git"
	RELEASE="${PN}-1.51b"
else
	SRC_URI="https://github.com/iortcw/iortcw/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/iortcw-${PV}"
	KEYWORDS="~amd64 ~x86"
	RELEASE="${PN}-${PV}"
fi

WOLF_POINTRELEASE="wolf-linux-1.41b.x86.run"
PATCH_DATA="patch-data-141.zip"
SRC_URI+=" mirror://idsoftware/wolf/linux/${WOLF_POINTRELEASE}
	https://github.com/iortcw/iortcw/releases/download/1.51b/patch-data-141.zip -> ${RELEASE}-${PATCH_DATA}"
# iortcw is GPL-2 but the point release files still have the original copyrights
# from ID-software
LICENSE="GPL-2 RTCW"
SLOT="0"
IUSE="+client curl mumble openal opus server truetype voip vorbis"

REQUIRED_USE="|| ( client server )
		voip? ( opus )"

CDEPEND=">=sys-libs/zlib-1.2.11[minizip]"

DEPEND="${CDEPEND}
	client? (
		media-libs/libsdl2
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXdmcp
		x11-libs/libXext
		virtual/opengl
	)"
	
RDEPEND="${CDEPEND}
	client? ( media-libs/libsdl2
		virtual/opengl
		virtual/jpeg:0
		curl? ( net-misc/curl )
		mumble? ( media-sound/mumble )
		openal? ( media-libs/openal )
		opus? ( media-libs/libogg
			media-libs/opus
			media-libs/opusfile )
		truetype? ( media-libs/freetype )
		vorbis? ( media-libs/libogg
			media-libs/libvorbis ) )"
	#voip? ( media-libs/speex )"

dir="/opt/${PN}"

use_switch() {
	local flag="${1}" cfg_option="${2}" cfg_val=0
	local makefile="${S}/SP/Makefile.local"
	[[ -z "${flag}" ]] && die
	[[ -z "${cfg_option}" ]] && die

	use ${flag} && cfg_val=1

	if grep -q "^${cfg_option}=" ${makefile} ; then
		sed "/${cfg_option}=/s@[[:digit:]]@${cfg_val}@" -i ${makefile} \
			|| die
	else
		echo "${cfg_option}=${cfg_val}" >> ${makefile}
	fi
}	

PATCHES=(
	"${FILESDIR}/${PN}-1.51c-zlib.patch"
)

src_unpack() {
	unpack "${RELEASE}-${PATCH_DATA}"

	if [[ "${PV}" = 9999 ]] ; then
		git-r3_src_unpack
	else
		default
	fi

	unpack_makeself "${DISTDIR}/${WOLF_POINTRELEASE}"
}

src_prepare(){
	default
	cp "${FILESDIR}/Makefile.local" "${S}/SP/" || die

	# remove bundled libs
	local bundled_libs bundle bdir tdir

	bundled_libs=(
		AL # openal
		SDL2
		curl-7.54.0
		freetype-2.6.4
		jpeg-8c
		libogg-1.3.2
		libvorbis-1.3.5
		opus-1.1.4
		opusfile-0.8
		zlib-1.2.11
	)
	for bundle in ${bundled_libs[@]} ; do
		for tdir in MP SP ; do
			bdir="${tdir}/code/${bundle}"
			if [[ -d "${bdir}" ]] ; then
				rm -r ${bdir} || die
			fi
		done
	done

	local makefile="SP/Makefile.local"

	sed "/^CFLAGS=/s@=.*\$@=${CFLAGS}@" -i ${makefile} || die

	echo "V=1" >> ${makefile}

	use_switch client BUILD_CLIENT
	use_switch curl USE_CURL
	use_switch mumble USE_MUMBLE
	use_switch openal USE_OPENAL
	use_switch opus USE_CODEC_OPUS
	use_switch server BUILD_SERVER
	use_switch truetype USE_FREETYPE
	use_switch vorbis USE_CODEC_VORBIS
	use_switch voip USE_VOIP

	use curl && echo "USE_CURL_DLOPEN=0" >> ${makefile}
	use openal && echo "USE_OPENAL_DLOPEN=0" >> ${makefile}
}

src_compile() {
	cd "${S}/SP/"
	ARCH="$(uname -m)" emake
}

src_install() {
	cd "${S}/SP/"
	ARCH="$(uname -m)" \
	COPYDIR=${D}/${dir} \
	emake copyfiles

	sed "s@%dir%@${dir}@g;s@%exe%@iowolfsp.$(uname -m)@" \
		"${FILESDIR}"/rtcw-wrapper > "${T}"/rtcwsp
	dobin "${T}"/rtcwsp

	#if use server; then
	#	games_make_wrapper wolf-ded ./wolfded.x86 "${dir}" "${dir}"
	#	newinitd "${FILESDIR}"/wolf-ded.rc wolf-ded
	#	sed -i \
	#		-e "s:GENTOO_DIR:${dir}:" \
	#		"${D}"/etc/init.d/wolf-ded \
	#		|| die
	#fi

	# install pk3 files from the point release
	insinto ${dir}/main
	doins ${WORKDIR}/main/*.pk3
	doins -r ${WORKDIR}/main/scripts

	doicon -s scalable misc/iortcw.svg
	make_desktop_entry rtcwsp "Return to Castle Wolfenstein (SP)" iortcw
}

pkg_postinst() {
	elog "You need to copy pak0.pk3, mp_pak0.pk3 and sp_pak1.pk3 from a"
	elog "Window installation or your install media into ${dir}/main/"
	elog
	elog "To play the game run:"
	elog " rtcwsp (single-player)"
	#elog " rtcwmp (multi-player)"
	elog
#	if use server
#	then
#		elog "To start a dedicated server run:"
#		elog " /etc/init.d/wolf-ded start"
#		elog
#		elog "To run the dedicated server at boot, type:"
#		elog " rc-update add wolf-ded default"
#		elog
#		elog "The dedicated server is started under the ${GAMES_USER_DED} user account"
#		echo
#	fi
}
