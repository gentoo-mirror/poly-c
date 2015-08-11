# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: b85c7cc6e51613a11a0b1c0c3c377312e777d961 $

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
