#!/usr/bin/make -f
BASENAME:=$(basename $(notdir $(firstword $(MAKEFILE_LIST))))
SUFFIX:=$(suffix $(notdir $(firstword $(MAKEFILE_LIST))))
ifneq ($(SUFFIX),.mk)
	.DEFAULT_GOAL:=$(BASENAME)
endif
$(info MAKEFILE_LIST=$(MAKEFILE_LIST))
$(info MAKECMDGOALS=$(MAKECMDGOALS))
$(info BASENAME=$(BASENAME))
$(info SUFFIX=$(SUFFIX))
$(info .DEFAULT_GOAL=$(.DEFAULT_GOAL))
SHELL=/bin/bash
.ONESHELL:

###################################################

.PHONY: help
help:
	@echo
	@echo !!! INSTALLATION
	@echo
	@echo "  squashfs.mk [ -B ]  install"
	@echo
	@echo !!! COMMANDS
	@echo
	@echo "  mksquashfs-zlib <file or directory>"
	@echo

.PHONY: install
install:
	cp $(firstword $(MAKEFILE_LIST)) /usr/local/bin/mksquashfs-zstd

#------------------------------------------------------------------------
.PHONY: squashfs-zstd
squashfs-zstd: $(firstword $(MAKECMDGOALS)).squashfs
	[ -e $(MAKECMDGOALS) ]

%.squashfs: %
	mksquashfs $< $@ -comp zstd -Xcompression-level 1

