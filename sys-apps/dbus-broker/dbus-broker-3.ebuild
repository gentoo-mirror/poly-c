# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="Linux D-Bus Message Broker"
HOMEPAGE="https://github.com/bus1/dbus-broker"
SRC_URI="https://github.com/bus1/dbus-broker/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+compat selinux"

RDEPEND="
	compat? (
		>=dev-libs/expat-2.2
		>=dev-libs/glib-2.50
		>=sys-apps/dbus-1.10
		>=virtual/libudev-2.30
	)
	selinux? ( >=sys-libs/libselinux-2.5 )
"

DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

#src_configure() {
#	local emesonargs=(
#	)
#	meson_src_configure
#}
