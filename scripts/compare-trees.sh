#!/bin/bash

PORTDIR="$(portageq envvar PORTDIR)"
OVERLAYDIR="/usr/local/portage"

case $1 in
	-a|aux)
		for mydir in $(find ${OVERLAYDIR} -type d -name files) ; do 
			for fle in $(find ${mydir} -type f) ; do
				test -f ${fle/${OVERLAYDIR}/${PORTDIR}} && colordiff -u ${fle} ${fle/${OVERLAYDIR}/${PORTDIR}} | less -c --tilde
			done
		done
	;;
	-f|full)
		for fle in $(find ${OVERLAYDIR} -type f | egrep -v "Manifest|ChangeLog|package.mask|metadata") ; do
			if [ -f "${fle/${OVERLAYDIR}/${PORTDIR}}" ] ; then
				colordiff -u ${fle} ${fle/${OVERLAYDIR}/${PORTDIR}} | less -c --tilde
			else
				echo "${fle/${OVERLAYDIR}/${PORTDIR}} not found" | less
			fi
		done
	;;
	-h|--help)
		echo "-a|aux	Compare only auxiliary files"
		echo "-f|full	Compare all files in overlay"
		exit 0
	;;
	*)
		for fle in $(find ${OVERLAYDIR} -type f -name "*.ebuild") ; do
			test -f ${fle/${OVERLAYDIR}/${PORTDIR}} && colordiff -u ${fle} ${fle/${OVERLAYDIR}/${PORTDIR}} | less -c --tilde
		done
	;;
esac

exit 0
