# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit bash-completion-r1 elisp-common distutils-r1 flag-o-matic $vcs poly-c_ebuilds

if [[ "$PV" == *9999* ]] ; then
	inherit mercurial
	EHG_REPO_URI=https://www.mercurial-scm.org/repo/hg
	EHG_REVISION=@
else
	SRC_URI="https://www.mercurial-scm.org/release/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="https://www.mercurial-scm.org/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+chg bugzilla emacs gpg test tk"

PYTHON_THREADS_USE="
	$(python_gen_impl_dep 'threads' -2)
	$(python_gen_impl_dep 'threads' 'python3_6')"

# From mercurial's setup.py:
# 	Mercurial will never work on Python 3 before 3.5 due to a lack
# 	of % formatting on bytestrings, and can't work on 3.6.0 or 3.6.1
# 	due to a bug in % formatting in bytestrings.
# 	We cannot support Python 3.5.0, 3.5.1, 3.5.2 because of bug in
# 	codecs.escape_encode() where it raises SystemError on empty bytestring
# 	bug link: https://bugs.python.org/issue25270
BROKEN_PYTHON3_6="
	!~dev-lang/python-3.6.0
	!~dev-lang/python-3.6.1"

BDEPEND="
	${PYTHON_THREADS_USE}
	${BROKEN_PYTHON3_6}
	$(python_gen_any_dep "dev-python/docutils[${PYTHON_USEDEP}]")"

RDEPEND="
	${PYTHON_THREADS_USE}
	${BROKEN_PYTHON3_6}
	app-misc/ca-certificates
	dev-python/zstandard[${PYTHON_USEDEP}]
	bugzilla? ( dev-python/mysqlclient[${PYTHON_USEDEP}] )
	gpg? ( app-crypt/gnupg )
	tk? ( dev-lang/tk )"

DEPEND="emacs? ( >=app-editors/emacs-23.1:* )
	test? ( app-arch/unzip
	dev-python/pygments[${PYTHON_USEDEP}] )"

SITEFILE="70${PN}-gentoo.el"

# Too many tests fail #608720
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.1-po_fixes.patch"
	"${FILESDIR}/${PN}-5.2-unbundle_zstd.patch"
)

python_prepare_all() {
	# fix up logic that won't work in Gentoo Prefix (also won't outside in
	# certain cases), bug #362891
	sed -i -e 's:xcodebuild:nocodebuild:' setup.py || die

	# Don't use bundled zstandard (#666972)
	rm -r contrib/python-zstandard || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	strip-flags -ftracer -ftree-vectorize
	# Note: make it impl-conditional if py3 is supported
	append-flags -fno-strict-aliasing

	"${PYTHON}" setup.py build_mo || die
}

src_compile() {
	rm -r contrib/win32 || die
	local dirs=(doc)
	use chg && dirs+=(contrib/chg)

	python_check_deps() {
		has_version "dev-python/docutils[${PYTHON_USEDEP}]"
	}
	python_setup
	unset -f python_check_deps

	for d in ${dirs[@]}
	do
		cd "${d}" || die "Failed to change directory to ${d}"
		emake
		cd - || die "Failed to restore directory to ${OLDPWD:--}"
	done
	if use emacs; then
		cd contrib || die
		elisp-compile mercurial.el || die "elisp-compile failed!"
	fi
	distutils-r1_src_compile
}

python_install_all() {
	distutils-r1_python_install_all

	newbashcomp contrib/bash_completion hg

	insinto /usr/share/zsh/site-functions
	newins contrib/zsh_completion _hg

	rm -f doc/*.?.txt
	dodoc CONTRIBUTORS
	cp hgweb*.cgi "${ED}"/usr/share/doc/${PF}/ || die

	dobin hgeditor
	dobin contrib/hgk
	python_foreach_impl python_doscript contrib/hg-ssh

	if use emacs; then
		elisp-install ${PN} contrib/mercurial.el* || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	local RM_CONTRIB=( hgk hg-ssh bash_completion zsh_completion plan9 *.el )

	if use chg; then
		dobin contrib/chg/chg
		doman contrib/chg/chg.1
		RM_CONTRIB+=( chg )
	fi

	for f in ${RM_CONTRIB[@]}; do
		rm -r contrib/${f} || die
	done

	dodoc -r contrib
	docompress -x /usr/share/doc/${PF}/contrib
	doman doc/*.?

	insinto /etc/mercurial/hgrc.d
	doins "${FILESDIR}/cacerts.rc"

	# symlink to system zstd only if using python2.7
	# python3.x versions of dev-python/zstandard lack
	# a zstd.so so creating this symlink results in a
	# dangling symlink which triggers a QA warning.
	if use python_targets_python2_7
	then
		python_setup python2_7
		local sitedir=$(python_get_sitedir python2_7)
		dosym ../zstd.so "${sitedir#${EPREFIX}}"/${PN}/zstd.so
	fi
}

src_test() {
	pushd tests &>/dev/null || die
	rm -rf *svn*			# Subversion tests fail with 1.5
	rm -f test-archive*		# Fails due to verbose tar output changes
	rm -f test-convert-baz*		# GNU Arch baz
	rm -f test-convert-cvs*		# CVS
	rm -f test-convert-darcs*	# Darcs
	rm -f test-convert-git*		# git
	rm -f test-convert-mtn*		# monotone
	rm -f test-convert-tla*		# GNU Arch tla
	#rm -f test-doctest*		# doctest always fails with python 2.5.x
	rm -f test-largefiles*		# tends to time out

	popd &>/dev/null || die
	distutils-r1_src_test
}

python_test() {
	local TEST_DIR

	rm -rf "${TMPDIR}"/test
	distutils_install_for_testing
	cd tests || die
	"${PYTHON}" run-tests.py --verbose \
		--tmpdir="${TMPDIR}"/test \
		--with-hg="${TEST_DIR}"/scripts/hg \
		|| die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	use emacs && elisp-site-regen

	elog "If you want to convert repositories from other tools using convert"
	elog "extension please install correct tool:"
	elog "  dev-vcs/cvs"
	elog "  dev-vcs/darcs"
	elog "  dev-vcs/git"
	elog "  dev-vcs/monotone"
	elog "  dev-vcs/subversion"
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
