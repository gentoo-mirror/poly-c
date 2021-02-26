# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gstreamer.eclass
# @MAINTAINER:
# gstreamer@gentoo.org
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# Gilles Dartiguelongue <eva@gentoo.org>
# Saleem Abdulrasool <compnerd@gentoo.org>
# foser <foser@gentoo.org>
# zaheerm <zaheerm@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: Helps building core & split gstreamer plugins.
# @DESCRIPTION:
# Eclass to make external gst-plugins emergable on a per-plugin basis
# and to solve the problem with gst-plugins generating far too much
# unneeded dependencies.
#
# GStreamer consuming applications should depend on the specific plugins
# they need as defined in their source code. Usually you can find that
# out by grepping the source tree for 'factory_make'. If it uses playbin
# plugin, consider adding media-plugins/gst-plugins-meta dependency, but
# also list any packages that provide explicitly requested plugins.

inherit multilib meson multilib-minimal toolchain-funcs xdg-utils

case "${EAPI:-0}" in
	6)
		inherit eapi7-ver
		;;
	7)
		;;
	0|1|2|3|4|5)
		die "EAPI=\"${EAPI:-0}\" is not supported anymore"
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported yet"
		;;
esac

# @ECLASS-VARIABLE: GST_PLUGINS_BUILD
# @DESCRIPTION:
# Defines the plugins to be built.
# May be set by an ebuild and contain more than one indentifier, space
# seperated (only src_configure can handle mutiple plugins at this time).
: ${GST_PLUGINS_BUILD:=${PN/gst-plugins-/}}

# @ECLASS-VARIABLE: GST_PLUGINS_BUILD_DIR
# @DESCRIPTION:
# Actual build directory of the plugin.
# Most often the same as the configure switch name.
: ${GST_PLUGINS_BUILD_DIR:=${PN/gst-plugins-/}}

# @ECLASS-VARIABLE: GST_TARBALL_SUFFIX
# @DESCRIPTION:
# Most projects hosted on gstreamer.freedesktop.org mirrors provide
# tarballs as tar.bz2 or tar.xz. This eclass defaults to xz. This is
# because the gstreamer mirrors are moving to only have xz tarballs for
# new releases.
: ${GST_TARBALL_SUFFIX:="xz"}

# Even though xz-utils are in @system, they must still be added to DEPEND; see
# https://archives.gentoo.org/gentoo-dev/msg_a0d4833eb314d1be5d5802a3b710e0a4.xml
if [[ ${GST_TARBALL_SUFFIX} == "xz" ]]; then
	DEPEND="${DEPEND} app-arch/xz-utils"
fi

# @ECLASS-VARIABLE: GST_ORG_MODULE
# @DESCRIPTION:
# Name of the module as hosted on gstreamer.freedesktop.org mirrors.
# Leave unset if package name matches module name.
: ${GST_ORG_MODULE:=$PN}

# @ECLASS-VARIABLE: GST_ORG_PVP
# @INTERNAL
# @DESCRIPTION:
# Major and minor numbers of the version number.
: ${GST_ORG_PVP:=$(get_version_component_range 1-2)}


DESCRIPTION="${BUILD_GST_PLUGINS} plugin for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${GST_ORG_MODULE}/${GST_ORG_MODULE}-${PV}.tar.${GST_TARBALL_SUFFIX}"

LICENSE="GPL-2"
case ${GST_ORG_PVP} in
	1.*) SLOT="1.0"; GST_MIN_PV="1.18.0_pre" ;;
	*) die "Unkown gstreamer release."
esac

S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"

RDEPEND="
	>=dev-libs/glib-2.38.2-r1:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${GST_MIN_PV}:${SLOT}[${MULTILIB_USEDEP}]
"
DEPEND="
	>=sys-apps/sed-4
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

# Export common multilib phases.
multilib_src_configure() { gstreamer_multilib_src_configure; }

if [[ ${PN} != ${GST_ORG_MODULE} ]]; then
	# Do not run test phase for invididual plugin ebuilds.
	RESTRICT="test"
	RDEPEND="${RDEPEND}
		>=media-libs/${GST_ORG_MODULE}-${PV}_pre:${SLOT}[${MULTILIB_USEDEP}]"

	# Export multilib phases used for split builds.
	multilib_src_compile() { gstreamer_multilib_src_compile; }
	multilib_src_install() { gstreamer_multilib_src_install; }
	multilib_src_install_all() { gstreamer_multilib_src_install_all; }
else
	IUSE="nls"
	DEPEND="${DEPEND} nls? ( >=sys-devel/gettext-0.17 )"
fi

DEPEND="${DEPEND} ${RDEPEND}"

# @FUNCTION: gstreamer_environment_reset
# @INTERNAL
# @DESCRIPTION:
# Clean up environment for clean builds.
# >=dev-lang/orc-0.4.23 rely on environment variables to find a place to
# allocate files to mmap.
gstreamer_environment_reset() {
	xdg_environment_reset
}

