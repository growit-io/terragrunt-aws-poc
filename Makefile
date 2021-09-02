TERRAGRUNT = terragrunt
TERRAGRUNT_LOG_LEVEL = error
TERRAGRUNT_PARALLELISM = 10

TERRAGRUNT_FLAGS = \
  --terragrunt-log-level $(TERRAGRUNT_LOG_LEVEL) \
  --terragrunt-parallelism $(TERRAGRUNT_PARALLELISM) \
  --terragrunt-non-interactive

TERRAFORM_init_FLAGS = -input=false
TERRAFORM_plan_FLAGS = -input=false -lock=false -refresh=false
TERRAFORM_apply_FLAGS = -input=false -lock-timeout=5m

# paths is a list of patterns interpreted by the `-path` primary of the find(1)
# command, relative to the current working directory. Terragrunt will be invoked
# in each matching directory, if the hierarchy below the matching directory has
# at least one terragrunt.hcl file. Any hidden directories, and any directories
# named "modules" are excluded.
ifeq ($(strip $(paths)),)
override paths = *
endif

# SUBDIRS is the actual list of directories in which Terragrunt will be invoked
# and it is constructed using the patterns in the 'paths' variable.
override SUBDIRS = $(shell set -f; for pattern in $(paths); do \
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

.PHONY: default
default:
ifneq ($(strip $(show)),)
	@echo '$($(show))'
else
	@$(MAKE) validate
endif

.PHONY: init validate show output
init validate show output:
	@$(MAKE) run-all command=$@

.PHONY: plan
plan:
ifeq ($(CI),true)
	@find . -type f -name tfplan -delete
endif
	@$(MAKE) run-all command=$@ args='-out=tfplan $(args)'
ifeq ($(CI),true)
	@$(CURDIR)/.terragrunt/bin/plan-feedback tfplan
endif

.PHONY: apply
apply: plan
	@$(MAKE) run-all command=$@ args='tfplan $(args)'

.PHONY: run-all
run-all:
ifeq ($(strip $(command)),)
	@echo 'Usage: run-all command=init|validate|plan|apply|... [args=...]' >&2
	@exit 2
else
	@set -e; for dir in $(SUBDIRS); do \
	  echo "==> $$dir [run-all $(command)]" >&2; \
	  (cd ./$$dir && $(TERRAGRUNT) run-all $(TERRAGRUNT_FLAGS) $(command) $(TERRAFORM_$(command)_FLAGS) $(args)); \
	done
endif

.PHONY: graph
graph: graph-root
ifneq ($(strip $(SUBDIRS)),)
	@find $(SUBDIRS) ! \( -type d -name '.*' -prune \) -type f -name terragrunt.hcl -exec dirname {} \; | while read -r dir; do \
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

.PHONY: clean
clean:
	find . -type d \( -name .terragrunt-cache -o -name .terraform \) -prune -exec rm -Rf {} \;
	if tty -s; then git clean -di; else git clean -fd; fi

.PHONY: pull-state
pull-state:
	@for dir in $(SUBDIRS); do \
		find $$dir/* ! \( -name '.*' -prune \) -type f -name terragrunt.hcl -exec dirname {} \; | \
		while read config_path; do \
		  echo "==> $$config_path [state pull]" >&2; \
		  (cd "./$$config_path" && $(TERRAGRUNT) state pull > tfstate.json); \
		done; \
	done

.PHONY: push-state
push-state:
	@for dir in $(SUBDIRS); do \
		find $$dir/* ! \( -name '.*' -prune \) -type f -name terragrunt.hcl -exec dirname {} \; | \
		while read config_path; do \
		  echo "==> $$config_path [state push]" >&2; \
		  (cd "./$$config_path" && $(TERRAGRUNT) state push $$(pwd)/tfstate.json); \
		done; \
	done
