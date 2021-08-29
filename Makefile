.PHONY: test test-unit
test test-unit:
	@echo '==> .github/actions/remote-merge'
	@$(MAKE) -C .github/actions/remote-merge $@
