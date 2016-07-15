# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 722f09baf5feb4656e2ec9fbacb9eb49abeab5bc $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit versionator virtualx autotools eutils gnome2 fdo-mime multilib python-single-r1 poly-c_ebuilds

DESCRIPTION="GNU Image Manipulation Program"
HOMEPAGE="http://www.gimp.org/"
SRC_URI="mirror://gimp/v$(get_version_component_range 1-2)/${MY_P}.tar.bz2"
LICENSE="GPL-3 LGPL-3"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

LANGS="am ar ast az be bg br ca ca@valencia cs csb da de dz el en_CA en_GB eo es et eu fa fi fr ga gl gu he hi hr hu id is it ja ka kk km kn ko lt lv mk ml ms my nb nds ne nl nn oc pa pl pt pt_BR ro ru rw si sk sl sr sr@latin sv ta te th tr tt uk vi xh yi zh_CN zh_HK zh_TW"
IUSE="alsa aalib altivec aqua debug doc openexr gnome postscript jpeg2k cpu_flags_x86_mmx mng pdf python smp cpu_flags_x86_sse svg tiff udev webkit wmf xpm"

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

RDEPEND="app-arch/bzip2
	>=app-arch/xz-utils-5.0.0
	>=dev-libs/atk-2.2.0
	>=dev-libs/glib-2.43:2
	dev-libs/libxml2
	dev-libs/libxslt
	dev-util/gdbus-codegen
	dev-util/gtk-update-icon-cache
	>=media-libs/babl-0.1.18_pre
	>=media-libs/fontconfig-2.2.0
	>=media-libs/freetype-2.1.7
	>=media-libs/gegl-0.3.8:0.3[cairo]
	>=media-libs/gexiv2-0.6.1
	>=media-libs/harfbuzz-0.9.19
	>=media-libs/lcms-2.2:2
	>=media-libs/libmypaint-1.3.0_beta1
	>=media-libs/libpng-1.2.37:0
	sys-libs/zlib
	virtual/jpeg:0
	>=x11-libs/cairo-1.12.2
	>=x11-libs/gdk-pixbuf-2.31:2
	>=x11-libs/gtk+-2.24.10:2
	x11-libs/libXcursor
	>=x11-libs/pango-1.29.4
	x11-themes/hicolor-icon-theme
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	aqua? ( x11-libs/gtk-mac-integration )
	gnome? ( gnome-base/gvfs )
	jpeg2k? ( media-libs/jasper )
	mng? ( media-libs/libmng )
	openexr? ( >=media-libs/openexr-1.6.1 )
	pdf? ( >=app-text/poppler-0.12.4[cairo] >=app-text/poppler-data-0.4.7 )
	postscript? ( app-text/ghostscript-gpl )
	python?	(
		${PYTHON_DEPS}
		>=dev-python/pygtk-2.10.4:2[${PYTHON_USEDEP}]
	)
	svg? ( >=gnome-base/librsvg-2.36.0:2 )
	tiff? ( >=media-libs/tiff-3.5.7:0 )
	udev? ( virtual/libgudev:= )
	webkit? ( >=net-libs/webkit-gtk-1.6.1:2 )
	xpm? ( x11-libs/libXpm )
	wmf? ( >=media-libs/libwmf-0.2.8 )"
# dev-util/gtk-doc-am due to our call to eautoreconf below (bug #386453)
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40.1
	sys-apps/findutils
	>=sys-devel/automake-1.11
	>=sys-devel/gettext-0.19
	>=sys-devel/libtool-2.2
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog* HACKING NEWS README*"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	G2CONF="
		--disable-silent-rules \
		--enable-default-binary \
		--with-xmc \
		--without-xvfb-run \
		$(use_enable altivec) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable python) \
		$(use_enable smp mp) \
		$(use_with aalib aa) \
		$(use_with alsa) \
		$(use_with !aqua x) \
		$(use_with mng libmng) \
		$(use_with openexr) \
		$(use_with jpeg2k libjasper) \
		$(use_with pdf poppler) \
		$(use_with postscript gs) \
		$(use_with svg librsvg) \
		$(use_with tiff libtiff) \
		$(use_with udev gudev) \
		$(use_with webkit) \
		$(use_with wmf) \
		$(use_with xpm libxpm)"

	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.9.4-gegl.patch"

	sed -i -e 's/== "xquartz"/= "xquartz"/' configure.ac || die #494864
	eautoreconf  # If you remove this: remove dev-util/gtk-doc-am from DEPEND, too

	gnome2_src_prepare
}

_clean_up_locales() {
	einfo "Cleaning up locales..."
	for lang in ${LANGS}; do
		use "linguas_${lang}" && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${ED}"/usr/share/locale/"${lang}" || die
	done
}

src_test() {
	Xemake check
}

src_install() {
	gnome2_src_install

	if use python; then
		python_optimize
	fi

	# Workaround for bug #321111 to give GIMP the least
	# precedence on PDF documents by default
	mv "${ED}"/usr/share/applications/{,zzz-}gimp.desktop || die

	prune_libtool_files --all

	# Prevent dead symlink gimp-console.1 from downstream man page compression (bug #433527)
	local gimp_app_version=$(get_version_component_range 1-2)
	mv "${ED}"/usr/share/man/man1/gimp-console{-${gimp_app_version},}.1 || die

	_clean_up_locales
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
