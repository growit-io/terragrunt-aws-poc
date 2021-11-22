# Makefile for Terraform root module example scenarios that use Terragrunt

TERRAGRUNT ?= terragrunt

TERRAGRUNT_PARALLELISM ?= 1

TERRAGRUNT_FLAGS += --terragrunt-non-interactive --terragrunt-parallelism $(TERRAGRUNT_PARALLELISM)
TERRAGRUNT_DESTROY_FLAGS += --terragrunt-ignore-dependency-errors

TERRAFORM := $(TERRAGRUNT) run-all $(TERRAGRUNT_FLAGS)
TERRAFORM_DESTROY_FLAGS += $(TERRAGRUNT_DESTROY_FLAGS)

TERRAGRUNT_DIRS := $(shell find * ! \( -name '.*' -prune \) -type f -name terragrunt.hcl -exec dirname {} \;)

TERRAGRUNT_SOURCES := *.hcl *.tf
TERRAGRUNT_OUTPUTS := .terragrunt-cache .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup

TERRAFORM_SOURCES += $(foreach dir,$(TERRAGRUNT_DIRS),$(foreach source,$(TERRAGRUNT_SOURCES),$(wildcard $(dir)/$(source))))
TERRAFORM_OUTPUTS += $(foreach dir,$(TERRAGRUNT_DIRS),$(foreach output,$(TERRAGRUNT_OUTPUTS),$(dir)/$(output)))

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(MAKEFILE_DIR)/example.terraform.mk
