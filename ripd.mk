#!/usr/bin/make -f

ifeq ($(MAKECMDGOALS),)
	.DEFAULT_GOAL=$(basename $(notdir $(firstword $(MAKEFILE_LIST))))
else
	.DEFAULT_GOAL=$(basename $(firstword $(MAKECMDGOALS)))
endif
#$(info .DEFAULT_GOAL=$(.DEFAULT_GOAL))
SHELL=/bin/bash
.ONESHELL:

###################################################

.PHONY: help
help:
	@echo ripd.mk [ -B ] install

.PHONY: install
install: /etc/quagga/ripd.conf /etc/quagga/zebra.conf
	sudo apt-get install -y quagga-ripd
	sudo cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/ripd-start
	sudo cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/ripd-restart
	sudo cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/ripd-vtysh
	sudo cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/ripd-vtysh-list
	sudo cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/ripd-show-ip-rip
	sudo cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/ripd-show-ip-rip-status
	sudo cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/ripd-show-ip-prefix-list
	sudo cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/ripd-show-ipv6-prefix-list
	sudo cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/ripd-log
	sudo cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/ripd-syslog

/etc/quagga/ripd.conf: /usr/share/doc/quagga-core/examples/ripd.conf.sample
	sudo cp $< $@
	sudo sed -i -e "s/^!log file ripd.log$$/log file \/var\/log\/ripd.log/" $@

/etc/quagga/zebra.conf: /usr/share/doc/quagga-core/examples/zebra.conf.sample
	sudo cp $< $@
	sudo sed -i -e "s/^!log file zebra.log$$/log file \/var\/log\/zebra.log/" $@

.PHONY: ripd-start
ripd-start: /etc/quagga/ripd.conf /etc/quagga/zebra.conf
	sudo service zebra start
	sudo service ripd start

.PHONY: ripd-restart
ripd-restart:
	sudo service zebra restart
	sudo service ripd restart

.PHONY: ripd-vtysh
ripd-vtysh:
	sudo grep pass /etc/quagga/ripd.conf
	telnet localhost 2602

.PHONY: ripd-show-ip-rip
ripd-show-ip-rip:
	(echo zebra; echo show ip rip; echo quit) | nc localhost 2602

.PHONY: ripd-show-ip-rip-status
ripd-show-ip-rip-status:
	(echo zebra; echo show ip rip status; echo quit) | nc localhost 2602

.PHONY: ripd-vtysh-list
ripd-vtysh-list:
	(echo zebra; echo list; echo quit) | nc localhost 2602

.PHONY: ripd-show-ip-prefix-list
ripd-show-ip-prefix-list:
	(echo zebra; echo show ip prefix-list; echo quit) | nc localhost 2602

.PHONY: ripd-show-ipv6-prefix-list
ripd-show-ipv6-prefix-list:
	(echo zebra; echo show ipv6 prefix-list; echo quit) | nc localhost 2602

.PHONY: ripd-log
ripd-log:
	sudo tail -f /var/log/ripd.log

.PHONY: ripd-syslog
ripd-syslog:
	sudo grep -w ripd /var/log/syslog | tail -f -

