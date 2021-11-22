# Makefile fragment for test suites based on Go and Terratest

GO ?= go

GO_TEST_TIMEOUT ?= 30m

EXAMPLES_DIR ?= ../examples

EXAMPLES ?= $(patsubst $(EXAMPLES_DIR)/%/Makefile,%,$(wildcard $(EXAMPLES_DIR)/*/Makefile))

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# Alias for `test'
all: test

lint: # Nothing to be done

fix: # Nothing to be done

# Execute all Terratest test suites
test: depends
	$(GO) test -timeout $(GO_TEST_TIMEOUT)
	@$(MAKE) clean >/dev/null

# Download Terratest and other Go module dependencies
depends:
	$(GO) mod download

# Destroy example infrastructure and clean up temporary files
clean:
	@for example in $(EXAMPLES); do \
	  $(MAKE) -C "$(EXAMPLES_DIR)/$$example" -w clean; \
  	done

.PHONY: all test depends clean

include $(MAKEFILE_DIR)/config.mk
include $(MAKEFILE_DIR)/help.mk
