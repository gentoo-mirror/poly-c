# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fdo-mime multilib versionator

MY_PN="PacketTracer"
PKG_PV="$(delete_all_version_separators $(get_version_component_range 1-3))"
PKG_P="${MY_PN}${PKG_PV}"
MY_PV="$(delete_all_version_separators $(get_version_component_range 1-2))"
MY_P="${MY_PN}${MY_PV}"
MAJ_PV="$(get_version_component_range 1-2)"

BASE_URI="http://cisco.netacad.net/cnams/resourcewindow/noncurr/downloadTools/app_files"

DESCRIPTION="Cisco's Packet Tracer"
HOMEPAGE="https://www.cisco.com/web/learning/netacad/course_catalog/PacketTracer.html"
SRC_URI="${BASE_URI}/${PKG_P}_Generic_Ubuntu.tar.gz"

RESTRICT="fetch mirror strip"
LICENSE="Cisco_EULA"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="app-arch/gzip"

RDEPEND="dev-libs/glib[abi_x86_32(-)]
	media-libs/fontconfig[abi_x86_32(-)]
	media-libs/freetype[abi_x86_32(-)]
	media-libs/libpng[abi_x86_32(-)]
	sys-libs/zlib[abi_x86_32(-)]
	x11-libs/libICE[abi_x86_32(-)]
	x11-libs/libSM[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXi[abi_x86_32(-)]
	x11-libs/libXrandr[abi_x86_32(-)]
	x11-libs/libXrender[abi_x86_32(-)]
	doc? ( www-plugins/adobe-flash  )
	!<app-emulation/packettracer-52"

S="${WORKDIR}/${MY_P}"

PT_HOME="/opt/${MY_P}"
QA_PREBUILT="${PT_HOME#/}/*"

LANGS="de es ru"

for X in ${LANGS} ; do
	case ${X} in
		de)
			SRC_URI+=" linguas_${X}? ( ${BASE_URI}/PT${MY_PV}-german-v1.0.ptl )"
		;;
		es)
			SRC_URI+=" linguas_${X}? ( ${BASE_URI}/spanish_PT_v${MY_PV}.ptl )"
		;;
		ru)
			SRC_URI+=" linguas_${X}? ( ${BASE_URI}/RUSSIAN${MAJ_PV}.ptl )"
		;;
	esac
	IUSE+=" linguas_${X}"
done

pkg_setup() {
	# This is a binary x86 package => ABI=x86
	has_multilib_profile && ABI="x86"
}

pkg_nofetch() {
	ewarn "To fetch sources you need cisco account which is available in case"
	ewarn "you are cisco web-learning student, instructor or you sale cisco hardware, etc..  "
	einfo ""
	einfo ""
	einfo "After that point your browser at http://cisco.netacad.net/"
	einfo "login, go to PacketTracer image and download:"
	einfo "Packet Tracer v${MAJ_PV} Application + Tutorial Generic links (tar.gz) file"
	einfo ""
}

src_prepare() {
	local rmfiles=(
			install
			set_ptenv.sh
			tpl.linguist
			tpl.packettracer
			extensions/ptaplayer
			bin/linguist
		      )
	for fle in ${rmfiles[@]} ; do
		 rm -r ${fle} || die "unable to rm ${fle}"
	done
	use !doc && rm -fr "${S}/"help/default/tutorials
}

src_install() {
	#dodir "${PKT_HOME}"
	#cp -R "${S}/" "${D}${PKT_HOME}/" || die "Install failed!"
	insinto ${PT_HOME}
	doins -r "${S}"/*

	pushd "${S}" &>/dev/null || die
	for xfile in $(find extensions -type f -perm 755) bin/{PacketTracer5,Linux/{,un}zip} ; do
		fperms 0755 ${PT_HOME}/${xfile}
	done
	popd &>/dev/null || die

	doicon "${S}"/art/{app,pka,pkt,pkz}.{ico,png}

	make_wrapper packettracer "./bin/PacketTracer5" "${PT_HOME}" "${PT_HOME}/lib"
	make_desktop_entry "packettracer" "PacketTracer" "app" "Education;Emulator"

	insinto /usr/share/mime/applications
	doins "${D}${PT_HOME}/bin/"*.xml

	rm -f "${D}${PT_HOME}/bin/"*.xml

	dodir /etc/env.d
	echo PT5HOME="${PT_HOME}" > "${D}/etc/env.d/50${MY_PN}" || die "env.d files install failed"

	for LANG in ${LINGUAS} ; do
		if has ${LANG} ${LANGS} ; then
			case ${LANG} in
				de)
					LANGFILE="PT${MY_PV}-german-v1.0.ptl"
				;;
				es)
					LANGFILE="spanish_PT_v${MY_PV}.ptl"
				;;
				ru)
					LANGFILE="RUSSIAN${MAJ_PV}.ptl"
				;;
			esac

			insinto "${PT_HOME}/LANGUAGES"
			doins "${DISTDIR}/${LANGFILE}"
		fi
	done
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	if use doc ; then
		einfo " You have doc USE flag"
		einfo " For use documentaion , please"
		einfo " install you prefered brouser and  flashplayer support"
		einfo " such mozilla or konqerror"
	fi

	einfo ""
	einfo " If you have multiuser enviroment"
	einfo " you must configure your firewall to use UPnP protocol."
	einfo " Additional information see in packettracer user manual."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
