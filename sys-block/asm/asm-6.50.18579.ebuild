# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit multilib rpm versionator

MY_PV="$(replace_all_version_separators _ ${PV})"

DESCRIPTION="Adaptec Storage Manager (ASM)"
HOMEPAGE="http://www.adaptec.com/en-US/downloads/"
SRC_URI="amd64? ( http://download.adaptec.com/raid/storage_manager/${PN}_linux_x64_v${MY_PV}.tgz )
	x86? ( http://download.adaptec.com/raid/storage_manager/${PN}_linux_x86_v${MY_PV}.tgz )"
LICENSE="Adaptec"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="X"
RESTRICT="strip"

RDEPEND="virtual/libstdc++:3.3
	X? ( || ( virtual/jdk:1.6 virtual/jdk:1.5 ) )"

S="${WORKDIR}/usr/StorMan"

src_unpack() {
	local myarch=x86_64
	use x86 && myarch=i386
	
	unpack ${A}
	rpm_unpack ./manager/StorMan-$(get_version_component_range 1-2).${myarch}.rpm \
		|| die
}

src_configure() {
	# binpkg - nothing to do here
	:;
}

src_compile() {
	# binpkg - nothing to do here
	:;
}

src_install() {
	cd "${S}" || die

	if use X ; then
		insinto /opt/StorMan
		doins index.html *.jar *.pps *.so || die
		# StorMan needs the help inside of /opt/StorMan
		doins -r help || die

		into /opt
		dobin "${FILESDIR}"/Stor{Agnt,Man}.sh || die
		sed "s:%LIBDIR%:/usr/$(get_libdir):" \
			-i "${D}"/opt/bin/Stor{Agnt,Man}.sh \
				|| die

		sed 's:\(\.log=\):\1/var/log:g' \
			-i "${D}"/opt/StorMan/RaidLog.pps \
				|| die
	fi

	into /opt/StorMan
	dobin {arc,hr}conf || die
	dosym ../StorMan/bin/arcconf /opt/bin/arcconf || die
	dosym ../StorMan/bin/hrconf /opt/bin/hrconf || die

	newinitd "${FILESDIR}/${PN}-initd" StorAgnt || die
	sed "s:%LIBDIR%:/usr/$(get_libdir):" \
		-i "${D}"/etc/init.d/StorAgnt || die

	dodoc README.TXT || die

}

pkg_postinst() {
	elog "An init script has been installed for your conveniance."
	elog "The Adapatec Storage Agent can be start with /etc/init.d/StorAgnt start"

	if use X ; then
		elog "You can start the GUI from /opt/bin/StorMan.sh"
	fi
}
