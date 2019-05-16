# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools udev poly-c_ebuilds

DESCRIPTION="Library and tool for personalization of Yubico's YubiKey"
SRC_URI="https://github.com/Yubico/yubikey-personalization/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
HOMEPAGE="https://github.com/Yubico/yubikey-personalization"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="BSD-2"
IUSE="consolekit elogind static-libs"

RDEPEND="
	dev-libs/json-c:=
	>=sys-auth/libyubikey-1.6
	virtual/libusb:1"
DEPEND="${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig"
RDEPEND="${RDEPEND}
	consolekit? ( sys-auth/consolekit[acl] )
	elogind? ( sys-auth/elogind[acl] )
"

REQUIRED_USE="^^ ( consolekit elogind )"

S="${WORKDIR}/yubikey-personalization-${MY_PV}"

DOCS=( doc/. AUTHORS NEWS README )

src_prepare() {
	default
	eautoreconf

	if use elogind ; then
		sed '/TEST==/d' -i 70-yubikey.rules || die
	fi	
}

src_configure() {
	local myeconfargs=(
		--libdir=/usr/$(get_libdir)
		--localstatedir=/var
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	if use consolekit || use elogind ; then
		udev_dorules *.rules
	fi

	find "${D}" -name '*.la' -delete || die
}
