#!/usr/bin/make -f
.ONESHELL:
DEFAULT_GOAL=$(basename $(firstword $(MAKECMDGOALS)))
$(info DEFAULT_GOAL=$(DEFAULT_GOAL))
SHELL=/bin/bash
.PHONY: apt-get-update help openconnect-connect

help:
	@echo openconnect.mk install

apt-get-update:
	apt-get update

/usr/bin/git: apt-get-update
	apt-get -y install git 

/usr/bin/apt-file: apt-get-udpate
	apt-get -y install apt-file
	apt-file update

/bin/ps: apt-get-update
	apt-get -y install procps

/usr/bin/tmux: apt-get-update
	apt-get -y install tmux

/usr/sbin/ripd: apt-get-update
	apt-get -y install quagga-ripd

/usr/sbin/openconnect: apt-get-update
	apt-get -y install openconnect

/usr/bin/man:
	apt-get -y install man

/usr/bin/locate:
	apt-get -y install mlocate
	updatedb

/usr/bin/avahi-browse:
	apt-get -y install avahi-utils

/usr/sbin/sshd:
	apt-get -y install openssh-server

/usr/sbin/sudo:
	apt-get -y install sudo

install: /usr/local/bin/openconnect-connect

/usr/local/lib/openconnect.mk: $(firstword $(MAKEFILE_LIST))
	@cp $< $@

/usr/local/bin/openconnect-connect: /usr/local/lib/openconnect.mk
	-@ln -sf $< $@; chmod +x $@

openconnect-connect:
	@
	if [ -e /etc/openconnect.conf ]; then source /etc/openconnect.conf; fi
	if [ -e /usr/local/etc/openconnect.conf ]; then source /usr/local/etc/openconnect.conf; fi
	if [ -e ~/.openconnect.conf ]; then source ~/.openconnect.conf; fi
	if [ -z $${OPENCONNECT_PASSWD} ]; then echo OPENCONNECT_PASSWD is missing.; exit 1; fi
	if [ -z $${OPENCONNECT_USER} ]; then echo OPENCONNECT_USER is missing.; exit 1; fi
	if [ -x $${OPENCONNECT_SERVER} ]; then echo OPENCONNECT_SERVER is missing.; exit 1; fi
	echo -n $${OPENCONNECT_PASSWD} | openconnect -v --passwd-on-stdin --user=$${OPENCONNECT_USER} $${OPENCONNECT_SERVER} --authgroup=ssl 

