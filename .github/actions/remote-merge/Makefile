PYTHON = python3

MAIN = main.py

.PHONY: test
test: test-unit

.PHONY: test-unit
test-unit: doctest

.PHONY: doctest
doctest:
	$(PYTHON) -m doctest $(MAIN)
