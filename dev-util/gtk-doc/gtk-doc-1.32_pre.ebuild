# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )

inherit eutils elisp-common gnome2 python-single-r1 readme.gentoo-r1 poly-c_gnome

DESCRIPTION="GTK+ Documentation Generator"
HOMEPAGE="https://www.gtk.org/gtk-doc/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"

IUSE="debug doc emacs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.6:2
	>=dev-lang/perl-5.18
	dev-libs/libxslt
	>=dev-libs/libxml2-2.3.6:2
	~app-text/docbook-xml-dtd-4.3
	app-text/docbook-xsl-stylesheets
	~app-text/docbook-sgml-dtd-3.0
	>=app-text/docbook-dsssl-stylesheets-1.40
	emacs? ( virtual/emacs )
"
DEPEND="${RDEPEND}
	~dev-util/gtk-doc-am-${PV}
	dev-util/itstool
	virtual/pkgconfig
"

pkg_setup() {
	DOC_CONTENTS="gtk-doc does no longer define global key bindings for Emacs.
		You may set your own key bindings for \"gtk-doc-insert\" and
		\"gtk-doc-insert-section\" in your ~/.emacs file."
	SITEFILE=61${PN}-gentoo.el
	python-single-r1_pkg_setup
}

src_prepare() {
	# Remove global Emacs keybindings, bug #184588
	eapply "${FILESDIR}"/${PN}-1.8-emacs-keybindings.patch

	# Apply upstream commit 1baf9a6, bug #646850
	sed -e '1,/exit 1/s/exit 1/exit $1/' \
		-i gtkdoc-mkpdf.in || die

	gnome2_src_prepare
}

src_configure() {
	local myconf=(
		--with-xml-catalog="${EPREFIX}"/etc/xml/catalog
		$(use_enable debug)
	)

	gnome2_src_configure "${myconf[@]}"
}

src_compile() {
	gnome2_src_compile
	use emacs && elisp-compile tools/gtk-doc.el
}

src_install() {
	gnome2_src_install

	# Don't install those files, they are in gtk-doc-am now
	rm "${ED%/}"/usr/share/aclocal/gtk-doc.m4 || die "failed to remove gtk-doc.m4"
	rm "${ED%/}"/usr/bin/gtkdoc-rebase || die "failed to remove gtkdoc-rebase"
	rm -r "${ED%/}"/usr/share/gtk-doc/python || die "failed to remove gtkdoc python modules"

	python_fix_shebang "${ED}"

	if use doc; then
		docinto doc
		dodoc doc/*
		docinto examples
		dodoc examples/*
	fi

	if use emacs; then
		elisp-install ${PN} tools/gtk-doc.el*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		readme.gentoo_create_doc
	fi
}

src_test() {
	emake -j1 check
}

pkg_postinst() {
	gnome2_pkg_postinst
	if use emacs; then
		elisp-site-regen
		readme.gentoo_print_elog
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm
	use emacs && elisp-site-regen
}
