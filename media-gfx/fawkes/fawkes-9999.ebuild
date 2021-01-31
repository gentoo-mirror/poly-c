# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id: 2184a1651c3e4166cba1197b4d935e8547b261e5 $

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Image Cloaking for Personal Privacy"
HOMEPAGE="http://sandlab.cs.uchicago.edu/fawkes/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Shawn-Shan/fawkes.git"
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="BSD-3"
SLOT="0"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
