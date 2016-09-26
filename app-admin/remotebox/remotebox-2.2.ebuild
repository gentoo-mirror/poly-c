# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

MY_P="RemoteBox-${PV}"

DESCRIPTION="Open Source VirtualBox Client with Remote Management"
HOMEPAGE="http://remotebox.knobgoblin.org.uk/"
SRC_URI="http://remotebox.knobgoblin.org.uk/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/gtk2-perl
	dev-perl/libwww-perl
	dev-perl/SOAP-Lite
	net-misc/freerdp
	>=x11-libs/gtk+-2.24:2
	x11-misc/xdg-utils"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	sed \
		-e 's@$Bin/share@/usr/share@' \
		-e "s@\$Bin/docs@/usr/share/doc/${PF}@" \
		-i ${PN} \
		|| die
}

src_install() {
	dodoc docs/changelog.txt docs/COPYING docs/remotebox.pdf
	dobin remotebox
	insinto /usr
	doins -r share
	insinto /usr/share/applications
	doins packagers-readme/remotebox.desktop
}
