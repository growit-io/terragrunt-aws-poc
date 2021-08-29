PYTHON = python3

MAIN = main.py

.PHONY: test
test: test-unit

.PHONY: test-unit
test-unit: doctest
	$(PYTHON) -m unittest discover -b -p '*_test.py'

.PHONY: doctest
doctest:
	$(PYTHON) -m doctest $(MAIN)
