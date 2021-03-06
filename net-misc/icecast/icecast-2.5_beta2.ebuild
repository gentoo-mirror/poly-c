# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools systemd user

DESCRIPTION="Opensource alternative to shoutcast that supports mp3, ogg and aac streaming"
HOMEPAGE="http://www.icecast.org/"
SRC_URI="http://downloads.xiph.org/releases/icecast/${P/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="kate libressl logrotate +speex +ssl +theora +yp"

#Although there is a --with-ogg and --with-orbis configure option, they're
#only useful for specifying paths, not for disabling.
DEPEND="dev-libs/libxslt
	dev-libs/libxml2
	media-libs/libogg
	media-libs/libvorbis
	kate? ( media-libs/libkate )
	logrotate? ( app-admin/logrotate )
	speex? ( media-libs/speex )
	theora? ( media-libs/libtheora )
	yp? ( net-misc/curl )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-2.4.99.${PV##*_beta}"

PATCHES=(
	# bug #368539
	"${FILESDIR}"/${PN}-2.5_beta2-libkate.patch
	# bug #430434
	"${FILESDIR}"/${PN}-2.3.3-fix-xiph_openssl.patch
)

pkg_setup() {
	enewuser icecast -1 -1 -1 nogroup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		--docdir=/usr/share/doc/${PF}
		--sysconfdir=/etc/icecast2
		$(use_enable kate)
		$(use_with theora)
		$(use_with speex)
		$(use_with yp curl)
		$(use_with ssl openssl)
		$(use_enable yp)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	local DOCS=( AUTHORS README.md HACKING NEWS conf/icecast.xml.dist )
	default

	docinto html
	dodoc doc/*.html

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insinto /etc/icecast2
	doins "${FILESDIR}"/icecast.xml
	fperms 600 /etc/icecast2/icecast.xml

	if use logrotate; then
		dodir /etc/logrotate.d
		insopts -m0644
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/${PN}.logrotate ${PN}
	fi

	diropts -m0764 -o icecast -g nogroup
	dodir /var/log/icecast
	keepdir /var/log/icecast
	rm -r "${D}"/usr/share/doc/icecast || die
}

pkg_postinst() {
	touch "${ROOT}"var/log/icecast/{access,error}.log
	chown icecast:nogroup "${ROOT}"var/log/icecast/{access,error}.log
}
