# This is the top-level Makefile for this repository. All makefile fragments
# used in this repository should be located in the .make/ subdirectory, along
# with a corresponding documentation of their purpose, goals, and variables.

# Skip the `examples/` subdirectory since this repository shouldn't touch it.
EXCLUDE_SUBDIRS += examples

TERRAGRUNT = terragrunt

# paths is a list of patterns interpreted by the `-path` primary of the find(1)
# command, relative to the current working directory. Terragrunt will be invoked
# in each matching directory, if the hierarchy below the matching directory has
# at least one terragrunt.hcl file. Any hidden directories, and any directories
# named "modules" are excluded.
ifeq ($(strip $(paths)),)
override paths = */workloads/dev
endif

# GRAPH_SUBDIRS is the actual list of directories in which Terragrunt will be
# invoked to generate graphs and it is constructed using the patterns in the
# 'paths' variable.
override GRAPH_SUBDIRS = $(shell set -f; for pattern in $(paths); do \
    set +f; find * \
      ! \( -type d -path '*/.terraform' -prune \) \
      ! \( -type d -path '*/.terragrunt-cache' -prune \) \
      ! \( -type d -path 'modules' -prune \) \
      -type d -path "$$pattern" -prune | \
    sort | \
    while read -r dir; do \
	  find "$$dir" \
	    ! \( -type d -path '*/.terraform' -prune \) \
		! \( -type d -path '*/.terragrunt-cache' -prune \) \
		! \( -type d -path 'modules' -prune \) \
		-type f -name terragrunt.hcl | \
	  grep -q . && echo "$$dir" || true; \
    done; \
  done)

.PHONY: graph
graph: graph-root
ifneq ($(strip $(GRAPH_SUBDIRS)),)
	@set -e; \
	find $(GRAPH_SUBDIRS) ! \( -type d -name '.*' -prune \) -type f -name terragrunt.hcl -exec dirname {} \; | while read -r dir; do \
	  echo "==> $$dir [graph]" >&2; \
	  ( \
	    cd "$(CURDIR)/$$dir"; \
	    $(TERRAGRUNT) graph-dependencies --terragrunt-ignore-external-dependencies | \
	      CURDIR='$(CURDIR)' "$(CURDIR)/.terragrunt/bin/prettier-graph" | \
	      dot -Tsvg >graph.svg; \
	    if [ ! -f README.md ] || grep -q '<!-- auto-generated -->' README.md; then \
	      echo "<!-- auto-generated -->\n# $$(basename "$$dir")\n\n## Dependencies\n\n![Dependency graph](graph.svg)" > README.md; \
	    fi \
	  ); \
	done
endif

.PHONY: graph-root
graph-root:
	@echo "==> . [graph]" >&2; \
	$(TERRAGRUNT) graph-dependencies --terragrunt-ignore-external-dependencies | \
	  CURDIR='$(CURDIR)' .terragrunt/bin/prettier-graph | \
	  dot -Tsvg >graph.svg

include .make/subdir.mk
