# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# @ECLASS: db-use-r1.eclass
# @MAINTAINER:
# Lars Wendler (polynomial-c@gentoo.org)
# @AUTHOR:
# Author: Lars Wendler (polynomial-c@gentoo.org)
# Based on db-use.eclass with code and ideas taken from the python-r1 eclass
# series.
# @BLURB: Functions for packages using Berkeley DB (sys-libs/db)
# @DESCRIPTION:
# An eclass to provide functions for packages using Berkeley DB (sys-libs/db) 
# to determine the best available version of DB.
# This is a common location for functions that aid the use of sys-libs/db
#
# This eclass does not set any metadata variables nor export any phase
# functions. It can be inherited safely.

# we need EAPI >= 2 because we use USE dependencies
case ${EAPI:-0} in
	0|1)
		die "Unsupported EAPI=${EAPI} (too old) for db-use-r1.eclass"
	;;
	2|3|4|5)
		:;
	;;
	*)
		die "Unknown EAPI=${EAPI} for db-use-r1.eclass"
	;;
esac

# @ECLASS_VARIABLE: DB_VERSIONS
# @REQUIRED
# @DESCRIPTION:
# This variable contains a list of sys-libs/db SLOT versions the package 
# works with. Please always sort the list so that higher slot versions come
# first or else the package might not depend on the latest possible version of
# sys-libs/db
#
# Example:
# @CODE
# DB_VERSIONS=( 5.0 4.8 )
# inherit db-use-r1
# @CODE
#
# Please note that you can also use bash brace expansion if you like:
# @CODE
# DB_VERSIONS=( 5.{3,2,1,0} 4.8 )
# inherit db-use-r1
# @CODE
if ! declare -p DB_VERSIONS &>/dev/null ; then
	die "DB_VERSIONS not declared."
elif [[ $(declare -p DB_VERSIONS) != "declare -a"* ]] ; then
	die "DB_VERSIONS must be an array."
fi

# @ECLASS_VARIABLE: DB_USEDEPS
# @OPTIONAL
# @DESCRIPTION:
# This variable contains a comma-separated list of USE flags sys-libs/db 
# should have (un)set.
#
# Example:
# @CODE
# DB_USEDEPS="cxx,-java,tcl"
# inherit db-use-r1
# @CODE
if declare -p DB_USEDEPS &>/dev/null ; then
	db_usedeps="[${DB_USEDEPS}]"
else
	db_usedeps=""
fi

# @ECLASS-VARIABLE: DB_DEPEND
# @DESCRIPTION:
# This eclass sets and exports DB_DEPS which should be uses as follows:
#
# @CODE
# RDEPEND="${DB_DEPEND}"
# @CODE
#
# or
#
# @CODE
# RDEPEND="berkdb? ( ${DB_DEPEND} )"
# @CODE
DB_DEPEND=""
if [ "${#DB_VERSIONS[@]}" -gt 1 ] ; then
	DB_DEPEND="|| ("
fi
for db_slotver in ${DB_VERSIONS[@]} ; do
	DB_DEPEND+=" sys-libs/db:${db_slotver}${db_usedeps}"
done
if [ "${#DB_VERSIONS[@]}" -gt 1 ] ; then
	DB_DEPEND+=" )"
fi
export DB_DEPEND
[[ ! -n ${DB_DEPEND} ]] && die "Cannot assing sys-libs/db dependency"


inherit versionator multilib

# @FUNCTION: db_ver_to_slot
# @USAGE: <db-version>
# @DESCRIPTION:
# Convert a version to a db slot. You need to submit at least the first two
# Version components
# This is meant for ebuilds using the real version number of a sys-libs/db
# package. This eclass doesn't use it internally.
db_ver_to_slot() {
	if [ $# -ne 1 ]; then
		eerror "Function db_ver_to_slot needs one argument"
		eerror "args given:"
		for f in $@
		do
			eerror " - \"$@\""
		done
		return 1
	fi
	if [ "$(get_version_component_count $1)" -lt 2 ] ; then
		eerror "db_ver_to_slot function needs at least a version component"
		eerror "count of two."
		die
	fi
	echo "$(get_version_component_range 1-2 $1)"
}

# @FUNCTION: db_findver
# @USAGE: 
# @DESCRIPTION:
# Find the highest installed db version that fits DB_VERSIONS
db_findver() {
	local db_slotver
	for db_slotver in ${DB_VERSIONS[@]} ; do
		if has_version sys-libs/db:${db_slotver} \
			&& [ -d "/usr/include/db${db_slotver}" ] ; then
				printf "${db_slotver}"
				return 0
		fi
	done
	return 1
}

# @FUNCTION: db_includedir
# @USAGE: 
# @DESCRIPTION:
# Get the include dir for berkeley db. This function returns the best version
# found by db_findver()
db_includedir() {
	local VER="$(db_findver)" || return 1
	#einfo "berkdb: include version ${VER}"
	if [ -d "/usr/include/db${VER}" ]; then
		printf "/usr/include/db${VER}"
		return 0
	else
		eerror "sys-libs/db package requested, but headers not found" >&2
		return 1
	fi
}

# @FUNCTION: db_libname
# @USAGE: 
# @DESCRIPTION:
# Get the library name for berkeley db. Something like "db-4.2" will be the
# outcome. This function returns the best version found by db_findver()
db_libname() {
	local VER="$(db_findver)" || return 1
	if [ -e "/usr/$(get_libdir)/libdb-${VER}.so" ]; then
		printf "db-${VER}"
		return 0
	else
		eerror "sys-libs/db package requested, but library not found" >&2
		return 1
	fi
}
