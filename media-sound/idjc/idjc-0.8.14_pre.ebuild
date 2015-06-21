# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit poly-c_ebuilds

DESCRIPTION="Internet DJ Console"
HOMEPAGE="http://idjc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=">=dev-python/pygtk-2.6.1
	>=dev-python/eyeD3-0.6.4
	>=media-sound/lame-3.96.1"

DEPEND=">=media-sound/jack-audio-connection-kit-0.99.0-r1
	>=media-libs/libshout-2.1
	>=media-sound/vorbis-tools-1.0.1
	>=media-libs/xine-lib-1.1.2-r2
	>=media-libs/flac-1.1.2-r3
	>=media-libs/libsamplerate-0.1.1-r1
	media-libs/libmp4v2
	media-video/ffmpeg
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	einfo "In order to run idjc you first need to have a JACK sound server running."
	einfo "With all audio apps closed and sound servers on idle type the following:"
	einfo "jackd -d alsa -r 44100 -p 2048"
	einfo "Alternatively to have JACK start automatically when launching idjc:"
	einfo "echo \"/usr/bin/jackd -d alsa -r 44100 -p 2048\" >~/.jackdrc"
}
