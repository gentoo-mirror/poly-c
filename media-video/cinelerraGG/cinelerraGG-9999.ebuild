# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The most advanced non-linear video editor and compositor - Good Guy's version"
HOMEPAGE="https://cinelerra-cv.org/"

IUSE="+pref opus vpx +fdk"

RDEPEND=">=sci-libs/fftw-3
	>=media-libs/libtheora-1.1:=
	fdk? ( media-libs/fdk-aac:= )"

DEPEND="${RDEPEND}
        dev-lang/nasm
	dev-util/ctags"
BDEPEND="
	app-arch/xz-utils
        virtual/pkgconfig
"

if [[ ${PV} = *9999* ]]; then
        inherit autotools git-r3
	#EGIT_REPO_URI="git://git.cinelerra-cv.org/goodguy/cinelerra.git"
	EGIT_REPO_URI="git://git.cinelerra-gg.org/goodguy/cinelerra"
	#EGIT_CLONE_TYPE=shallow
	S="${WORKDIR}/${P}/cinelerra-5.1"
else
	SRC_URI=""
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

SLOT="0"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		$(usex pref '--prefix=/usr/local_cin' '')
		$(usex opus '--with-opus --enable-opus' '')
		$(usex vpx '--enable-libvpx' '')
	)
	if use fdk ; then
		export FFMPEG_EXTRA_CFG=" --enable-libfdk-aac --enable-nonfree"
		export EXTRA_LIBS=" -lfdk-aac"
	fi
	econf "${myconf[@]}"
}

src_install() {
	emake -j1 DESTDIR="${D}" install

	# patch better render templates
	#tar -xzf "${FILESDIR}"/fqt_mp4.tar.gz -C "${D}"/usr/share/cin/ffmpeg/

	#if use pref ; then
	#	mkdir -p "${D}"/etc/env.d/
        #        cp "${FILESDIR}"/99local_cin "${D}"/etc/env.d/
        #fi
}

pkg_postinst() {
	if use pref ; then
		elog "Don't forget to run env-update if first install"
	fi
}
