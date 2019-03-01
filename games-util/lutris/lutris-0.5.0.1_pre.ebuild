# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
PYTHON_REQ_USE="sqlite,threads"

inherit distutils-r1 eapi7-ver xdg poly-c_ebuilds

DESCRIPTION="Lutris is an open source gaming platform for GNU/Linux."
HOMEPAGE="https://lutris.net/"

REAL_PV="${MY_PV}"
REAL_P="${PN}-${REAL_PV}"
if [[ "${REAL_PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lutris/lutris.git"
else
	#REAL_PV="$(ver_rs 3 - ${MY_PV})"
	#REAL_P="${PN}-${REAL_PV}"
	SRC_URI="https://github.com/lutris/${PN}/archive/v${REAL_PV}.tar.gz -> ${REAL_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	dev-python/python-evdev[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	gnome-base/gnome-desktop[introspection]
	net-libs/libsoup
	net-libs/webkit-gtk:4[introspection]
	sys-auth/polkit
	sys-process/psmisc
	x11-apps/xrandr
	x11-apps/xgamma
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]"

S="${WORKDIR}/${REAL_P}"

list_optional_dependencies() {
	local i package IFS
	local -a optional_packages_sorted_array \
			 optional_packages_array

	optional_packages_array=( "${@}" )
	# shellcheck disable=SC2068
	for i in ${!optional_packages_array[@]}; do
		has_version "${optional_packages_array[i]}" || continue
		unset -v 'optional_packages_array[i]'
	done
	# shellcheck disable=SC2207
	IFS=$'\n' optional_packages_sorted_array=( $(sort <<<"${optional_packages_array[*]}") )
	(( ${#optional_packages_sorted_array[@]} )) || return

	elog "Recommended additional packages:"
	# shellcheck disable=SC2068
	for package in ${optional_packages_sorted_array[@]}; do
		elog "  ${package}"
	done
}

python_install_all() {
	# README.rst contains list of optional deps
	DOCS=( AUTHORS README.rst INSTALL.rst )
	distutils-r1_python_install_all
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	local -a optional_packages_array=(
		"app-emulation/winetricks"
		"dev-util/gtk-update-icon-cache"
		"games-util/xboxdrv"
		"sys-apps/pciutils"
		"virtual/wine"
		"x11-base/xorg-server[xephyr]"
	)

	xdg_pkg_postinst

	list_optional_dependencies "${optional_packages_array[@]}"

	elog "For a list of optional dependencies (runners) see:"
	elog "/usr/share/doc/${PF}/README.rst.bz2"
}

pkg_postrm() {
	xdg_pkg_postrm
}
