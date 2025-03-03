SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help

DOCKERCMD=$(shell which docker)
SWAGGER_VERSION=v0.25.0
SWAGGER := $(DOCKERCMD) run --rm -it -v $(HOME):$(HOME) -w $(shell pwd) quay.io/goswagger/swagger:$(SWAGGER_VERSION)

ifeq ($(VERSION),)
VERSION := v2.4.0
endif

HARBOR_ASSIST_SPEC=api/swagger.yaml
HARBOR_CLIENT_ASSIST_DIR=pkg/sdk/assist
HARBOR_ASSIST_SPEC_URL=https://raw.githubusercontent.com/goharbor/harbor/$(VERSION)/api/swagger.yaml

HARBOR_2.0_SPEC=api/v2.0/swagger.yaml
HARBOR_CLIENT_2.0_DIR=pkg/sdk/v2.0
HARBOR_2.0_SPEC_URL=https://raw.githubusercontent.com/goharbor/harbor/$(VERSION)/api/v2.0/swagger.yaml

HARBOR_2.0_LEGACY_SPEC=api/v2.0/legacy_swagger.yaml
HARBOR_CLIENT_2.0_LEGACY_DIR=pkg/sdk/v2.0/legacy
HARBOR_2.0_LEGACY_SPEC_URL=https://raw.githubusercontent.com/goharbor/harbor/$(VERSION)/api/v2.0/legacy_swagger.yaml

## --------------------------------------
## Help
## --------------------------------------

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

## --------------------------------------
## Client
## --------------------------------------

.PHONY: update-spec
update-spec: ## update all swagger spec files
	@echo "Downloading spec from Harbor with version: $(VERSION)"
	@wget ${HARBOR_ASSIST_SPEC_URL} -O ${HARBOR_ASSIST_SPEC}
	@wget ${HARBOR_2.0_SPEC_URL} -O ${HARBOR_2.0_SPEC}
	@wget ${HARBOR_2.0_LEGACY_SPEC_URL} -O ${HARBOR_2.0_LEGACY_SPEC}

.PHONY: gen-harbor-api
gen-harbor-api: update-spec ## generate goswagger client for harbor
	@$(SWAGGER) generate client -f ${HARBOR_ASSIST_SPEC} --target=$(HARBOR_CLIENT_ASSIST_DIR) --template=stratoscale --additional-initialism=CVE --additional-initialism=GC --additional-initialism=OIDC
	@$(SWAGGER) generate client -f ${HARBOR_2.0_SPEC} --target=$(HARBOR_CLIENT_2.0_DIR) --template=stratoscale --additional-initialism=CVE --additional-initialism=GC --additional-initialism=OIDC
	@$(SWAGGER) generate client -f ${HARBOR_2.0_LEGACY_SPEC} --target=$(HARBOR_CLIENT_2.0_LEGACY_DIR) --template=stratoscale --additional-initialism=CVE --additional-initialism=GC --additional-initialism=OIDC

.PHONY: test
test: ## run the test
	go test ./...

all: gen-harbor-api
