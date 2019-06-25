# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: e33e289397a2387600cd99493a6fefa6ed148bd5 $

EAPI=7

inherit acct-user

DESCRIPTION="File Transfer Protocol server user"
ACCT_USER_ID=21
ACCT_USER_HOME=/var/ftp
ACCT_USER_HOME_OWNER=root:ftp
ACCT_USER_GROUPS=( ftp )

acct-user_add_deps
