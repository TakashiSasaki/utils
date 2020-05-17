.PHONY: apt-get-update

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

/usr/bin/man: apt-get-update
	apt-get -y install man

/usr/bin/locate: apt-get-update
	apt-get -y install mlocate
	updatedb

/usr/bin/avahi-browse: apt-get-update
	apt-get -y install avahi-utils

/usr/sbin/sshd: apt-get-update
	apt-get -y install openssh-server

/usr/sbin/sudo: apt-get-update
	apt-get -y install sudo

