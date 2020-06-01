#
# Makefile for the docker images
#
# (c) 2017-2020 Roozbeh Farahbod
#

REGISTRY?=theroozbeh

# --- Load image name and version
IMAGE_NAME=$(shell grep IMAGE MANIFEST | cut -d '=' -f2)
VERSION=$(shell grep VERSION MANIFEST | cut -d '=' -f2)

OS=$(shell uname)
CMD_XARGS=xargs
ifeq "$(OS)" "Linux"
	CMD_XARGS=xargs -r
endif

# --- Capturing REMOTE vs LOCAL runs (will be removed once we have the CI in place)
TAG_LOCAL=local
TAG_REMOTE=$(VERSION)

CONFIG=
REMOTE ?= no

ifeq "$(REMOTE)" "yes"
	PUSH_CONFIRM=$(CONFIRM)
	TAG=$(TAG_REMOTE)
	FULL_IMAGE_NAME=$(REGISTRY)/$(IMAGE_NAME)
else
	PUSH_CONFIRM=no
	TAG=$(TAG_LOCAL)
	FULL_IMAGE_NAME=$(IMAGE_NAME)
endif


# --- Common Targets

# make sure the targets do not refer to files or folders
.PHONY: report start stop destroy package test push

# make sure the targets are executed sequentially
.NOTPARALLEL:

# report the current settings
info:
	@echo Image name: $(IMAGE_NAME)
	@echo Version: $(VERSION)

# start the instance
start:
	@echo Nothing to start.

# stop instances
stop:
	docker ps -a -q --filter ancestor=$(FULL_IMAGE_NAME) | $(CMD_XARGS) docker stop

# stop and remove instances
destroy: stop
	docker ps -a -q --filter ancestor=$(FULL_IMAGE_NAME) | $(CMD_XARGS) docker rm

# builds a docker image
package: destroy
	docker build --pull --force-rm --tag $(IMAGE_NAME)\:$(TAG) .

test:
	@echo Nothing to test.

push: package
ifeq "$(PUSH_CONFIRM)" "yes"
	docker tag $(IMAGE_NAME)\:$(TAG) $(FULL_IMAGE_NAME)\:$(TAG)
	docker tag $(IMAGE_NAME)\:$(TAG) $(FULL_IMAGE_NAME)\:latest
	docker push $(FULL_IMAGE_NAME)\:$(TAG)
	docker push $(FULL_IMAGE_NAME)\:latest
else
	@echo
	@echo "!! SKIPPED. Use 'make push REMOTE=yes CONFIRM=yes'."
endif
