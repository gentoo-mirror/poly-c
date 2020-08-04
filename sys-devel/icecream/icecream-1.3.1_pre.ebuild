# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user poly-c_ebuilds

REAL_P="${MY_P/icecream/icecc}"

DESCRIPTION="Distributed compiling of C(++) code across several machines; based on distcc"
HOMEPAGE="https://github.com/icecc/icecream"
#SRC_URI="ftp://ftp.suse.com/pub/projects/${PN}/${REAL_P}.tar.bz2"
SRC_URI="https://github.com/icecc/${PN}/releases/download/${MY_PV}/${REAL_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"
IUSE=""

DEPEND="
	sys-libs/libcap-ng
"
RDEPEND="
	${DEPEND}
	dev-util/shadowman
"

S="${WORKDIR}/${REAL_P}"

src_configure() {
	local myeconfargs=(
		--disable-static
		--enable-clang-wrappers
		--enable-clang-rewrite-includes
		--enable-shared
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newconfd suse/sysconfig.icecream icecream
	newinitd "${FILESDIR}"/icecream-r2 icecream

	insinto /etc/logrotate.d
	newins suse/logrotate icecream

	insinto /usr/share/shadowman/tools
	newins - icecc <<<'/usr/libexec/icecc/bin'

	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${ROOT} == / ]]; then
		eselect compiler-shadow remove icecc
	fi
}

pkg_postinst() {
	enewgroup icecream
	enewuser icecream -1 -1 /var/cache/icecream icecream

	if [[ ${ROOT} == / ]]; then
		eselect compiler-shadow update icecc
	fi
}
