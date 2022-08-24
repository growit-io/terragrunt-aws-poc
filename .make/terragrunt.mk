# Makefile fragment for "leaf" Terragrunt configuration directories

TERRAFORM ?= terraform
TERRAFORM_FMT := $(TERRAFORM) fmt
TERRAFORM_FMT_CHECK := $(TERRAFORM_FMT) -check -diff

TERRAGRUNT ?= terragrunt
TERRAGRUNT_TFPATH := $(TERRAFORM)

# The default log level is "warn" and it is too verbose in Terragrunt 0.31
TERRAGRUNT_LOG_LEVEL ?= fatal

TERRAGRUNT_FLAGS += \
  --terragrunt-log-level '$(TERRAGRUNT_LOG_LEVEL)' \
  --terragrunt-tfpath '$(TERRAGRUNT_TFPATH)'

TERRAGRUNT_INIT_FLAGS += $(TERRAGRUNT_FLAGS) -upgrade
TERRAGRUNT_DESTROY_FLAGS += $(TERRAGRUNT_FLAGS)

TERRAGRUNT_OUTPUTS += .terragrunt-cache .terraform.lock.hcl

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# Alias for `test`
all: test

# Check for common violations of best practices
lint: fmt-check

# Check for canonical Terraform source formatting
fmt-check:
	@set -e; \
	status=0; \
  	find . -maxdepth 1 -type f -name '*.hcl' -exec cp {} {}.tf \;; \
	$(TERRAFORM_FMT_CHECK) >.terraform-fmt.out || status=$$?; \
	sed -E \
	  -e '/^[^-+@ ]/d' \
	  -e 's/^([-+].*\.hcl)\.tf$$/\1/' \
	  .terraform-fmt.out; \
  	rm -f .terraform-fmt.out; \
  	find . -maxdepth 1 -type f -name '*.hcl.tf' -delete; \
  	if [ $$status -ne 0 ]; then \
  	  echo 'Run "$(MAKE) -C $(CURDIR) fmt" to rewrite all Terragrunt configuration files to the canonical format.'; \
	fi; \
  	exit $$status

# Fix some common violations of best practices
fix: fmt

# Fix canonical Terraform source formatting
fmt:
	@set -e; \
	status=0; \
  	find . -maxdepth 1 -type f -name 'terragrunt.hcl' -exec cp {} {}.tf \;; \
	$(TERRAFORM) fmt -write=true >.terraform-fmt.out || status=$$?; \
	sed -E -e 's/^(.*\.hcl)\.tf$$/\1/' .terraform-fmt.out; \
  	rm -f .terraform-fmt.out; \
  	find . -maxdepth 1 -type f -name '*.hcl.tf' | while read file; do \
  	  mv "$$file" "$$(dirname $$file)/$$(basename $$file .tf)"; \
  	done; \
  	exit $$status

# Alias for `lint validate`
test: lint validate

# Initialize Terraform working directory
init:
	$(TERRAGRUNT) init $(TERRAGRUNT_INIT_FLAGS)

# Validate Terraform configuration files
validate:
	$(TERRAGRUNT) validate $(TERRAGRUNT_FLAGS)

# Generate a speculative execution plan
plan:
	$(TERRAGRUNT) plan $(TERRAGRUNT_FLAGS)

# Apply infrastructure configuration changes
apply:
	$(TERRAGRUNT) apply $(TERRAGRUNT_FLAGS)

# Permanently destroy the existing infrastructure
destroy:
	$(TERRAGRUNT) destroy $(TERRAGRUNT_DESTROY_FLAGS)

# Remove temporary files created by Terragrunt
clean::
	rm -Rf $(TERRAGRUNT_OUTPUTS)

.PHONY: all lint fmt-check fix fmt test init validate plan apply destroy clean

include $(MAKEFILE_DIR)/help.mk
