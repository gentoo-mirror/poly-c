# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 3cc91e932e0394df1ffda5b170e56a143a4c4167 $

EAPI=7

LUA_COMPAT=( lua5-{1..4} )

inherit readme.gentoo-r1 cmake flag-o-matic lua-single toolchain-funcs udev user xdg

DESCRIPTION="Utility for advanced configuration of Roccat devices"

HOMEPAGE="http://roccat.sourceforge.net/"
SRC_URI="mirror://sourceforge/roccat/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LUA_IUSE=(
	input_devices_roccat_ryosmk
	input_devices_roccat_ryosmkfx
	input_devices_roccat_ryostkl
)

IUSE_INPUT_DEVICES=(
	input_devices_roccat_arvo
	input_devices_roccat_isku
	input_devices_roccat_iskufx
	input_devices_roccat_kiro
	input_devices_roccat_kone
	input_devices_roccat_koneplus
	input_devices_roccat_konepure
	input_devices_roccat_konepuremilitary
	input_devices_roccat_konepureoptical
	input_devices_roccat_konextd
	input_devices_roccat_konextdoptical
	input_devices_roccat_kovaplus
	input_devices_roccat_kova2016
	input_devices_roccat_lua
	input_devices_roccat_nyth
	input_devices_roccat_pyra
	${LUA_IUSE[@]}
	input_devices_roccat_savu
	input_devices_roccat_skeltr
	input_devices_roccat_sova
	input_devices_roccat_suora
	input_devices_roccat_tyon
)

IUSE="${IUSE_INPUT_DEVICES[@]}"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	>=dev-libs/libgaminggear-0.15.1
	dev-libs/libgudev:=
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libX11
	virtual/libusb:1
	$(for lua_use in ${LUA_IUSE[@]} ; do echo "${lua_use}? ( ${LUA_DEPS} )" ; done)
"

DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( Changelog KNOWN_LIMITATIONS README )

PATCHES=(
	# Taken from https://github.com/LadyBoonami/roccat-tools
	"${FILESDIR}/${PN}-5.9.0-kova_aimo.patch"
)

pkg_setup() {
	enewgroup roccat

	local model
	for model in ${IUSE_INPUT_DEVICES[@]} ; do
		use ${model} && USED_MODELS+="${model/input_devices_roccat_/;}"
	done

	local luse
	for luse in ${LUA_IUSE[@]} ; do
		if use ${luse} ; then
			lua-single_pkg_setup
			break
		fi
	done
}

# Required because xdg.eclass overrides src_prepare() from cmake.eclass
src_prepare() {
	cmake_src_prepare
}

src_configure() {
	if has_version \>=x11-libs/pango-1.44.0 ; then
		# Fix build with pango-1.44 which depends on harfbuzz
		local PKGCONF="$(tc-getPKG_CONFIG)"
		append-cflags "$(${PKGCONF} --cflags harfbuzz)"
	fi

	mycmakeargs=(
		-DDEVICES="${USED_MODELS/;/}"
		-DUDEVDIR="${EPREFIX}$(get_udevdir)/rules.d"
	)

	local luse
	for luse in ${LUA_IUSE[@]} ; do
		if use ${luse} ; then
			mycmakeargs+=( -DWITH_LUA="$(lua_get_version)" )
			break
		fi
	done

	cmake_src_configure
}

src_install() {
	cmake_src_install
	local stat_dir=/var/lib/roccat
	keepdir ${stat_dir}
	fowners root:roccat ${stat_dir}
	fperms 2770 ${stat_dir}
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	readme.gentoo_print_elog
	ewarn
	ewarn "This version breaks stored data for some devices. Before reporting bugs please delete"
	ewarn "affected folder(s) in /var/lib/roccat"
	ewarn
}
