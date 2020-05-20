#!/usr/bin/make -f

ifeq ($(MAKECMDGOALS),)
	.DEFAULT_GOAL=$(basename $(notdir $(firstword $(MAKEFILE_LIST))))
else
	.DEFAULT_GOAL=$(basename $(firstword $(MAKECMDGOALS)))
endif
$(info .DEFAULT_GOAL=$(.DEFAULT_GOAL))
SHELL=/bin/bash
.ONESHELL:

###################################################

.PHONY: help
help:
	@echo openconnect.mk install

.PHONY: install
install:
	cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/openconnect-connect 
	cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/openconnect-conf

#------------------------------------------------------------------------
.PHONY: openconnect-connect connect
openconnect-connect: connect
connect:
	@
	if [ -e /etc/openconnect.conf ]; then source /etc/openconnect.conf; fi
	if [ -e /usr/local/etc/openconnect.conf ]; then source /usr/local/etc/openconnect.conf; fi
	echo Reading ~/.openconnect.conf
	if [ -e ~/.openconnect.conf ]; then source ~/.openconnect.conf; fi
	if [ -z $${OPENCONNECT_PASSWD} ]; then echo OPENCONNECT_PASSWD is missing.; exit 1; fi
	if [ -z $${OPENCONNECT_USER} ]; then echo OPENCONNECT_USER is missing.; exit 1; fi
	if [ -x $${OPENCONNECT_SERVER} ]; then echo OPENCONNECT_SERVER is missing.; exit 1; fi
	echo -n $${OPENCONNECT_PASSWD} | openconnect -v --passwd-on-stdin --user=$${OPENCONNECT_USER} $${OPENCONNECT_SERVER} --authgroup=ssl 

#------------------------------------------------------------------------
.PHONY: openconnect-conf conf
openconnect-conf: conf
conf: ~/.openconnect.conf
~/.openconnect.conf: 
	@
	if [ -e $@ ]; then cat $@; exit 0; fi
	echo Creating template comfig file $@
	echo OPENCONNECT_USER= >>$@
	echo OPENCONNECT_SERVER= >>$@
	echo OPENCONNECT_PASSWD= >>$@

