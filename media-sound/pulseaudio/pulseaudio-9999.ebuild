# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 flag-o-matic gnome2-utils linux-info meson multilib-minimal systemd udev

DESCRIPTION="A networked sound server with an advanced plugin system"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/PulseAudio/"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git"
else
	SRC_URI=""
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
fi

# libpulse-simple and libpulse link to libpulse-core; this is daemon's
# library and can link to gdbm and other GPL-only libraries. In this
# cases, we have a fully GPL-2 package. Leaving the rest of the
# GPL-forcing USE flags for those who use them.
LICENSE="!gdbm? ( LGPL-2.1 ) gdbm? ( GPL-2 )"
SLOT="0"

# +alsa-plugin as discussed in bug #519530
IUSE="+alsa +alsa-plugin +asyncns bluetooth +caps dbus doc elogind equalizer gconf +gdbm
+glib gstreamer gtk ipv6 jack libsamplerate libressl lirc native-headset neon ofono-headset
+orc oss qt5 realtime selinux sox ssl systemd system-wide tcpd test +udev
+webrtc-aec +X zeroconf"

REQUIRED_USE="
	?? ( elogind systemd )
	bluetooth? ( dbus )
	equalizer? ( dbus )
	ofono-headset? ( bluetooth )
	native-headset? ( bluetooth )
	realtime? ( dbus )
	udev? ( || ( alsa oss ) )
"

# libpcre needed in some cases, bug #472228
RDEPEND="
	|| (
		elibc_glibc? ( virtual/libc )
		elibc_uclibc? ( virtual/libc )
		dev-libs/libpcre
	)
	>=media-libs/libsndfile-1.0.20[${MULTILIB_USEDEP}]
	X? (
		>=x11-libs/libX11-1.4.0[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.6[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libICE[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
	)
	caps? ( >=sys-libs/libcap-2.22-r2[${MULTILIB_USEDEP}] )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.1-r1 )
	alsa? ( >=media-libs/alsa-lib-1.0.19 )
	glib? ( >=dev-libs/glib-2.26.0:2[${MULTILIB_USEDEP}] )
	zeroconf? ( >=net-dns/avahi-0.6.12[dbus] )
	jack? ( virtual/jack )
	tcpd? ( sys-apps/tcp-wrappers[${MULTILIB_USEDEP}] )
	lirc? ( app-misc/lirc )
	dbus? ( >=sys-apps/dbus-1.0.0[${MULTILIB_USEDEP}] )
	gstreamer? (
		>=media-libs/gstreamer-1.14.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-base-1.14.0[${MULTILIB_USEDEP}]
	)
	gtk? ( x11-libs/gtk+:3 )
	bluetooth? (
		>=net-wireless/bluez-5
		>=sys-apps/dbus-1.0.0
		media-libs/sbc
	)
	asyncns? ( net-libs/libasyncns[${MULTILIB_USEDEP}] )
	udev? ( >=virtual/udev-143[hwdb(+)] )
	equalizer? ( sci-libs/fftw:3.0 )
	ofono-headset? ( >=net-misc/ofono-1.13 )
	orc? ( >=dev-lang/orc-0.4.15 )
	sox? ( >=media-libs/soxr-0.1.1 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	media-libs/speexdsp
	gdbm? ( sys-libs/gdbm:= )
	webrtc-aec? ( >=media-libs/webrtc-audio-processing-0.2 )
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd:0=[${MULTILIB_USEDEP}] )
	dev-libs/libltdl:0
	selinux? ( sec-policy/selinux-pulseaudio )
	realtime? ( sys-auth/rtkit )
	gconf? ( >=gnome-base/gconf-3.2.6 )
"

DEPEND="${RDEPEND}
	X? (
		x11-base/xorg-proto
		>=x11-libs/libXtst-1.0.99.2[${MULTILIB_USEDEP}]
	)
	dev-libs/libatomic_ops
"
# This is a PDEPEND to avoid a circular dep
PDEPEND="
	alsa? ( alsa-plugin? ( >=media-plugins/alsa-plugins-1.0.27-r1[pulseaudio,${MULTILIB_USEDEP}] ) )
"

# alsa-utils dep is for the alsasound init.d script (see bug #155707)
# bluez dep is for the bluetooth init.d script
# PyQt5 dep is for the qpaeq script
RDEPEND="${RDEPEND}
	equalizer? ( qt5? ( dev-python/PyQt5[dbus,widgets] ) )
	system-wide? (
		alsa? ( media-sound/alsa-utils )
		bluetooth? ( >=net-wireless/bluez-5 )
		acct-user/pulse
		acct-group/pulse-access
	)
	acct-group/audio
"

BDEPEND="
	doc? ( app-doc/doxygen )
	system-wide? ( dev-util/unifdef )
	test? ( >=dev-libs/check-0.9.10 )
	sys-devel/gettext
	sys-devel/m4
	virtual/pkgconfig
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/pulse/error.h
	/usr/include/pulse/rtclock.h
	/usr/include/pulse/direction.h
	/usr/include/pulse/cdecl.h
	/usr/include/pulse/thread-mainloop.h
	/usr/include/pulse/context.h
	/usr/include/pulse/format.h
	/usr/include/pulse/sample.h
	/usr/include/pulse/channelmap.h
	/usr/include/pulse/utf8.h
	/usr/include/pulse/glib-mainloop.h
	/usr/include/pulse/util.h
	/usr/include/pulse/volume.h
	/usr/include/pulse/proplist.h
	/usr/include/pulse/operation.h
	/usr/include/pulse/version.h
	/usr/include/pulse/mainloop-signal.h
	/usr/include/pulse/timeval.h
	/usr/include/pulse/subscribe.h
	/usr/include/pulse/xmalloc.h
	/usr/include/pulse/ext-device-restore.h
	/usr/include/pulse/ext-stream-restore.h
	/usr/include/pulse/stream.h
	/usr/include/pulse/def.h
	/usr/include/pulse/ext-device-manager.h
	/usr/include/pulse/introspect.h
	/usr/include/pulse/gccmacro.h
	/usr/include/pulse/mainloop.h
	/usr/include/pulse/scache.h
	/usr/include/pulse/simple.h
	/usr/include/pulse/mainloop-api.h
	/usr/include/pulse/message-params.h
	/usr/include/pulse/pulseaudio.h
)

pkg_pretend() {
	CONFIG_CHECK="~HIGH_RES_TIMERS"
	WARNING_HIGH_RES_TIMERS="CONFIG_HIGH_RES_TIMERS:\tis not set (required for enabling timer-based scheduling in pulseaudio)\n"
	check_extra_config

	if linux_config_exists; then
		local snd_hda_prealloc_size=$(linux_chkconfig_string SND_HDA_PREALLOC_SIZE)
		if [ -n "${snd_hda_prealloc_size}" ] && [ "${snd_hda_prealloc_size}" -lt 2048 ]; then
			ewarn "A preallocated buffer-size of 2048 (kB) or higher is recommended for the HD-audio driver!"
			ewarn "CONFIG_SND_HDA_PREALLOC_SIZE=${snd_hda_prealloc_size}"
		fi
	fi
}

pkg_setup() {
	linux-info_pkg_setup
	gnome2_environment_reset #543364
}

multilib_src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}"/var

		-Ddatabase="$(multilib_native_usex gdbm gdbm simple)"
		-Dlegacy-database-entry-format=false
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		-Dudevrulesdir="${EPREFIX}/$(get_udevdir)/rules.d"
		-Dbashcompletiondir="$(get_bashcompdir)"

		-Dalsa="$(multilib_native_usex alsa enabled disabled)"
		-Dasyncns="$(usex asyncns enabled disabled)"
		-Davahi="$(multilib_native_usex zeroconf enabled disabled)"
		-Dbluez5="$(multilib_native_usex bluetooth true false)"
		-Dbluez5-gstreamer="$(multilib_native_usex bluetooth $(usex gstreamer enabled disabled) disabled)"
		-Ddbus="$(usex dbus enabled disabled)"
		-Dfftw="$(multilib_native_usex equalizer enabled disabled)"
		-Dglib="$(usex glib enabled disabled)"
		-Dgsettings="$(multilib_native_usex glib enabled disabled)"
		-Dgstreamer="$(usex gstreamer enabled disabled)"
		-Dgtk="$(multilib_native_usex gtk enabled disabled)"
		-Dhal-compat=false
		-Dipv6="$(usex ipv6 true false)"
		-Djack="$(multilib_native_usex jack enabled disabled)"
		-Dlirc="$(multilib_native_usex lirc enabled disabled)"
		-Dopenssl="$(multilib_native_usex ssl enabled disabled)"
		-Dsamplerate="$(multilib_native_usex libsamplerate enabled disabled)"
		-Dsoxr="$(multilib_native_usex sox enabled disabled)"
		-Dspeex=enabled
		-Dsystemd="$(usex systemd enabled disabled)"
		-Dudev="$(multilib_native_usex udev enabled disabled)"
		-Dx11="$(usex X enabled disabled)"

		-Dadrian-aec=false
		-Dwebrtc-aec="$(multilib_native_usex webrtc-aec enabled disabled)"
	)

	if use bluetooth ; then
		emesonargs+=(
			-Dbluez5-native-headset="$(multilib_native_usex native-headset true false)"
			-Dbluez5-ofono-headset="$(multilib_native_usex ofono-headset true false)"
		)
	fi

	if multilib_is_native_abi ; then
		emesonargs+=(
			-Dpulsedspdir="${EPREFIX}/usr/$(get_libdir)/pulseaudio"
		)
	fi
	meson_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi ; then
		meson_src_compile
	#else
	#	local targets=(
	#		src/pulse/libpulse
	#		src/pulse/libpulsedsp
	#		src/pulse/libpulse_simple
	#		$(usex glib 'src/pulse/libpulse_mainloop_glib' '')
	#	)
	#	eninja "${targets[@]}"
	fi
}