# @FUNCTION: gstreamer_get_plugins
# @INTERNAL
# @DESCRIPTION:
# Get the list of plugins requiring external dependencies.
gstreamer_get_plugins() {
	# Must be called from src_prepare/src_configure
	GST_PLUGINS_LIST=$(sed -rn "s/^option\('(\w+)',\stype\s:\s'feature'.*/ \1 /p" \
		"${EMESON_SOURCE:-${S}}"/meson_options.txt)
}

# @FUNCTION: gstreamer_get_plugin_dir
# @USAGE: gstreamer_get_plugin_dir [<build_dir>]
# @INTERNAL
# @DESCRIPTION:
# Finds plugin build directory and output it.
# Defaults to ${GST_PLUGINS_BUILD_DIR} if argument is not provided
gstreamer_get_plugin_dir() {
	local build_dir=${1:-${GST_PLUGINS_BUILD_DIR}}

	if [[ ! -d ${S}/ext/${build_dir} ]]; then
		if [[ ! -d ${S}/sys/${build_dir} ]]; then
			ewarn "No such plugin directory"
			die
		fi
		einfo "Building system plugin in ${build_dir}..." >&2
		echo sys/${build_dir}
	else
		einfo "Building external plugin in ${build_dir}..." >&2
		echo ext/${build_dir}
	fi
}

# @FUNCTION: gstreamer_multilib_src_configure
# @DESCRIPTION:
# Handles logic common to configuring gstreamer plugins
gstreamer_multilib_src_configure() {
	local plugin emesonargs=() EMESON_SOURCE=${EMESON_SOURCE:-${S}}

	gstreamer_get_plugins
	gstreamer_environment_reset

	for plugin in ${GST_PLUGINS_LIST} ; do
		if has ${plugin} ${GST_PLUGINS_BUILD} ; then
			emesonargs+=( -D${plugin}=enabled )
		else
			emesonargs+=( -D${plugin}=disabled )
		fi
	done

	if grep -q "option(\'orc\'" "${EMESON_SOURCE}"/meson_options.txt ; then
		if in_iuse orc ; then
			emesonargs+=( -Dorc=$(usex orc enabled disabled) )
		else
			emesonargs+=( -Dorc=disabled )
		fi
	fi

	if grep -q "option(\'maintainer-mode\'" "${EMESON_SOURCE}"/meson_options.txt ; then
		gst_conf+=( -Dmaintainer-mode=disabled )
	fi

	if grep -q "option(\'schemas-compile\'" "${EMESON_SOURCE}"/meson_options.txt ; then
		gst_conf+=( -Dschemas-compile=disabled )
	fi

	if [[ ${PN} == ${GST_ORG_MODULE} ]]; then
		emesonargs+=( -Dnls=$(usex nls) )
	fi

	einfo "Configuring to build ${GST_PLUGINS_BUILD} plugin(s) ..."
	emesonargs+=(
		-Dpackage-name="Gentoo GStreamer ebuild"
		-Dpackage-origin="https://www.gentoo.org"
		"${@}"
	)
	meson_src_configure
}

read -d '' __MESON_EXTRACT_TARGET_FILENAME <<"EOF"
import json
import sys

with open("meson-info/intro-targets.json", "r") as targets_file:
	data = json.load(targets_file)

for i in range(len(data)):
	target = data[i]
	if target['installed']:
		if sys.argv[1] in target['filename'][0]:
			print(target['filename'][0] + ':' + target['install_filename'][0])
EOF

# @FUNCTION: _gstreamer_get_target_filename
# @INTERNAL
# @DESCRIPTION:
# Extracts build and target filenames from meson-data for given submatch
_gstreamer_get_target_filename() {
	python -c "${__MESON_EXTRACT_TARGET_FILENAME}" "$@"
}

# @FUNCTION: gstreamer_multilib_src_compile
# @DESCRIPTION:
# Compiles requested gstreamer plugin.
gstreamer_multilib_src_compile() {
	local plugin_dir plugin

	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		plugin=$(_gstreamer_get_target_filename $(gstreamer_get_plugin_dir ${plugin_dir}))
		plugin_path="${plugin%%:*}"
		eninja "${plugin_path/"${BUILD_DIR}/"}"
	done
}

# @FUNCTION: gstreamer_multilib_src_install
# @DESCRIPTION:
# Installs requested gstreamer plugin.
gstreamer_multilib_src_install() {
	local plugin_dir plugin

	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		for plugin in $(_gstreamer_get_target_filename $(gstreamer_get_plugin_dir ${plugin_dir})); do
			local install_filename="${plugin##*:}"
			insinto "${install_filename%/*}"
			doins "${plugin%%:*}"
		done
	done
}

# @FUNCTION: gstreamer_multilib_src_install_all
# @DESCRIPTION:
# Installs documentation for requested gstreamer plugin, and removes .la
# files.
gstreamer_multilib_src_install_all() {
	local plugin_dir

	for plugin_dir in ${GST_PLUGINS_BUILD_DIR} ; do
		local dir=$(gstreamer_get_plugin_dir ${plugin_dir})
		[[ -e ${dir}/README ]] && dodoc "${dir}"/README
	done
}
