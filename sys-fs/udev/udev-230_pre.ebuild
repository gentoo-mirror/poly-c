# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: e480cf769761a56a7e0dc3220872e1c5ae589d1f $

EAPI=6

inherit autotools bash-completion-r1 eutils linux-info multilib multilib-minimal toolchain-funcs udev user versionator poly-c_ebuilds

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/systemd/systemd"
	inherit git-r3
else
	patchset=
	FIXUP_PATCH="${PN}-230-revert-systemd-messup.patch.xz"
	SRC_URI="https://github.com/systemd/systemd/archive/v${MY_PV}.tar.gz -> systemd-${MY_PV}.tar.gz
		https://dev.gentoo.org/~polynomial-c/${PN}/${FIXUP_PATCH}"
	if [[ -n "${patchset}" ]]; then
		SRC_URI+="
			https://dev.gentoo.org/~williamh/dist/${P}-patches-${patchset}.tar.xz
			https://dev.gentoo.org/~ssuominen/${P}-patches-${patchset}.tar.xz"
	fi
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="acl hwdb +kmod selinux static-libs"

RESTRICT="test"

COMMON_DEPEND=">=sys-apps/util-linux-2.27.1[${MULTILIB_USEDEP}]
	sys-libs/libcap[${MULTILIB_USEDEP}]
	acl? ( sys-apps/acl )
	kmod? ( >=sys-apps/kmod-16 )
	selinux? ( >=sys-libs/libselinux-2.1.9 )
	!<sys-libs/glibc-2.11
	!sys-apps/gentoo-systemd-integration
	!sys-apps/systemd
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r7
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

# Try with `emerge -C docbook-xml-dtd` to see the build failure without DTDs
# Force new make >= -r4 to skip some parallel build issues
DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	>=dev-util/intltool-0.50
	>=sys-apps/coreutils-8.16
	virtual/os-headers
	virtual/pkgconfig
	>=sys-devel/make-3.82-r4
	>=sys-kernel/linux-headers-3.9
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt"

RDEPEND="${COMMON_DEPEND}
	!<sys-fs/lvm2-2.02.103
	!<sec-policy/selinux-base-2.20120725-r10"
PDEPEND=">=sys-apps/hwids-20140304[udev]
	>=sys-fs/udev-init-scripts-26"

S=${WORKDIR}/systemd-${MY_PV}

# The multilib-build.eclass doesn't handle situation where the installed headers
# are different in ABIs. In this case, we install libgudev headers in native
# ABI but not for non-native ABI.
multilib_check_headers() { :; }

