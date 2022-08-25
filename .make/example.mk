# Makefile fragment for Terraform module example scenarios

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

ifneq (,$(wildcard terragrunt.hcl))
include $(MAKEFILE_DIR)/example.terragrunt.mk
else
include $(MAKEFILE_DIR)/example.terraform.mk
endif
