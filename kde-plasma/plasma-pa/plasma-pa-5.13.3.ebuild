# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 5b563ea9d02197d978b02ca1d087b2413e7c6a40 $

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Plasma applet for audio volume management using PulseAudio"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/glib:2
	gnome-base/gconf:2
	media-libs/libcanberra
	|| (
		>=media-sound/pulseaudio-12.0[gconf]
		<media-sound/pulseaudio-12.0[gnome]
	)
"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-wrong-port-avail.patch" )
