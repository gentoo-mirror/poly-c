#!/bin/sh

# Launcher script for Storage Manager daemon

# Simplified for Gentoo usage from original Adaptec's StorAgnt.sh script


INSTDIR=/opt/StorMan

LD_LIBRARY_PATH=$INSTDIR:$LD_LIBRARY_PATH
LD_PRELOAD=%LIBDIR%/libstdc++.so.5
export LD_LIBRARY_PATH LD_PRELOAD

cd $INSTDIR

java -Djava.compiler=NONE -cp $INSTDIR/RaidMan.jar com.ibm.sysmgt.raidmgr.agent.ManagementAgent $* 
