# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: c69464545cce74a62a46859d0fe21a1cdda6d268 $

EAPI=6

inherit toolchain-funcs systemd

MY_P=Mail-SpamAssassin-${PV//_/-}
S=${WORKDIR}/${MY_P}
DESCRIPTION="An extensible mail filter which can identify and tag spam"
HOMEPAGE="http://spamassassin.apache.org/"
SRC_URI="mirror://apache/spamassassin/source/${MY_P}.tar.bz2"

LICENSE="Apache-2.0 GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="+bayes berkdb ipv6 ldap libressl mysql postgres qmail sqlite ssl test"

# You can do without a database unless you need the Bayes features.
REQUIRED_USE="bayes? ( || ( berkdb mysql postgres sqlite ) )"

DEPEND=">=dev-lang/perl-5.8.8-r8
	virtual/perl-MIME-Base64
	>=virtual/perl-Pod-Parser-1.510.0-r2
	virtual/perl-Storable
	virtual/perl-Time-HiRes
	>=dev-perl/HTML-Parser-3.43
	>=dev-perl/Mail-DKIM-0.37
	>=dev-perl/Net-DNS-0.53
	dev-perl/Digest-SHA1
	dev-perl/libwww-perl
	>=virtual/perl-Archive-Tar-1.23
	app-crypt/gnupg
	>=virtual/perl-IO-Zlib-1.04
	>=dev-util/re2c-0.12.0
	dev-perl/Mail-SPF
	>=dev-perl/NetAddr-IP-4.0.1
	dev-perl/Geo-IP
	dev-perl/Encode-Detect
	dev-perl/Net-Patricia
	ssl? (
		dev-perl/IO-Socket-SSL
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	berkdb? (
		virtual/perl-DB_File
	)
	ldap? ( dev-perl/perl-ldap )
	mysql? (
		dev-perl/DBI
		dev-perl/DBD-mysql
	)
	postgres? (
		dev-perl/DBI
		dev-perl/DBD-Pg
	)
	sqlite? (
		dev-perl/DBI
		dev-perl/DBD-SQLite
	)
	ipv6? (
		|| ( dev-perl/IO-Socket-INET6
			virtual/perl-IO-Socket-IP )
	)"
RDEPEND="${DEPEND}"

# Some spamd tests fail, and it looks like the whole suite eventually
# hangs.
RESTRICT=test

PATCHES=(
	"${FILESDIR}/spamassassin-3.4.1-bug_7223.patch"
	"${FILESDIR}/spamassassin-3.4.1-bug_7231.patch"
	"${FILESDIR}/spamassassin-3.4.1-bug_7265.patch"
	"${FILESDIR}/${PN}-3.4.1-no-ssl3.patch"
)

src_configure() {
	# spamc can be built with ssl support.
	local use_ssl="no"
	if use ssl; then
		use_ssl="yes"
	fi

	# Set SYSCONFDIR explicitly so we can't get bitten by bug 48205 again
	# (just to be sure, nobody knows how it could happen in the first place).
	#
	# We also set the path to the perl executable explictly. This will be
	# used to create the initial shebang line in the scripts (bug 62276).
	perl Makefile.PL \
		PREFIX="${EPREFIX}/usr" \
		INSTALLDIRS=vendor \
		SYSCONFDIR="${EPREFIX}/etc" \
		DATADIR="${EPREFIX}/usr/share/spamassassin" \
		PERL_BIN="${EPREFIX}/usr/bin/perl" \
		ENABLE_SSL="${use_ssl}" \
		DESTDIR="${D}" \
		|| die "Unable to build!"

	# Now configure spamc.
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" spamc/Makefile
}

src_compile() {
	PERL_MM_USE_DEFAULT=1 emake

	if use qmail; then
		emake spamc/qmail-spamc
	fi
}

src_install () {
	emake install
	einstalldocs

	# Create the stub dir used by sa-update and friends
	keepdir /var/lib/spamassassin

	# Move spamd to sbin where it belongs.
	dodir /usr/sbin
	mv "${ED}"/usr/bin/spamd "${ED}"/usr/sbin/spamd  || die "move spamd failed"

	if use qmail; then
		dobin spamc/qmail-spamc
	fi

	ln -s mail/spamassassin "${ED}"/etc/spamassassin || die

	# Disable plugin by default
	sed -i -e 's/^loadplugin/\#loadplugin/g' \
		"${ED}"/etc/mail/spamassassin/init.pre \
		|| die "failed to disable plugins by default"

	# Add the init and config scripts.
	newinitd "${FILESDIR}"/3.3.1-spamd.init spamd
	newconfd "${FILESDIR}"/3.0.0-spamd.conf spamd

	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
	systemd_install_serviced "${FILESDIR}"/${PN}.service.conf

	if use postgres; then
		sed -i -e 's:@USEPOSTGRES@::' "${ED}/etc/init.d/spamd" || die

		dodoc sql/*_pg.sql
	else
		sed -i -e '/@USEPOSTGRES@/d' "${ED}/etc/init.d/spamd" || die
	fi

	if use mysql; then
		sed -i -e 's:@USEMYSQL@::' "${ED}/etc/init.d/spamd" || die

		dodoc sql/*_mysql.sql
	else
		sed -i -e '/@USEMYSQL@/d' "${ED}/etc/init.d/spamd" || die
	fi

	dodoc NOTICE TRADEMARK CREDITS INSTALL.VMS UPGRADE USAGE \
		sql/README.bayes sql/README.awl procmailrc.example sample-nonspam.txt \
		sample-spam.txt spamd/PROTOCOL spamd/README.vpopmail \
		spamd-apache2/README.apache

	# Rename some docu files so they don't clash with others
	newdoc spamd/README README.spamd
	newdoc sql/README README.sql
	newdoc ldap/README README.ldap

	if use qmail; then
		dodoc spamc/README.qmail
	fi

	insinto /etc/mail/spamassassin/
	insopts -m0400
	newins "${FILESDIR}"/secrets.cf secrets.cf.example

	# Create the directory where sa-update stores its GPG key (if you
	# choose to import one). If this directory does not exist, the
	# import will fail. This is bug 396307. We expect that the import
	# will be performed as root, and making the directory accessible
	# only to root prevents a warning on the command-line.
	diropts -m0700
	dodir /etc/mail/spamassassin/sa-update-keys
}

pkg_postinst() {
	elog
	elog "No rules are install by default. You will need to run sa-update"
	elog "at least once, and most likely configure SpamAssassin before it"
	elog "will work. You should also consider a cron job for sa-update."
	elog
	elog "Configuration and update help can be found on the wiki:"
	elog
	elog "  https://wiki.gentoo.org/wiki/SpamAssassin"
	elog
}
