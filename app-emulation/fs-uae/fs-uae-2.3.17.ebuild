# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: app-emulation/e-uae/fs-uae,v 1.0 2013/12/08 07:19:41 frostwork Exp $

EAPI="2"

inherit eutils games

DESCRIPTION="a multi-platform Amiga emulator"
HOMEPAGE="http://${PN}.net"
SRC_URI="http://${PN}.net/${PN}/devel/${PV}dev/${P}dev.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="launcher"

RDEPEND="virtual/opengl
		media-libs/freetype:2
		media-libs/openal
		media-libs/libpng
		>=media-libs/libsdl-1.2[joystick,opengl,X]
		sys-libs/zlib"

DEPEND="$RDEPEND"

S="${WORKDIR}/${P}dev"
