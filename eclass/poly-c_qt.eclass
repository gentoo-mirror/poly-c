# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#

inherit poly-c_ebuilds

MY_P=${QT5_MODULE}-everywhere-src-${MY_PV}
SRC_URI="https://download.qt.io/official_releases/qt/${MY_PV%.*}/${MY_PV/_/-}/submodules/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"
QT5_BUILD_DIR="${S}_build"
