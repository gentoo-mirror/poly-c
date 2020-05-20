# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: d45b53b560a1b222326e276969e432df713598dd $

EAPI=7

inherit systemd toolchain-funcs

DESCRIPTION="Shows and sets processor power related values"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="https://www.kernel.org/pub/linux/kernel/v${PV%%.*}.x/linux-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="nls"

# File collision w/ headers of the deprecated cpufrequtils
RDEPEND="sys-apps/pciutils
	!<sys-apps/linux-misc-apps-3.6-r2
	!sys-power/cpufrequtils"
DEPEND="${RDEPEND}
	virtual/os-headers
	nls? ( sys-devel/gettext )"

PATCHES=(
	-p4 "${FILESDIR}/cpupower-5.4-cflags.patch"
)

S="${WORKDIR}/linux-${PV}/tools/power/${PN}"

src_configure() {
	export bindir="${EPREFIX}/usr/bin"
	export sbindir="${EPREFIX}/usr/sbin"
	export mandir="${EPREFIX}/usr/share/man"
	export includedir="${EPREFIX}/usr/include"
	export libdir="${EPREFIX}/usr/$(get_libdir)"
	export localedir="${EPREFIX}/usr/share/locale"
	export docdir="${EPREFIX}/usr/share/doc/${PF}"
	export confdir="${EPREFIX}/etc"
	export V=1
	export NLS=$(usex nls true false)
	export INSTALL_MOD_STRIP=true
}

src_compile() {
	myemakeargs=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		LD="$(tc-getCC)"
		VERSION=${PV}
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	emake "${myemakeargs[@]}" DESTDIR="${D}" install
	doheader lib/cpupower.h
	einstalldocs

	newconfd "${FILESDIR}"/conf.d-r2 cpupower
	newinitd "${FILESDIR}"/init.d-r4 cpupower

	systemd_dounit "${FILESDIR}"/cpupower-frequency-set.service
	systemd_install_serviced "${FILESDIR}"/cpupower-frequency-set.service.conf
}
