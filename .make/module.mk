# Makefile fragment for Terraform modules

DEFAULT_GOAL ?= lint

TERRAFORM ?= terraform
TERRAFORM_FMT := $(TERRAFORM) fmt
TERRAFORM_FMT_CHECK := $(TERRAFORM_FMT) -check -diff

TFLINT ?= tflint
TFLINT_CONFIG ?= $(TOP_DIR)/.tflint.hcl

REQUIRED_FILES ?= main.tf outputs.tf variables.tf

TERRAFORM_DOCS ?= terraform-docs
TERRAFORM_DOCS_MARKDOWN := $(TERRAFORM_DOCS) markdown document . --output-file README.md --hide-empty --hide requirements,providers,modules
TERRAFORM_DOCS_MARKDOWN_CHECK := $(TERRAFORM_DOCS_MARKDOWN) --output-check

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
TOP_DIR := $(MAKEFILE_DIR)/..

# Invoke the default goal(s) recursively (here `lint')
all: lint

# Check for common violations of best practices
lint: fmt-check tflint docs-check

# Fix some common violations of best practices
fix: fmt missing docs

# Check conventions and run examples and/or test suites
test: lint

# Check for canonical Terraform source formatting
fmt-check:
	@echo $(TERRAFORM_FMT_CHECK)
	@$(TERRAFORM_FMT_CHECK) || { \
  	  echo "Run \`$(MAKE) -C $(CURDIR) fmt' to reformat your .tf files automatically."; \
  	  exit 1; \
	}

# Fix canonical Terraform source formatting
fmt:
	$(TERRAFORM_FMT)

# Run TFlint with our own rule configuration
tflint: $(REQUIRED_FILES)
	$(TFLINT) --config $(TFLINT_CONFIG) --init >/dev/null
	$(TFLINT) --config $(TFLINT_CONFIG) .

$(REQUIRED_FILES):
	@echo 'One or more required files are missing ($@).'
	@echo "Run \`$(MAKE) -C $(CURDIR) missing' to create them."
	@exit 1

# Create missing required files for Terraform modules
missing:
	touch $(REQUIRED_FILES)

# Check whether the module documentation is up-to-date
docs-check:
	@echo $(TERRAFORM_DOCS_MARKDOWN_CHECK)
	@$(TERRAFORM_DOCS_MARKDOWN_CHECK) || { \
	  echo "Run \`$(MAKE) -C $(CURDIR) docs' to update the documentation."; \
	  exit 1; \
	}

# Update the generated module documentation
docs:
	$(TERRAFORM_DOCS_MARKDOWN)

.PHONY: fmt-check fmt tflint missing docs-check docs

include $(MAKEFILE_DIR)/config.mk
include $(MAKEFILE_DIR)/subdir.mk