check_default_rules() {
	# Make sure there are no sudden changes to upstream rules file
	# (more for my own needs than anything else ...)
	local udev_rules_md5=b8ad860dccae0ca51656b33c405ea2ca
	MD5=$(md5sum < "${S}"/rules/50-udev-default.rules)
	MD5=${MD5/  -/}
	if [[ ${MD5} != ${udev_rules_md5} ]]; then
		eerror "50-udev-default.rules has been updated, please validate!"
		eerror "md5sum: ${MD5}"
		die "50-udev-default.rules has been updated, please validate!"
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		CONFIG_CHECK="~BLK_DEV_BSG ~DEVTMPFS ~!IDE ~INOTIFY_USER ~!SYSFS_DEPRECATED ~!SYSFS_DEPRECATED_V2 ~SIGNALFD ~EPOLL ~FHANDLE ~NET ~!FW_LOADER_USER_HELPER"
		linux-info_pkg_setup

		# CONFIG_FHANDLE was introduced by 2.6.39
		local MINKV=2.6.39

		if kernel_is -lt ${MINKV//./ }; then
			eerror "Your running kernel is too old to run this version of ${P}"
			eerror "You need to upgrade kernel at least to ${MINKV}"
		fi

		if kernel_is -lt 3 7; then
			ewarn "Your running kernel is too old to have firmware loader and"
			ewarn "this version of ${P} doesn't have userspace firmware loader"
			ewarn "If you need firmware support, you need to upgrade kernel at least to 3.7"
		fi
	fi
}

src_prepare() {
	if ! [[ ${PV} = 9999* ]]; then
		# secure_getenv() disable for non-glibc systems wrt bug #443030
		if ! [[ $(grep -r secure_getenv * | wc -l) -eq 26 ]]; then
			eerror "The line count for secure_getenv() failed, see bug #443030"
			die
		fi
	fi

	# backport some patches
	if [[ -n "${patchset}" ]]; then
		eapply "${WORKDIR}/patch"
	fi
	#eapply "${FILESDIR}"/${PN}-229-sysmacros.patch #580200

	eapply "${WORKDIR}"/${FIXUP_PATCH/.xz}

	cat <<-EOF > "${T}"/40-gentoo.rules
	# Gentoo specific floppy and usb groups
	ACTION=="add", SUBSYSTEM=="block", KERNEL=="fd[0-9]", GROUP="floppy"
	ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", GROUP="usb"
	EOF

	# change rules back to group uucp instead of dialout for now wrt #454556
	sed -i -e 's/GROUP="dialout"/GROUP="uucp"/' rules/*.rules || die

	# stub out the am_path_libcrypt function
	echo 'AC_DEFUN([AM_PATH_LIBGCRYPT],[:])' > m4/gcrypt.m4

	default

	eautoreconf

	if ! [[ ${PV} = 9999* ]]; then
		check_default_rules
	fi

	# Restore possibility of running --enable-static wrt #472608
	sed -i \
		-e '/--enable-static is not supported by systemd/s:as_fn_error:echo:' \
		configure || die

	if ! use elibc_glibc; then #443030
		echo '#define secure_getenv(x) NULL' >> config.h.in
		sed -i -e '/error.*secure_getenv/s:.*:#define secure_getenv(x) NULL:' src/shared/missing.h || die
	fi
}

src_configure() {
	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB
	multilib-minimal_src_configure
}

multilib_src_configure() {
	tc-export CC #463846
	export cc_cv_CFLAGS__flto=no #502950
	export cc_cv_CFLAGS__Werror_shadow=no #554454
	export cc_cv_LDFLAGS__Wl__fuse_ld_gold=no #573874

	# Keep sorted by ./configure --help and only pass --disable flags
	# when *required* to avoid external deps or unnecessary compile
	local econf_args
	econf_args=(
		--bindir=/bin
		--sbindir=/sbin
		--libdir=/usr/$(get_libdir)
		--docdir=/usr/share/doc/${PF}
		$(multilib_native_use_enable static-libs static)
		--disable-nls
		$(multilib_native_use_enable hwdb)
		--disable-dbus
		$(multilib_native_use_enable kmod)
		--disable-xkbcommon
		--disable-seccomp
		$(multilib_native_use_enable selinux)
		--disable-xz
		--disable-lz4
		--disable-pam
		$(multilib_native_use_enable acl)
		--disable-gcrypt
		--disable-audit
		--disable-libcryptsetup
		--disable-qrencode
		--disable-microhttpd
		--disable-gnuefi
		--disable-gnutls
		--disable-libcurl
		--disable-libidn
		--disable-quotacheck
		--disable-logind
		--disable-polkit
		--disable-myhostname
		$(multilib_is_native_abi || echo "--disable-manpages")
		--enable-split-usr
		--without-python
		--with-bashcompletiondir="$(get_bashcompdir)"
		--with-rootprefix=
		$(multilib_is_native_abi && echo "--with-rootlibdir=/$(get_libdir)")
		--disable-elfutils
	)

	if ! multilib_is_native_abi ; then
		econf_args+=(
			MOUNT_{CFLAGS,LIBS}=' '
		)
	fi

	ECONF_SOURCE="${S}" econf "${econf_args[@]}"
}

multilib_src_compile() {
	echo 'BUILT_SOURCES: $(BUILT_SOURCES)' > "${T}"/Makefile.extra
	emake -f Makefile -f "${T}"/Makefile.extra BUILT_SOURCES

	# Most of the parallel build problems were solved by >=sys-devel/make-3.82-r4,
	# but not everything -- separate building of the binaries as a workaround,
	# which will force internal libraries required for the helpers to be built
	# early enough, like eg. libsystemd-shared.la
	if multilib_is_native_abi; then
		local lib_targets=( libudev.la )
		emake "${lib_targets[@]}"

		local exec_targets=(
			udevd
			udevadm
		)
		use hwdb && exec_targets+=( udev-hwdb ) 
		emake "${exec_targets[@]}"

		local helper_targets=(
			ata_id
			cdrom_id
			collect
			scsi_id
			v4l_id
			mtd_probe
			)
		emake "${helper_targets[@]}"

		local man_targets=(
			$(usex hwdb 'man/systemd-hwdb.8' '')
			man/systemd-udevd.8
			man/udev.conf.5
			man/udev.link.5
			man/udev.7
			man/udevadm.8
			man/udevd.8
		)
		emake "${man_targets[@]}"
	else
		local lib_targets=( libudev.la )
		emake "${lib_targets[@]}"
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		local lib_LTLIBRARIES="libudev.la" \
			pkgconfiglib_DATA="src/libudev/libudev.pc"

		local targets=(
			install-libLTLIBRARIES
			install-includeHEADERS
			install-rootsbinPROGRAMS
			install-rootbinPROGRAMS
			install-rootlibexecPROGRAMS
			install-udevlibexecPROGRAMS
			install-dist_udevconfDATA
			install-dist_udevrulesDATA
			install-man5
			install-man7
			install-man8
			install-pkgconfiglibDATA
			install-pkgconfigdataDATA
			install-dist_docDATA
			libudev-install-hook
			install-directories-hook
			install-dist_bashcompletionDATA
			install-dist_networkDATA
		)

		# add final values of variables:
		targets+=(
			rootlibexec_PROGRAMS=""
			rootbin_PROGRAMS=""
			rootsbin_PROGRAMS="udevd udevadm $(usex hwdb 'udev-hwdb' '')"
			lib_LTLIBRARIES="${lib_LTLIBRARIES}"
			MANPAGES="man/udev.link.5 man/udev.7 man/udevadm.8 man/udevd.8 $(usex hwdb 'man/hwdb.7 man/udev-hwdb.8' '')"
			MANPAGES_ALIAS="man/systemd-udevd.8 $(usex hwdb 'man/systemd-hwdb.8' '')"
			pkgconfiglib_DATA="${pkgconfiglib_DATA}"
			INSTALL_DIRS='$(sysconfdir)/udev/rules.d \
					$(sysconfdir)/udev/hwdb.d \
					$(sysconfdir)/udev/network'
			dist_bashcompletion_DATA="shell-completion/bash/udevadm"
			networkdir=/lib/udev/network
			dist_network_DATA="network/99-default.link"
			pkgconfigdata_DATA="src/udev/udev.pc"
		)
		emake -j1 DESTDIR="${D}" "${targets[@]}"

		# install udevadm compatibility symlink
		dosym {../sbin,bin}/udevadm
	else
		local lib_LTLIBRARIES="libudev.la" \
			pkgconfiglib_DATA="src/libudev/libudev.pc" \
			include_HEADERS="src/libudev/libudev.h"

		local targets=(
			install-libLTLIBRARIES
			install-includeHEADERS
			install-pkgconfiglibDATA
		)

		targets+=(
			lib_LTLIBRARIES="${lib_LTLIBRARIES}"
			pkgconfiglib_DATA="${pkgconfiglib_DATA}"
			include_HEADERS="${include_HEADERS}"
			)
		emake -j1 DESTDIR="${D}" "${targets[@]}"
	fi
}

multilib_src_install_all() {
	dodoc TODO

	prune_libtool_files --all
	rm -f \
		"${D}"/lib/udev/rules.d/99-systemd.rules \
		"${D}"/usr/share/doc/${PF}/{LICENSE.*,GVARIANT-SERIALIZATION,DIFFERENCES,PORTING-DBUS1,sd-shutdown.h}

	# see src_prepare() for content of 40-gentoo.rules
	insinto /lib/udev/rules.d
	doins "${T}"/40-gentoo.rules

	docinto gentoo
	local netrules="80-net-setup-link.rules"
	dodoc "${FILESDIR}"/${netrules}
	docompress -x /usr/share/doc/${PF}/gentoo/${netrules}
}

pkg_postinst() {
	mkdir -p "${ROOT%/}"/run

	local netrules="80-net-setup-link.rules"
	local net_rules="${ROOT%/}"/etc/udev/rules.d/${netrules}
	copy_net_rules() {
		[[ -f ${net_rules} ]] || cp "${ROOT%/}"/usr/share/doc/${PF}/gentoo/${netrules} "${net_rules}"
	}

	if [[ ${REPLACING_VERSIONS} ]] && [[ ${REPLACING_VERSIONS} < 209 ]] ; then
		ewarn "Because this is a upgrade we disable the new predictable network interface"
		ewarn "name scheme by default."
		copy_net_rules
	fi

	if has_version sys-apps/biosdevname; then
		ewarn "Because sys-apps/biosdevname is installed we disable the new predictable"
		ewarn "network interface name scheme by default."
		copy_net_rules
	fi

	# "losetup -f" is confused if there is an empty /dev/loop/, Bug #338766
	# So try to remove it here (will only work if empty).
	rmdir "${ROOT%/}"/dev/loop 2>/dev/null
	if [[ -d ${ROOT%/}/dev/loop ]]; then
		ewarn "Please make sure your remove /dev/loop,"
		ewarn "else losetup may be confused when looking for unused devices."
	fi

	if [ -n "${net_rules}" ]; then
		ewarn
		ewarn "udev-197 and newer introduces a new method of naming network"
		ewarn "interfaces. The new names are a very significant change, so"
		ewarn "they are disabled by default on live systems."
		ewarn "Please see the contents of ${net_rules} for more"
		ewarn "information on this feature."
		ewarn
	fi

	local fstab="${ROOT%/}"/etc/fstab dev path fstype rest
	while read -r dev path fstype rest; do
		if [[ ${path} == /dev && ${fstype} != devtmpfs ]]; then
			ewarn "You need to edit your /dev line in ${fstab} to have devtmpfs"
			ewarn "filesystem. Otherwise udev won't be able to boot."
			ewarn "See, https://bugs.gentoo.org/453186"
		fi
	done < "${fstab}"

	if [[ -d ${ROOT%/}/usr/lib/udev ]]; then
		ewarn
		ewarn "Please re-emerge all packages on your system which install"
		ewarn "rules and helpers in /usr/lib/udev. They should now be in"
		ewarn "/lib/udev."
		ewarn
		ewarn "One way to do this is to run the following command:"
		ewarn "emerge -1av \$(qfile -CSq /usr/lib/udev | xargs)"
		ewarn "Note that qfile can be found in app-portage/portage-utils"
	fi

	local old_cd_rules="${ROOT%/}"/etc/udev/rules.d/70-persistent-cd.rules
	local old_net_rules="${ROOT%/}"/etc/udev/rules.d/70-persistent-net.rules
	for old_rules in "${old_cd_rules}" "${old_net_rules}"; do
		if [[ -f ${old_rules} ]]; then
			ewarn
			ewarn "File ${old_rules} is from old udev installation but if you still use it,"
			ewarn "rename it to something else starting with 70- to silence this deprecation"
			ewarn "warning."
		fi
	done

	if has_version 'sys-apps/biosdevname'; then
		ewarn
		ewarn "You can replace the functionality of sys-apps/biosdevname which has been"
		ewarn "detected to be installed with the new predictable network interface names."
	fi

	ewarn
	ewarn "You need to restart udev as soon as possible to make the upgrade go"
	ewarn "into effect."
	ewarn "The method you use to do this depends on your init system."
	if has_version 'sys-apps/openrc'; then
		ewarn "For sys-apps/openrc users it is:"
		ewarn "# /etc/init.d/udev --nodeps restart"
	fi

	elog
	elog "For more information on udev on Gentoo, upgrading, writing udev rules, and"
	elog "fixing known issues visit:"
	elog "https://wiki.gentoo.org/wiki/Udev"
	elog "https://wiki.gentoo.org/wiki/Udev/upgrade"

	
	# http://cgit.freedesktop.org/systemd/systemd/commit/rules/50-udev-default.rules?id=3dff3e00e044e2d53c76fa842b9a4759d4a50e69
	# https://bugs.gentoo.org/246847
	# https://bugs.gentoo.org/514174
	enewgroup input

	# Update hwdb database in case the format is changed by udev version.
	if use hwdb && has_version 'sys-apps/hwids[udev]'; then
		udev-hwdb --root="${ROOT}" update
		# Only reload when we are not upgrading to avoid potential race w/ incompatible hwdb.bin and the running udevd
		# http://cgit.freedesktop.org/systemd/systemd/commit/?id=1fab57c209035f7e66198343074e9cee06718bda
		[[ -z ${REPLACING_VERSIONS} ]] && udev_reload
	fi
}
