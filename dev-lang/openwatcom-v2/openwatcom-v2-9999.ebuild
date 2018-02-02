# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 129f61dcdb296c77af1e8e1100091e02cce7515e $

EAPI=6

inherit git-r3

MY_PN="open-watcom-v2"

DESCRIPTION="Open Watcom compiler"
HOMEPAGE="https://github.com/open-watcom/open-watcom-v2"
EGIT_REPO_URI="https://github.com/${MY_PN/-v2}/${MY_PN}.git"
LICENSE="OWPL-1"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="clang doc"

DEPEND="
	clang? ( sys-devel/clang )
"

src_configure() {
	export OWROOT="${S}"
	export OWTOOLS="$(usex clang CLANG GCC)"
	export OWDOCBUILD="$(usex doc 1 0)"
	export OWOBJDIR="binbuild"	
	. ${OWROOT}/cmnvars.sh
	export BUILDER_ARG=build
}

src_compile() {
	if [[ ! -d ${OWBINDIR} ]] ; then
		mkdir ${OWBINDIR} || die
	fi
	cd ${OWSRCDIR}/wmake || die
	if [[ ! -d ${OWOBJDIR} ]]; then
		mkdir ${OWOBJDIR} || die
	fi
	cd ${OWOBJDIR} || die
	rm -f ${OWBINDIR}/wmake

	make -f ../posmake clean || die
	make -f ../posmake TARGETDEF=-D__LINUX__ || die

	cd ${OWSRCDIR}/builder || die
	if [[ ! -d ${OWOBJDIR} ]] ; then
		mkdir ${OWOBJDIR} || die
	fi
	cd ${OWOBJDIR} || die
	rm -f ${OWBINDIR}/builder

	${OWBINDIR}/wmake -f ../binmake clean || die
	${OWBINDIR}/wmake -f ../binmake bootstrap=1 builder.exe || die

	cd ${OWSRCDIR} || die
	builder boot || die
	builder ${BUILDER_ARG} || die
}

#src_install() {
#}