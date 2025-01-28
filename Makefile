# Copyright (c) 2025, designbench contributors

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

PYTHON := $(ROOT_DIR)/venv/bin/python

export PYTHONPATH := "$(ROOT_DIR)/src:$(PYTHONPATH)"

.DEFAULT_GOAL := help

.PHONY: venv
venv:
	# Create virtual environment using the host python3 from $$PATH
	python3 -m venv $(ROOT_DIR)/venv
	# Install python3 dependencies
	$(ROOT_DIR)/venv/bin/pip3 install -r python-requirements.txt

.PHONY: typecheck
typecheck:
	env MYPYPATH=$(PYTHONPATH) $(PYTHON) -m mypy --disable-error-code=import-untyped src/main.py

.PHONY: lint
lint:
	$(PYTHON) -m pylint src

.PHONY: check
check: typecheck lint

.PHONY: format
format:
	$(PYTHON) -m ruff check --select I --fix src
	$(PYTHON) -m ruff format src

help:
	@echo "Available targets:"
	@echo "  venv:      Setup Pytnon virtual env under the venv directory"
	@echo "  check:     typecheck + lint"
	@echo "  typecheck: Run Python type checker on src"
	@echo "  lint:      Run Python linter on src"
	@echo "  format:    Run Python formatter on src"
