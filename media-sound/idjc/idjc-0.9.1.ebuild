# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit autotools python-single-r1

RESTRICT="mirror"
DESCRIPTION="Internet DJ Console has two media players, jingles player, crossfader, VoIP and streaming"
HOMEPAGE="http://idjc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc ffmpeg flac mad mpg123 mysql nls opus speex twolame"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/eyeD3[${PYTHON_USEDEP}]
		dev-python/pygtk[${PYTHON_USEDEP}]
		media-libs/mutagen[${PYTHON_USEDEP}]
		mysql? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	')
	media-libs/libsamplerate
	>=media-libs/libshout-idjc-2.3.1[speex?]
	media-libs/libsndfile
	media-libs/libvorbis
	>=media-sound/jack-audio-connection-kit-0.116.0
	ffmpeg? ( media-video/ffmpeg )
	flac? ( media-libs/flac )
	mad? ( media-sound/lame )
	mpg123? ( media-sound/mpg123 )
	opus? ( media-libs/opus )
	speex? ( media-libs/speex )
	twolame? ( media-sound/twolame )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	# Make QA happy by removing unsupported and empty keys from the desktop
	# entry file.
	sed -i \
		-e 's/^TerminalOptions=//' \
		-e 's/^Path=//' \
		idjc.desktop.in.in || die "Sed failed!"

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable ffmpeg libav)
		$(use_enable flac)
		$(use_enable mad lame)
		$(use_enable mpg123)
		$(use_enable nls)
		$(use_enable opus)
		$(use_enable speex)
		$(use_enable twolame)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_install() {
	use doc && HTML_DOCS=( doc/ )

	default
}

pkg_postinst() {
	einfo "IDJC needs a working JACK Audio Connection Kit daemon. For details,"
	einfo "refer to http://idjc.sourceforge.net/install_first_run.html"
}
