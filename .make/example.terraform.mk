# Makefile for Terraform non-root module example scenarios

TERRAFORM ?= terraform

TERRAFORM_INIT_FLAGS += -upgrade
TERRAFORM_PLAN_FLAGS += -input=false
TERRAFORM_APPLY_FLAGS += -input=false -auto-approve
TERRAFORM_DESTROY_FLAGS += $(TERRAFORM_APPLY_FLAGS)

TERRAFORM_MODULE_DIR ?= $(CURDIR)/../..

TERRAFORM_SOURCES += $(shell find *.tf $(TERRAFORM_MODULE_DIR)/*.tf $(TERRAFORM_MODULE_DIR)/modules ! \( -name '.*' -prune \) -type f -name '*.tf' 2>/dev/null)
TERRAFORM_OUTPUTS += .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup

COOKIES_DIR := .make-cookies
INIT_COOKIE := $(COOKIES_DIR)/init_done
VALIDATE_COOKIE := $(COOKIES_DIR)/validate_done
PLAN_COOKIE := $(COOKIES_DIR)/plan_done
APPLY_COOKIE := $(COOKIES_DIR)/apply_done
APPLY_STARTED_COOKIE := $(COOKIES_DIR)/apply_started
DESTROY_COOKIE := $(COOKIES_DIR)/destroy_done

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# Alias for `test'
all: test

lint: # Nothing to be done

fix: # Nothing to be done

# Apply and destroy the example infrastructure
test::
	@$(MAKE) --no-print-directory apply || { $(MAKE) --no-print-directory clean; exit 1; }
	@$(MAKE) --no-print-directory clean

# Destroy the infrastructure and remove temporary files
clean: destroy
	@rm -Rf $(TERRAFORM_OUTPUTS)
	@rm -Rf $(COOKIES_DIR)

# Initialize the example configuration
init: $(INIT_COOKIE)
$(INIT_COOKIE): $(TERRAFORM_SOURCES) $(COOKIES_DIR)
	$(TERRAFORM) init $(TERRAFORM_INIT_FLAGS)
	@touch $@

# Validate the example configuration
validate: $(VALIDATE_COOKIE)
$(VALIDATE_COOKIE): $(INIT_COOKIE)
	$(TERRAFORM) validate
	@touch $@

# Generate a speculative execution plan
plan: $(PLAN_COOKIE)
$(PLAN_COOKIE): $(VALIDATE_COOKIE)
	$(TERRAFORM) plan $(TERRAFORM_PLAN_FLAGS)
	@touch $@

# Create or update the example infrastructure
apply: $(APPLY_COOKIE)
$(APPLY_COOKIE): $(VALIDATE_COOKIE)
	@rm -f $(DESTROY_COOKIE)
	@touch $(APPLY_STARTED_COOKIE)
	$(TERRAFORM) apply $(TERRAFORM_APPLY_FLAGS)
	@touch $@

# Destroy the example infrastructure
destroy: $(DESTROY_COOKIE)
$(DESTROY_COOKIE): $(COOKIES_DIR)
	@if [ -e $(APPLY_STARTED_COOKIE) ]; then \
	  echo '$(TERRAFORM) destroy $(TERRAFORM_DESTROY_FLAGS)'; \
	  $(TERRAFORM) destroy $(TERRAFORM_DESTROY_FLAGS); \
	fi
	@touch $(DESTROY_COOKIE)

# Invoke $SHELL with Make's environment variables
shell:
	@PS1="(`basename $(MAKE)`) \\W\\$$ " $(SHELL) -i || true

$(COOKIES_DIR):
	@mkdir $(COOKIES_DIR)

.PHONY: all test clean init validate apply destroy shell

include $(MAKEFILE_DIR)/config.mk
include $(MAKEFILE_DIR)/help.mk
