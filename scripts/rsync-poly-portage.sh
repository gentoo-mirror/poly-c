#!/bin/bash

##    This script is DEPRECTAED! Use app-portage/layman instead    ##
## (layman -o http://polynomial-c.homelinux.net/layman-poly-c.xml) ##

NICE="/usr/bin/nice -n"
NICE_VALUE="15"
RSYNC="/usr/bin/rsync"
OPTS="-v --stats --progress --recursive --links --perms --times --devices --delete --delete-after --force --compress --timeout=60"
SRC="rsync://gentoofan.no-ip.org/poly-c"
## Please set DST to the directory where the overlay should be stored on your 
## filesystem.
DST=""

get_tree() {
	${NICE} ${NICE_VALUE} ${RSYNC} ${OPTS} ${SRC} ${DST} || return 1
	echo "Used ${SRC} for syncing"
	return 0
	}

get_tree \
    || echo "Error! syncing failed at $(date)" >> ${LOGFILE}

## uncomment the following when you are running the script as root and have "userpriv" 
## in FEATURES of portage
#chown -R root:portage ${DST}

#EOF
