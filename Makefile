
.PHONY: build-local

build-local:
	docker build --pull --force-rm=true --tag tj3:local .

