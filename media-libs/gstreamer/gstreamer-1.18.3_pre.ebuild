# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 gstreamer-meson multilib-minimal pax-utils poly-c_ebuilds

DESCRIPTION="Open source multimedia framework"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/src/${PN}/${MY_P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+caps +introspection nls +orc test unwind"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	caps? ( sys-libs/libcap[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	unwind? (
		>=sys-libs/libunwind-1.2_rc1[${MULTILIB_USEDEP}]
		dev-libs/elfutils[${MULTILIB_USEDEP}]
	)
	!<media-libs/gst-plugins-bad-1.13.1:1.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.12
	sys-devel/bison
	sys-devel/flex
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	nls? ( sys-devel/gettext )
"

src_configure() {
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local completiondir="$(get_bashcompdir)"
	# Set 'libexecdir' to ABI-specific location for the library spawns
	# helpers from there.
	# Disable static archives and examples to speed up build time
	# Disable debug, as it only affects -g passing (debugging symbols), this must done through make.conf in gentoo
	local emesonargs=(
		-Dbenchmarks=disabled
		-Dexamples=disabled
		-Dgst_debug=false
		-Dcheck=enabled
		$(meson_feature unwind libunwind)
		$(meson_feature unwind libdw)
		-Dintrospection="$(multilib_native_usex introspection enabled disabled)"
		$(meson_feature nls)
		$(meson_feature test tests)
		-Dbash-completion=enabled
		-Dpackage-name="GStreamer ebuild for Gentoo"
		-Dpackage-origin="https://packages.gentoo.org/package/media-libs/gstreamer"
	)
	#	-Dintrospection=$(multilib_native_usex introspection)

	if use caps ; then
		emesonargs+=( -Dptp-helper-permissions=capabilities )
	else
		emesonargs+=(
			-Dptp-helper-permissions=setuid-root
			-Dptp-helper-setuid-user=nobody
			-Dptp-helper-setuid-group=nobody
		)
	fi

	meson_src_configure
}

multilib_src_install() {
	# can't do "default", we want to install docs in multilib_src_install_all
	DESTDIR="${D}" eninja install

	# Needed for orc-using gst plugins on hardened/PaX systems, bug #421579
	use orc && pax-mark -m "${ED}usr/$(get_libdir)/gstreamer-${SLOT}/gst-plugin-scanner"
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog NEWS MAINTAINERS README RELEASE"
	einstalldocs

	# Needed for orc-using gst plugins on hardened/PaX systems, bug #421579
	use orc && pax-mark -m "${ED}usr/bin/gst-launch-${SLOT}"
}
