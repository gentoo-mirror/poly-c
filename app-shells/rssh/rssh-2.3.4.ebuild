# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/rssh/rssh-2.3.4.ebuild,v 1.7 2013/11/14 17:49:51 ottxor Exp $

EAPI=5
inherit autotools eutils multilib

DESCRIPTION="Restricted shell for SSHd"
HOMEPAGE="http://rssh.sourceforge.net/"
SRC_URI="mirror://sourceforge/rssh/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="static"

RDEPEND="virtual/ssh"

src_prepare() {
	EPATCH_SUFFIX="diff" \
	EPATCH_FORCE="yes" \
	epatch "${FILESDIR}"

	epatch_user

	sed -i 's:chmod u+s $(:chmod u+s $(DESTDIR)$(:' Makefile.am || die
	# respect CFLAGS, bug #450458
	sed -i -e '/$(CC) -c/s/$(CPPFLAGS)/$(CFLAGS)/' Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		--libexecdir="/usr/$(get_libdir)/misc" \
		--with-scp=/usr/bin/scp \
		--with-sftp-server="/usr/$(get_libdir)/misc/sftp-server" \
		$(use_enable static)
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog CHROOT INSTALL README TODO
}
