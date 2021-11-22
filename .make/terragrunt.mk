# Makefile fragment for "leaf" Terragrunt configuration directories

TERRAFORM ?= terraform
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

lint: # Nothing to be done

fix: # Nothing to be done

# Alias for `validate`
test: validate

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

.PHONY: all test init validate plan apply destroy clean

include $(MAKEFILE_DIR)/help.mk
