USER_CONFIG ?= $(HOME)/.config/terragrunt.mk

ifneq (,$(wildcard $(USER_CONFIG)))
include $(USER_CONFIG)
endif
