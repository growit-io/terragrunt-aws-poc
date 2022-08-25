# Makefile fragment for recursive processing of subdirectories

.DEFAULT_GOAL := $(DEFAULT_GOAL)

GIT ?= git

GIT_BASE_REF ?= origin/main

SUBDIRS ?= $(patsubst %/Makefile,%,$(wildcard */Makefile))

EXCLUDE_SUBDIRS ?=

SKIP_UNCHANGED ?= false

EFFECTIVE_SUBDIRS := $(filter-out $(EXCLUDE_SUBDIRS),$(SUBDIRS))

EFFECTIVE_GOALS := $(MAKECMDGOALS)
ifeq ($(EFFECTIVE_GOALS),)
EFFECTIVE_GOALS := $(.DEFAULT_GOAL)
endif

SUBDIR_GOALS := all lint fix test clean

# Invoke the default goal(s) recursively
all:

# Invoke the `lint` goal recursively
lint:

# Invoke the `fix` goal recursively
fix:

# Invoke the `test` goal recursively
test:

# Invoke the `clean` goal recursively
clean:

$(SUBDIR_GOALS): $(patsubst %,%.subdir,$(EFFECTIVE_SUBDIRS))

$(patsubst %,%.subdir,$(SUBDIRS)):
	@subdir='$(patsubst %.subdir,%,$@)'; \
	if [ X"$(SKIP_UNCHANGED)" != X'true' ] || \
		[ X"`$(GIT) status -s \"$$subdir\"`" != X'' ] || \
		! $(GIT) diff --quiet $(GIT_BASE_REF) -- "$$subdir"; \
	then \
	  $(MAKE) -C "$$subdir" -w $(filter-out $(SUBDIRS),$(EFFECTIVE_GOALS)); \
	else \
	  echo "make: Skipping directory \`$(CURDIR)/$$subdir' (unchanged)"; \
	fi

.PHONY: $(SUBDIR_GOALS) $(patsubst %,%.subdir,$(SUBDIRS))

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

include $(MAKEFILE_DIR)/help.mk