multilib_src_install() {
	if multilib_is_native_abi ; then
		meson_src_install
	#else
	#	local targets=(
	#		src/pulse/libpulse
	#		src/pulse/libpulsedsp
	#		src/pulse/libpulse_simple
	#		$(usex glib 'src/pulse/libpulse_mainloop_glib' '')
	#		src/pulse/libpulse_headers
	#		pc_files
	#	)
	#	eninja "${targets[@]}" install
	fi
}

multilib_src_install_all() {
	if use system-wide ; then
		newconfd "${FILESDIR}/pulseaudio.conf.d" pulseaudio

		use_define() {
			local define=${2:-$(echo $1 | tr '[:lower:]' '[:upper:]')}
			use "$1" && echo "-D$define" || echo "-U$define"
		}

		unifdef $(use_define zeroconf AVAHI) \
			$(use_define alsa) \
			$(use_define bluetooth) \
			$(use_define udev) \
			"${FILESDIR}/pulseaudio.init.d-5" \
			> "${T}/pulseaudio"

		doinitd "${T}/pulseaudio"

		systemd_dounit "${FILESDIR}/${PN}.service"

		# We need /var/run/pulse, bug #442852
		systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles" "${PN}.conf"
	fi

	if use zeroconf ; then
		sed -e '/module-zeroconf-publish/s:^#::' \
			-i "${ED}/etc/pulse/default.pa" || die
	fi

	dodoc NEWS README todo

	# Create the state directory
	use prefix || diropts -o pulse -g pulse -m0755
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
