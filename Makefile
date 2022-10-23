# Default just downloads everything we might want for now
.PHONY: default
default: \
	bin/terraform \
	node_modules

lint: node_modules
	@echo "===> Checking Terraform..."
	./bin/terraform fmt -check -recursive ./terraform
	@echo "===> Checking other files..."
	npx prettier --check .

lint-fix: node_modules
	@echo "===> Fixing Terraform..."
	./bin/terraform fmt -recursive ./terraform
	@echo "===> Fixing other files..."
	npx prettier --write .

# For now we only support Linux 64 bit and MacOS for simplicity
ifeq ($(shell uname), Darwin)
OS_URL := darwin
else
OS_URL := linux
endif

################################################################################
# Local tooling
#
# This section contains tools to download to the local ./bin directory for easy
# local use.  The .envrc file makes adding the local ./bin directory to our path
# simple, so we can use tools here without having to install them globally as if
# they actually were global.

# Terraform manages our infrastructure
bin/terraform:
	mkdir -p bin
	curl -Lo bin/terraform.zip https://releases.hashicorp.com/terraform/1.3.2/terraform_1.3.2_$(OS_URL)_amd64.zip
	cd bin && unzip terraform.zip
	rm bin/terraform.zip

node_modules: package-lock.json
	npm install