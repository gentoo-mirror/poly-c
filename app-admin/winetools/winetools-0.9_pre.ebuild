# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils poly-c_ebuilds

REAL_P=${MY_P}jo-III

DESCRIPTION="Graphical Wine tool for installing Windows programs under Wine"
HOMEPAGE="http://www.von-thadden.de/Joachim/WineTools/index.html"
SRC_URI="http://www.openoffice.de/wt/${REAL_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="app-emulation/wine
	nls? ( sys-devel/gettext )
	x11-misc/xdialog"
DEPEND=""

S=${WORKDIR}/${REAL_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s:\${BASEDIR}/doc:/usr/share/doc/${PF}:g" \
		-e "/^DIALOG=/s:=.*:=\$(which Xdialog):" \
		-e "s:/usr/local/${PN}:/usr/share/${PN}:g" \
		-e "s:/usr/local/share/locale:/usr/share/locale:g" \
		-e "/README/s:cat:zcat:" \
		findwine wt${MY_PV}jo || die "sed"
}

src_install() {
	dodoc doc/README.* doc/*.txt
	dohtml doc/*.html doc/*.gif

	if use nls ; then
		local i
		for i in po/*.po ; do
			i=${i##*/}
			i=${i%.po}
			dodir /usr/share/locale/${i}/LC_MESSAGES
			msgfmt po/${i}.po -o \
				"${D}"/usr/share/locale/${i}/LC_MESSAGES/wt${MY_PV}.mo \
				|| die "msgfmt ${i} failed"
		done
	fi

	exeinto /usr/share/${PN}
	doexe wt${MY_PV}jo chopctrl.pl findwine listit || die "doexe"

	insinto /usr/share/${PN}
	doins -r *.reg gettext.sh.dummy icon scripts 3rdParty || die "doins"

	dodir /usr/bin
	dosym /usr/share/${PN}/findwine /usr/bin/findwine
	dosym /usr/share/${PN}/wt${MY_PV}jo /usr/bin/wt
	dosym /usr/share/${PN}/wt${MY_PV}jo /usr/bin/${PN}

	doicon icon/${PN}.png || die "doicon"
	make_desktop_entry ${PN} Winetools wine Emulation
}
