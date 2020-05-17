#!/usr/bin/make -f

ifeq ($(MAKECMDGOALS),)
	.DEFAULT_GOAL=$(basename $(firstword $(MAKEFILE_LIST)))
else
	.DEFAULT_GOAL=$(basename $(firstword $(MAKECMDGOALS)))
endif
#$(info .DEFAULT_GOAL=$(.DEFAULT_GOAL))
SHELL=/bin/bash
.ONESHELL:

###################################################

.PHONY: apt-get-update help openconnect-connect

help:
	@echo openconnect.mk install

install: /usr/local/bin/openconnect-connect

/usr/local/lib/openconnect.mk: $(firstword $(MAKEFILE_LIST))
	@cp $< $@

/usr/local/bin/openconnect-connect: /usr/local/lib/openconnect.mk
	@ln -sf $< $@; chmod +x $@

openconnect-connect: connect

connect:
	@
	if [ -e /etc/openconnect.conf ]; then source /etc/openconnect.conf; fi
	if [ -e /usr/local/etc/openconnect.conf ]; then source /usr/local/etc/openconnect.conf; fi
	if [ -e ~/.openconnect.conf ]; then source ~/.openconnect.conf; fi
	if [ -z $${OPENCONNECT_PASSWD} ]; then echo OPENCONNECT_PASSWD is missing.; exit 1; fi
	if [ -z $${OPENCONNECT_USER} ]; then echo OPENCONNECT_USER is missing.; exit 1; fi
	if [ -x $${OPENCONNECT_SERVER} ]; then echo OPENCONNECT_SERVER is missing.; exit 1; fi
	echo -n $${OPENCONNECT_PASSWD} | openconnect -v --passwd-on-stdin --user=$${OPENCONNECT_USER} $${OPENCONNECT_SERVER} --authgroup=ssl 

