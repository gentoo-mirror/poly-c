# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/Ice/Ice-3.5.1.ebuild,v 1.11 2015/04/08 17:51:56 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )
RUBY_OPTIONAL="yes"
USE_RUBY="ruby21"

inherit toolchain-funcs versionator python-r1 mono-env ruby-ng db-use poly-c_ebuilds

DESCRIPTION="ICE middleware C++ library and generator tools"
HOMEPAGE="http://www.zeroc.com/"
SRC_URI="https://github.com/zeroc-ice/ice/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	doc? ( http://www.zeroc.com/download/Ice/$(get_version_component_range 1-2)/${MY_P}.pdf )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~x86 ~x86-linux ~x64-macos"
IUSE="doc examples +ncurses mono python ruby test debug"

RDEPEND=">=dev-libs/expat-2.0.1
	>=app-arch/bzip2-1.0.5
	>=dev-libs/openssl-0.9.8o:0
	|| (
		sys-libs/db:6.1[cxx]
		sys-libs/db:5.3[cxx]
		sys-libs/db:5.1[cxx]
		sys-libs/db:4.8[cxx]
	)
	dev-cpp/libmcpp
	python? ( ${PYTHON_DEPS} )
	ruby? ( $(ruby_implementation_depend ruby21) )
	mono? ( dev-lang/mono )
	!dev-python/IcePy
	!dev-ruby/IceRuby"
DEPEND="${RDEPEND}
	ncurses? ( sys-libs/ncurses sys-libs/readline )
	test? ( ${PYTHON_DEPS} )"

# Maintainer notes:
# - yes, we have to do the trickery with the move for the python functions
#   since the build and test frameworks deduce various settings from the path
#   and they can't be tricked by a symlink. And we also need
#   SUPPORT_PYTHON_ABIS=1 otherwise we can't get pyc/pyo anymore the sane way.
# TODO: php bindings
# TODO: java bindings

#overwrite ruby-ng.eclass default
S="${WORKDIR}/${MY_P/I/i}"

pkg_setup() {
	# prevent ruby-ng.eclass from messing with pkg_setup
	:;
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	default
}

src_prepare() {
	sed -i \
		-e 's|\(install_docdir[[:space:]]*\):=|\1?=|' \
		-e 's|\(install_configdir[[:space:]]*\):=|\1?=|' \
		cpp/config/Make.rules || die "sed failed"

	sed -i \
		-e 's|\(install_pythondir[[:space:]]*\):=|\1?=|' \
		-e 's|\(install_rubydir[[:space:]]*\):=|\1?=|' \
		-e 's|\(install_libdir[[:space:]]*\):=|\1?=|' \
		{python,ruby}/config/Make.rules || die "sed failed"

	sed -i \
		-e 's|-O2 ||g' \
		-e 's|-Werror ||g' \
		cpp/config/Make.rules.Linux || die "sed failed"

	sed -i \
		-e 's|install-common||' \
		-e 's|demo||' \
		{cpp,csharp,php,python,ruby}/Makefile || die "sed failed"

	sed -i \
		-e 's|-f -root|-f -gacdir $(GAC_DIR) -root|' \
		csharp/config/Make.rules.cs || die "sed failed"

	# skip mono tests, bug #498484
	sed -i \
		-e 's|^\(SUBDIRS.*\)test|\1|' \
		csharp/Makefile || die "sed failed"

	if ! use test ; then
		sed -i \
			-e 's|^\(SUBDIRS.*\)test|\1|' \
			{cpp,php,python,ruby}/Makefile || die "sed failed"
	fi
}

suitable_db_version() {
	local tested_slots="6.1 5.3 5.1 4.8"
	for ver in ${tested_slots}; do
		if [[ -n $(db_findver sys-libs/db:${ver}) ]]; then
			echo ${ver}
			return 0
		fi
	done
	die "No suitable BerkDB versions found, aborting"
}

