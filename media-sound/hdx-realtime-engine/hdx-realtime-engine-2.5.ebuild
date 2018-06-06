# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 129f61dcdb296c77af1e8e1100091e02cce7515e $

EAPI=6

inherit unpacker

BASE_P="HDX_RealTime_Media_Engine_${PV}_for_Linux"

DESCRIPTION="Plug-in to the Citrix Receiver to support clear, crisp high-definition audio-video calls"
HOMEPAGE="https://www.citrix.de/downloads/citrix-receiver/additional-client-software/hdx-realtime-media-engine-latest.html"
SRC_URI="amd64? ( ${BASE_P}_x64.zip )
	x86? ( ${BASE_P}.zip )"
LICENSE=""
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="
	$(unpacker_src_uri_depends .deb)
"

RDEPEND="
	media-libs/libsndfile
	media-sound/pulseaudio
	net-misc/icaclient
	x11-libs/libX11
	x11-libs/libXv
"

RESTRICT="fetch"

ICAROOT="/opt/Citrix/ICAClient"

QA_PREBUILT="${ICAROOT#/}/*"

case ${ARCH} in
	amd64)
		S="${WORKDIR}/${BASE_P}_x64/x86_64"
	;;
	i686)
		S="${WORKDIR}/${BASE_P}/i386"
	;;
	*)
		die "Unknown arch"
	;;
esac

pkg_nofetch() {
	elog "Download the plugin zip archive ${A} from ${HOMEPAGE}"
	elog "and place it in ${DISTDIR:-/usr/portage/distfiles}."
}

src_unpack() {
	unpack ${A}
	local archive="$(find -type f -name *.deb)"
	unpack_deb ${archive}
}

src_install() {
	pushd "${WORKDIR}"/usr/local/bin &>/dev/null || die
	
	insinto "${ICAROOT}"
	doins HDXRTME.so 
	
	exeinto "${ICAROOT}"
	doexe RTMEconfig RTMediaEngineSRV
}
