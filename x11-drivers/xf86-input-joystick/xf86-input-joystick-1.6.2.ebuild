# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org driver for joystick input devices"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.10"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/kbproto"

SRC_URI+=" https://cgit.freedesktop.org/xorg/driver/xf86-input-joystick/patch/?id=a976a85aeff4f2511544c0385533d9387957afae -> ${PN}-1.6.2-hande_device_abort_for_input_ABI-19.1.patch
	https://cgit.freedesktop.org/xorg/driver/xf86-input-joystick/patch/?id=6de3b75c453e4687b21f6d6acfcf87e7041c4fc5 -> ${PN}-1.6.2-use_jstkCloseDevice_on_error.patch
	https://cgit.freedesktop.org/xorg/driver/xf86-input-joystick/patch/?id=341d23ceaa9d5483b5318425e7308e09f8941957 -> ${PN}-1.6.2-add_generic_jstkCloseDevice_helper_function.patch
	https://cgit.freedesktop.org/xorg/driver/xf86-input-joystick/patch/?id=baf8bd4441d5dc6cdd687e066bf13cc1c3df1a41 -> ${PN}-1.6.2-add_support_for_server_managed_fds.patch
	https://cgit.freedesktop.org/xorg/driver/xf86-input-joystick/patch/?id=60d0e9c451b3f259d524b0ddcc5c1f21a4f82293 -> ${PN}-1.6.2-rename_enable_devide.patch"

PATCHES=(
	"${DISTDIR}"/${P}-hande_device_abort_for_input_ABI-19.1.patch
	"${DISTDIR}"/${P}-use_jstkCloseDevice_on_error.patch
	"${DISTDIR}"/${P}-add_generic_jstkCloseDevice_helper_function.patch
	"${DISTDIR}"/${P}-add_support_for_server_managed_fds.patch
	"${DISTDIR}"/${P}-rename_enable_devide.patch
)

src_install() {
	xorg-2_src_install
	insinto /usr/share/X11/xorg.conf.d
	doins config/50-joystick-all.conf
}
