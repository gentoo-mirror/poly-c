# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

## Will not build with ocaml-gstreamer
# File "io/gstreamer_io.ml", line 23, characters 0-14:
# Error: Unbound module Gstreamer
#
## ./configure finds GD and SDL no matter what, so they're not
## optional

EAPI=5
inherit autotools eutils findlib systemd

DESCRIPTION="A swiss-army knife for multimedia streaming, notably used for netradios."
HOMEPAGE="http://liquidsoap.fm/"
SRC_URI="mirror://sourceforge/savonet/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aacplus alsa ao doc dirac dssi faad +flac gavl graphics jack json ladspa +lame lastfm libsamplerate +mad osc portaudio pulseaudio +shout soundtouch speex speech +taglib theora +unicode video voaac +vorbis xml"

RDEPEND="dev-lang/ocaml
		 >=dev-ml/ocaml-dtools-0.3.0
		 dev-ml/ocaml-duppy
		 dev-ml/ocaml-magic
		 dev-ml/ocaml-mm
		 dev-ml/pcre-ocaml
		 dev-ml/gd4o
		 dev-ml/ocamlsdl[truetype]
		 media-fonts/dejavu
		 media-libs/sdl-ttf
	aacplus? ( dev-ml/ocaml-aacplus )
	alsa? ( dev-ml/ocaml-alsa )
	ao? ( dev-ml/ocaml-ao )
	dirac? ( dev-ml/ocaml-schroedinger )
	doc? ( dev-perl/XML-DOM )
	dssi? ( dev-ml/ocaml-dssi )
	faad? ( dev-ml/ocaml-faad )
	flac? ( dev-ml/ocaml-flac )
	gavl? ( dev-ml/ocaml-gavl )
	graphics? ( dev-ml/camlimages )
	jack? ( dev-ml/ocaml-bjack )
	json? ( dev-ml/yojson )
	ladspa? ( dev-ml/ocaml-ladspa )
	lame? ( dev-ml/ocaml-lame )
	lastfm? ( dev-ml/ocaml-lastfm )
	libsamplerate? ( dev-ml/ocaml-samplerate )
	mad? ( dev-ml/ocaml-mad )
	osc? ( dev-ml/ocaml-lo )
	portaudio? ( dev-ml/ocaml-portaudio )
	pulseaudio? ( dev-ml/ocaml-pulseaudio )
	shout? ( dev-ml/ocaml-cry )
	soundtouch? ( dev-ml/ocaml-soundtouch )
	speech? ( app-accessibility/festival
			  media-sound/sox
			  media-sound/normalize )
	speex? ( dev-ml/ocaml-speex
			 dev-ml/ocaml-ogg )
	taglib? ( dev-ml/ocaml-taglib )
	theora? ( dev-ml/ocaml-theora )
	unicode? ( dev-ml/camomile )
	voaac? ( dev-ml/ocaml-voaacenc )
	vorbis? ( dev-ml/ocaml-vorbis\
			  dev-ml/ocaml-ogg )
	xml? ( dev-ml/ocaml-xmlplaylist )"
DEPEND="${RDEPEND}
		dev-ml/findlib
		virtual/pkgconfig
		dev-ml/ocaml-mad
		dev-ml/ocaml-cry"

pkg_setup() {
	use doc || ewarn "The doc use flag is unset, html documentation will not be included."
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/run/liquidsoap ${PN},audio
}

src_prepare() {
	#has_version '>=dev-lang/ocaml-4' &&  epatch "${FILESDIR}/ocaml-4.patch"

	einfo "Sandboxing Makefile.defs.in ..."
	sed -i 's/@exec_prefix@/${DESTDIR}@exec_prefix@/g' Makefile.defs.in
	sed -i 's/@libdir@/${DESTDIR}@libdir@/'g Makefile.defs.in
	sed -i 's/@mandir@/${DESTDIR}@mandir@/'g Makefile.defs.in
	sed -i 's/@sysconfdir@/${DESTDIR}@sysconfdir@/'g Makefile.defs.in
	sed -i 's/@localstatedir@/${DESTDIR}@localstatedir@/'g Makefile.defs.in
	sed -i 's/@datarootdir@/${DESTDIR}@datarootdir@/'g Makefile.defs.in
	sed -i 's/@datadir@/${DESTDIR}@datadir@/'g Makefile.defs.in

	einfo "Replacing tool check macros ..."
	sed -i 's/AC_CHECK_TOOL_STRICT/AC_CHECK_TOOL/g' m4/ocaml.m4

	AT_M4DIR="m4" eautoreconf -f -i
	eautomake
}

# Internal functions
liquidsoap_use() {
	if  use $1; then
		return 0
	else
		echo "--without-$1-dir"
	fi
}
liquidsoap_use_as() {
	if use $1; then
		return 0
	else
		echo "--without-$2-dir"
	fi
}

src_configure() {
	econf \
		--with-user="${PN}" \
		--with-group="${PN}" \
		--localstatedir="/var" \
		--with-default-font=/usr/share/fonts/dejavu/DejaVuSans.ttf \
		--without-gstreamer-dir \
		$(liquidsoap_use aacplus) \
		$(liquidsoap_use alsa) \
		$(liquidsoap_use ao) \
		$(liquidsoap_use_as dirac schroedinger) \
		$(liquidsoap_use dssi) \
		$(liquidsoap_use faad) \
		$(liquidsoap_use flac) \
		$(liquidsoap_use gavl) \
		$(liquidsoap_use_as graphics camlimages) \
		$(liquidsoap_use_as jack bjack) \
		$(liquidsoap_use ladspa) \
		$(liquidsoap_use lame) \
		$(liquidsoap_use lastfm) \
		$(liquidsoap_use_as libsamplerate samplerate) \
		$(liquidsoap_use mad) \
		$(liquidsoap_use_as osc lo) \
		$(liquidsoap_use portaudio) \
		$(liquidsoap_use pulseaudio) \
		$(use_enable graphics) \
		$(liquidsoap_use_as shout cry) \
		$(liquidsoap_use soundtouch) \
		$(liquidsoap_use speex) \
		$(liquidsoap_use taglib) \
		$(liquidsoap_use theora) \
		$(use_enable unicode camomile) \
		$(liquidsoap_use_as voaac voaacenc) \
		$(liquidsoap_use vorbis) \
		$(liquidsoap_use_as xml xmlplaylist)
	## checks for python and pygtk, but hopefully
	## things wont  break if they're missing
}

src_install() {
	findlib_src_install
	keepdir /etc/${PN} /var/log/${PN}
	newinitd "${FILESDIR}/liquidsoap.runscript" ${PN}
	systemd_newunit "${FILESDIR}/liquidsoap-at.service" "liquidsoap@.service"
	dodoc CHANGES README
	if use doc; then
		emake doc
		dohtml -r doc/html/*
	fi
}

pkg_postinst() {
	if use doc; then
		elog "For comprehensive documentation see"
		elog "file:///usr/share/doc/${P}/html/index.html"
	fi
}
