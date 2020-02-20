.ONESHELL:
.SHELL := /bin/bash
.PHONY: apply destroy plan-destroy plan prep
BASE="./roots/$(APP)"
VARS="$(BASE)/env/$(ENV).tfvars"
CURRENT_FOLDER=$(shell basename "$$(pwd)")
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)
WORKSPACE="$(APP)"

help:
	@echo "$(BOLD)help!$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	

set-env:
	@echo "Working with root $(GREEN)$(BASE)$(RESET) env $(GREEN)$(VARS)$(RESET)"
	@if [ -z $(ENV) ]; then \
		echo "$(BOLD)$(RED)ENV was not set$(RESET)"; \
		ERROR=1; \
	fi

	@if [ ! -z $${ERROR} ] && [ $${ERROR} -eq 1 ]; then \
		echo "$(BOLD)Example usage: \`ENV=prod ROOT=roots\app make plan\`$(RESET)"; \
		exit 1; \
	fi

	@if [ ! -f "$(VARS)" ]; then \
		echo "$(BOLD)$(RED)Could not find variables file: $(VARS)$(RESET)"; \
		exit 1; \
	fi


prep: set-env
	@echo "$(BOLD)Configuring terraform $(RESET)"
	@terraform init \
		-upgrade \
		-verify-plugins \
		"$(BASE)"

	@terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE)

plan: prep
	@terraform plan \
			-input=false \
			-refresh=true \
			-var-file="$(VARS)" \
			"$(BASE)"

plan-destroy: prep
	@terraform plan \
			-input=false \
			-refresh=true \
			-destroy \
			-var-file="$(VARS)" \
			"$(BASE)"

apply: prep
	@terraform apply \
			-input=false \
			-refresh=true \
			-var-file="$(VARS)" \
			-auto-approve \
			"$(BASE)"

destroy: prep
	@terraform destroy \
			-input=false \
			-refresh=true \
			-var-file="$(VARS)" \
			"$(BASE)"
