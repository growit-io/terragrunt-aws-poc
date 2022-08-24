# Makefile fragment for recursive processing of Terragrunt configurations

TERRAGRUNT ?= terragrunt
TERRAGRUNT += run-all

# In Terragrunt 0.31, the default parallelism is > 1 and it mixes the log
# output of all commands
TERRAGRUNT_PARALLELISM ?= 1

TERRAGRUNT_FLAGS += \
  --terragrunt-parallelism '$(TERRAGRUNT_PARALLELISM)' \
  --terragrunt-ignore-external-dependencies

TERRAGRUNT_DESTROY_EXCLUDE_DIRS ?=

TERRAGRUNT_DESTROY_FLAGS += $(patsubst %,--terragrunt-exclude-dir %,$(TERRAGRUNT_DESTROY_EXCLUDE_DIRS)) \
	--terragrunt-ignore-dependency-errors

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(MAKEFILE_DIR)/terragrunt.mk
