# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit poly-c_ebuilds

DESCRIPTION="Terminal Emulator State Machine"
HOMEPAGE="http://cgit.freedesktop.org/~dvdhrm/libtsm"
SRC_URI="http://www.freedesktop.org/software/kmscon/releases/${MY_P}.tar.xz"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!!<sys-apps/kmscon-8_pre"
RDEPEND="${DEPEND}"
