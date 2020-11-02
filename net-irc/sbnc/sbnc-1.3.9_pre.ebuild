# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit poly-c_ebuilds

DESCRIPTION="shroudBNC is a modular IRC proxy written in C++."
HOMEPAGE="http://www.shroudbnc.info/"
SRC_URI="http://shroudbnc.info/files/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"
DEPEND="ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"

# sbnc doesnt honor common *nix directory hierarchy. 
# So we have to use this ugly hack.
pkg_setup() {
	if [[ -z "${USER_INSTALLDIR}" ]] ; then
		eerror "You have to specify a valid user homedir when emerging"
		eerror "this package. Please invoke emerge with"
		eerror "USER_INSTALLDIR=\"/home/bob\" emerge ${PN}"
		die "missing USER_INSTALLDIR"
	elif [[ ! -d "${USER_INSTALLDIR}" ]] ; then
		eerror "\"${USER_INSTALLDIR}\" is not a valid installation directory"
		die "invalid directory in USER_INSTALLDIR specified"
	elif [[ "${USER_INSTALLDIR}" == "${EROOT}" ]] ; then
		eerror "You are not allowed to install ${PN} into \"${EROOT}\""
		die "invalid directory in USER_INSTALLDIR specified"
	else
		SBNC_USERNAME="$(stat -c %U ${USER_INSTALLDIR})"
		SBNC_GROUPNAME="$(stat -c %G ${USER_INSTALLDIR})"
	fi
}

src_configure() {
	local myargs=()
	if use ssl ; then
		myargs+=( --enable-ssl=yes )
	else
		myargs+=( --disable-ssl )
	fi
	econf "${myargs[@]}"
}

src_install() {
	exeinto "${USER_INSTALLDIR}/${PN}"
	doexe ${PN} conftool md5tool
	insinto "${USER_INSTALLDIR}/${PN}"
	doins *.so ${PN}.conf ${PN}.tcl
	insinto "${USER_INSTALLDIR}/${PN}/users"
	doins users/*
	insinto "${USER_INSTALLDIR}/${PN}/scripts"
	doins scripts/*
	insinto "${USER_INSTALLDIR}/${PN}/doc"
	doins README*
	chown -R ${SBNC_USERNAME}:${SBNC_GROUPNAME} "${ED}/${USER_INSTALLDIR}"
	if [ -d "${USER_INSTALLDIR}/bin" ] ; then
		dosym ../${PN}/${PN} ${USER_INSTALLDIR}/bin/${PN}
	fi
}
