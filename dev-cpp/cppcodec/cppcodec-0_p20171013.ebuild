# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils vcs-snapshot

COMMIT_HASH="61d9b044d6644293f99fb87dfadc15dcab951bd9"

DESCRIPTION="Header-only C++11 library to encode/decode base64, base64url, base32, base32hex and hex"
HOMEPAGE="https://github.com/tplgy/cppcodec"
SRC_URI="https://github.com/tplgy/cppcodec/tarball/${COMMIT_HASH} -> ${P}.tar.gz"
LICENSE=""
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-cpp/catch"

PATCHES=(
	"${FILESDIR}/${PN}-0_p20171013-includes_fix.patch"
)