src_configure() {
	MAKE_RULES="prefix=\"${ED}/usr\"
		install_docdir=\"${ED}/usr/share/doc/${PF}\"
		install_configdir=\"${ED}/usr/share/${P}/config\"
		install_mandir=\"${ED}/usr/share/man\"
		embedded_runpath_prefix=\"${EPREFIX}/usr\"
		LP64=yes"

	use ncurses && OPTIONS="${MAKE_RULES} USE_READLINE=yes" || MAKE_RULES="${MAKE_RULES} USE_READLINE=no"
	use debug && OPTIONS"${MAKE_RULES} OPTIMIZE=no" || MAKE_RULES="${MAKE_RULES} OPTIMIZE=yes"

	local BERKDB_VERSION="$(suitable_db_version)"
	MAKE_RULES="${MAKE_RULES} DB_FLAGS=-I$(db_includedir ${BERKDB_VERSION})"
	sed -i \
		-e "s|g++|$(tc-getCXX)|" \
		-e "s|\(CFLAGS[[:space:]]*=\)|\1 ${CFLAGS}|" \
		-e "s|\(CXXFLAGS[[:space:]]*=\)|\1 ${CXXFLAGS}|" \
		-e "s|\(LDFLAGS[[:space:]]*=\)|\1 ${LDFLAGS}|" \
		-e "s|\(DB_LIBS[[:space:]]*=\) \-ldb_cxx|\1 -ldb_cxx-$(db_findver sys-libs/db:${BERKDB_VERSION})|" \
		cpp/config/Make.rules{,.Linux} python/config/Make.rules || die "sed failed"

	if use python ; then
		S=${S}/python python_copy_sources

		# make a place for the symlink
		rm -r python/python || die
	fi

	if use ruby ; then
		SITERUBY="$(ruby21 -r rbconfig -e 'print Config::CONFIG["sitedir"]')"
		MAKE_RULES_RB="install_rubydir=\"${ED}/${SITERUBY}\"
			install_libdir=\"${ED}/${SITERUBY}\""

		# make it use ruby21 only
		sed -i \
			-e 's|RUBY = ruby|\021|' \
			ruby/config/Make.rules || die "sed failed"
	fi

	MAKE_RULES_CS="GACINSTALL=yes GAC_ROOT=\"${ED}/usr/$(get_libdir)\" GAC_DIR=${EPREFIX}/usr/$(get_libdir)"

	use test && python_export_best
}

src_compile() {
	# Do not remove this export or build will break!
	tc-export CXX

	emake -C cpp ${MAKE_RULES} || die "emake failed"

	if use doc ; then
		emake -C cpp/doc || die "building docs failed"
	fi

	if use python ; then
		building() {
			emake -C "${BUILD_DIR}" ${MAKE_RULES} || die "emake py-${EPYTHON} failed"
		}
		BUILD_DIR=python python_foreach_impl building
	fi

	if use ruby ; then
		emake -C ruby ${MAKE_RULES} ${MAKE_RULES_RB} || die "emake rb failed"
	fi

	if use mono ; then
		emake -C csharp ${MAKE_RULES} ${MAKE_RULES_CS} || die "emake csharp failed"
	fi
}

src_install() {
	dodoc CHANGELOG*.md README.md

	insinto /usr/share/${PN}
	doins -r slice

	emake -C cpp ${MAKE_RULES} install || die "emake install failed"

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples-cpp
		doins cpp/config/*.cfg
		doins -r cpp/demo/*
	fi

	if use doc ; then
		dohtml -r cpp/doc/reference/*
		dodoc "${DISTDIR}/${MY_P}.pdf"
	fi

	if use python ; then
		installation() {
			mkdir -p "${D}/$(python_get_sitedir)" || die

			emake -C "${BUILD_DIR}" ${MAKE_RULES} \
				install_pythondir="\"${D}/$(python_get_sitedir)\"" \
				install_libdir="\"${D}/$(python_get_sitedir)\"" \
				install || die "emake py-${EPYTHON} install failed"
		}
		BUILD_DIR=python python_foreach_impl installation

		if use examples ; then
			insinto /usr/share/doc/${PF}/examples-py
			doins -r python/demo/*
		fi
	fi

	if use ruby ; then
		dodir "${SITERUBY}"
		emake -C ruby ${MAKE_RULES} ${MAKE_RULES_RB} install || die "emake rb install failed"

		if use examples ; then
			insinto /usr/share/doc/${PF}/examples-rb
			doins -r ruby/demo/*
		fi
	fi

	if use mono ; then
		emake -C csharp ${MAKE_RULES} ${MAKE_RULES_CS} install || die "emake csharp install failed"

		# TODO: anyone has an idea what those are for?
		rm "${ED}"/usr/bin/*.xml

		if use examples ; then
			insinto /usr/share/doc/${PF}/examples-cs
			doins -r csharp/demo/*
		fi
	fi
}

run_tests() {
	# Run tests through the script interface since Python test runner
	# fails to exit with non-zero code for some reason.

	pushd "${1}" >/dev/null || die
	./allTests.py --script | sh
	ret=${?}
	popd >/dev/null || die

	return ${ret}
}

src_test() {
	run_tests cpp || die "emake cpp test failed"

	if use python ; then
		testing() {
			# tests require that the directory is named 'py'
			ln -f -s ../"${BUILD_DIR}"/python python/python || die
			run_tests python || die "emake py-${EPYTHON} test failed"
		}
		BUILD_DIR=python python_foreach_impl testing
	fi

	if use ruby ; then
		run_tests ruby || die "emake rb test failed"
	fi

	if use mono ; then
		# skip mono tests, bug #498484
		ewarn "Tests for C# are currently disabled."
		#run_tests csharp || die "emake csharp test failed"
	fi
}
