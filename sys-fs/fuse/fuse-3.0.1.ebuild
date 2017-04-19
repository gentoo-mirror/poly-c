# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils libtool linux-info udev toolchain-funcs

MY_P=${P/_/}

DESCRIPTION="An interface for filesystems implemented in userspace"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/releases/download/${MY_P}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE="static-libs" # test

PDEPEND="kernel_FreeBSD? ( sys-fs/fuse4bsd )"
DEPEND="
	>=dev-util/meson-0.38
	>=dev-util/ninja-1.5.1
	virtual/pkgconfig
"
	#test? ( dev-python/pytest )

RDEPEND="
	~sys-fs/fuse-common-files-${PV}
	!<sys-fs/fuse-2.9.7-r1
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use kernel_linux ; then
		if kernel_is lt 2 6 9 ; then
			die "Your kernel is too old."
		fi
		CONFIG_CHECK="~FUSE_FS"
		FUSE_FS_WARNING="You need to have FUSE module built to use user-mode utils"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default
	mkdir build || die
}

src_configure() {
	cd build || die
	mesonopts=(
		--prefix=/usr
		--default-library=$(usex static-libs static shared)
	)
	meson "${mesonopts[@]}" || die		
}

src_compile() {
	cd build && ninja -v || die
}

src_install() {
	pushd build &>/dev/null || die
	DESTDIR="${D}" ninja install || die
	popd &>/dev/null || die

	local DOCS=( AUTHORS README.md doc/README.NFS doc/kernel.txt )
	einstalldocs

	rm -r "${D}"/dev || die
	rm -r "${D}"/usr/{etc,lib,share} || die
}

#src_test() {
#	python3 -m pytest ../test/ || die
#}
