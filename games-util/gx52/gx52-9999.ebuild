# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit meson python-r1 xdg

DESCRIPTION="GTK app for control of the LEDs and MFD of Logitech X52 (Pro)"
HOMEPAGE="https://gitlab.com/leinardi/gx52"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/leinardi/gx52.git"
else
	SRC_URI="https://gitlab.com/leinardi/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE=""
SLOT="0"

IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="virtual/pkgconfig"
DEPEND="
	${PYTHON_DEPS}
	dev-libs/appstream-glib
	dev-libs/gobject-introspection
	virtual/libusb
	virtual/libudev
"
RDEPEND="
	${DEPEND}
	>=dev-python/injector-0.18.3[${PYTHON_USEDEP}]
	>=dev-python/peewee-3.13.2[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	>=dev-python/pyudev-0.22.0[${PYTHON_USEDEP}]
	>=dev-python/pyusb-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/pyxdg-0.26[${PYTHON_USEDEP}]
	>=dev-python/requests-2.23.0[${PYTHON_USEDEP}]
	>=dev-python/Rx-3.1.0_pre[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

python_install() {
	meson_src_install
	_python_export PYTHON_SCRIPTDIR
	dodir "${PYTHON_SCRIPTDIR#${EPREFIX}}"
	mv "${ED}/usr/bin/${PN}" "${ED}/${PYTHON_SCRIPTDIR#${EPREFIX}}" || die
	python_optimize
}

src_configure() {
	python_foreach_impl meson_src_configure
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_install() {
	python_foreach_impl python_install
	_python_ln_rel "${ED}/usr/lib/python-exec/python-exec2" \
		"${ED}/usr/bin/${PN}" || die
	einstalldocs
}
