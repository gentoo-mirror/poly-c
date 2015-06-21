# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils
DESCRIPTION="LDAP Explorer is a multi platform, graphical LDAP tool that enables you to browse, modify and manage LDAP servers."
HOMEPAGE="http://sourceforge.net/projects/ldaptool/"
SRC_URI="mirror://sourceforge/ldaptool/${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-nds/openldap
	>=x11-libs/wxGTK-2.6"
RDEPEND="${DEPEND}"

src_prepare() {
	sed '/\/usr\/local/s:^\(.*\)$:#\1:;/\/usr\/include/s:^#\(.*\)$:\1:' \
		-i "${S}"/GNUmakefile.config \
			|| die "sed GNUmakefile.config failed"
	sed 's:install src/$(TOOLNAME) $(TOOL_DIR):install src/$(TOOLNAME) -t $(TOOL_DIR):' \
		-i "${S}"/GNUmakefile || die "sed GNUmakefile failed"
	sed '/OnCancel/d' -i "${S}"/src/attribute_add_dlg.cc \
		-i "${S}"/src/newentrydlg.cc || die "sed of source files failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
