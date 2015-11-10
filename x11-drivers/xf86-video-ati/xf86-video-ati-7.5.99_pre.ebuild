# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_DRI=always
inherit autotools linux-info xorg-2

DESCRIPTION="ATI video driver"
HOMEPAGE="http://www.x.org/wiki/ati/"

SRC_URI="http://xorg.freedesktop.org/releases/individual/driver/${PN}-7.5.0.tar.bz2"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="+glamor udev"

RDEPEND=">=x11-libs/libdrm-2.4.58[video_cards_radeon]
	>=x11-libs/libpciaccess-0.8.0
	glamor? ( || (
		x11-base/xorg-server[glamor]
		>=x11-libs/glamor-0.6
	) )
	udev? ( virtual/udev )"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86driproto
	x11-proto/xproto"

PATCHES=(
	"${FILESDIR}/${PN}-7.5.99-git20151110.patch.xz"
)

S="${WORKDIR}/${PN}-7.5.0"

pkg_pretend() {
	if use kernel_linux ; then
		if kernel_is -ge 3 9; then
			CONFIG_CHECK="~!DRM_RADEON_UMS ~!FB_RADEON"
		else
			CONFIG_CHECK="~DRM_RADEON_KMS ~!FB_RADEON"
		fi
	fi
	check_extra_config
}

src_prepare() {
	xorg-2_src_prepare
	eautoreconf
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable glamor)
		$(use_enable udev)
	)
	xorg-2_src_configure
}
