#!/bin/sh

# Launcher script for Adaptec Storage Manager GUI

# Simplified for Gentoo usage from original Adaptec's StorMan.sh script


INSTDIR=/opt/StorMan

LD_LIBRARY_PATH=$INSTDIR:$LD_LIBRARY_PATH
LD_PRELOAD=%LIBDIR%/libstdc++.so.5
export LD_LIBRARY_PATH LD_PRELOAD

cd $INSTDIR

java -cp $INSTDIR/RaidMan.jar com.ibm.sysmgt.raidmgr.mgtGUI.Launch $* 
