# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 4610e6318673ec4e56d9fad240abf244f9dc420e $

EAPI=6

inherit flag-o-matic toolchain-funcs versionator poly-c_ebuilds

#REAL_PV="$(get_version_component_range 1-3)"
DEB_PATCH="" #$(get_version_component_range 4)
#REAL_P="${PN}-${REAL_PV}"

DESCRIPTION="Debian Almquist Shell"
HOMEPAGE="http://gondor.apana.org.au/~herbert/dash/"
SRC_URI="http://gondor.apana.org.au/~herbert/dash/files/${MY_P}.tar.gz"
if [[ -n "${DEB_PATCH}" ]] ; then
	DEB_PF="${PN}_${REAL_PV}-${DEB_PATCH}"
	SRC_URI+=" mirror://debian/pool/main/d/dash/${DEB_PF}.diff.gz"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="libedit static vanilla"

RDEPEND="!static? ( libedit? ( dev-libs/libedit ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	libedit? ( static? ( dev-libs/libedit[static-libs] ) )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.9.1-format-security.patch
)

src_prepare() {
	if [[ -n "${DEB_PATCH}" ]] ; then
		eapply "${WORKDIR}"/${DEB_PF}.diff
		eapply */debian/diff/*
	fi

	#337329 #527848
	use vanilla || eapply "${FILESDIR}"/${PN}-0.5.10-dumb-echo.patch

	default

	# Fix the invalid sort
	sed -i -e 's/LC_COLLATE=C/LC_ALL=C/g' src/mkbuiltins

	# Use pkg-config for libedit linkage
	sed -i \
		-e "/LIBS/s:-ledit:\`$(tc-getPKG_CONFIG) --libs libedit $(usex static --static '')\`:" \
		configure || die
}

src_configure() {
	# don't redefine stat on Solaris
	if [[ ${CHOST} == *-solaris* ]] ; then
		export ac_cv_func_stat64=yes

		# if your headers strictly adhere to POSIX, you'll need this too
		[[ ${CHOST##*solaris2.} -le 10 ]] && append-cppflags -DNAME_MAX=255
	fi
	append-cppflags -DJOBS=$(usex libedit 1 0)
	use static && append-ldflags -static
	# Do not pass --enable-glob due to #443552.
	# Autotools use $LINENO as a proxy for extended debug support
	# (i.e. they're running bash), so disable that. #527644
	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		--enable-fnmatch
		--disable-lineno
		$(use_with libedit)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	if [[ -n "${DEB_PATCH}" ]] ; then
		dodoc */debian/changelog
	fi
}
