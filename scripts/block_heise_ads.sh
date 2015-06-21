#!/bin/bash

# A script to block ADs which are too annoying and intrusive to accept while 
# surfing the net. The intention is to keep www.heise.de as AD-free as possible.
# Feel free to enhance the script for your needs as much as you want.


IPT="/sbin/iptables"
[[ -x "${IPT}" ]] || exit 1


# If there are IPs missing, just look in the sourcecode of the affected website
# and look for the domainname of the adservers. Then add this domainname to the 
# ADJUNK_HOSTS list or use the "host" program to look for as much IPs that are
# related with the domainnames as possible. Then create a new variable and fill
# it with all IPs. Don't forget to add the variable to the ADJUNK_HOSTS list.

# Many AD corporations have multiple IPs assigned to their domainnames. Here we
# gonna try to catch those:


# doubleclick.net junk. Incorporates the ad.* and ad.de.* sub as well.
DOUBLECLICK_HOSTS="62.225.49.138
	62.225.49.146
	65.205.8.52
	65.205.8.94
	209.62.176.94
	209.62.176.152
	209.62.177.51
	209.62.177.57
	209.62.177.181
	216.73.86.52
	216.73.86.94
	216.73.86.152
	216.73.87.52
	216.73.87.94
	216.73.87.152"

# atdmt.com junk. Incorporates clk.* and view.* subs as well.
ATDMT_HOSTS="12.130.60.2
	65.203.229.40
	194.129.79.7
	206.16.21.31
	206.16.21.66
	209.67.78.8
	216.74.132.11
	217.237.150.33"

# ligatus.de junk. Incorporates a.* and r.* subs as well
# The most intrusive ad-junk assholes I have found so far. They seem to have a
# massive amount of IP addresses...
LIGATUS_HOSTS="62.225.49.138
	62.225.49.146
	80.231.19.110
	80.231.19.119
	80.237.198.201
	80.237.198.205
	193.45.14.169
	193.45.14.174
	193.159.189.201
	193.159.189.214
	195.27.249.78 
	195.27.249.80
	195.50.169.72
	195.50.169.89
	212.23.33.5
	212.23.33.16
	212.23.33.29
	212.23.33.32
	212.23.37.5
	212.23.37.13
	213.200.97.136
	213.200.97.158
	217.6.176.18
	217.6.176.26"

# serving-sys.com junk. Incorporates bs.* and ds.* subs as well.
SERVINGSYS_HOSTS="80.252.91.41
	80.252.91.46
	193.45.14.159
	193.45.14.177"

# googlesyndication.com junk. Mainly pagead*.* subs.
GOOGLESYNDICATION_HOSTS="216.239.59.164
	216.239.59.165
	216.239.59.166
	216.239.59.167"

# localhosts sections which works as a fallback for all those
# ad-junk domains with multiple IP addresses.
# Put them into /etc/hosts and let them point to a 127.0.0.x IP, where
# x must be >= 2.
# WARNING! NEVER EVER set the starting number for seq to 1! This would block
# the valid localhost address 127.0.0.1 which can harm your system.
#LOCAL_HOSTS="$(for num in `seq 2 5` ; do echo 127.0.0.${num} ; done)"


ADJUNK_HOSTS="${DOUBLECLICK_HOSTS}
	oas.wwwheise.de
	${ATDMT_HOSTS}
	${LIGATUS_HOSTS}
	ads.newtention.net
	ads.planetactive.com
	mvc.mediavantage.de
	austria1.adverserve.net
	${SERVINGSYS_HOSTS}
	adserv.quality-channel.de
	${GOOGLESYNDICATION_HOSTS}"


# First, flush all rules so we don't set the same rules multiple times.
${IPT} -F

for adhost in ${ADJUNK_HOSTS} ; do
	#echo ${myhost}
	${IPT} -A OUTPUT -d ${adhost} -j REJECT
	${IPT} -A INPUT -s ${adhost} -j REJECT
done
