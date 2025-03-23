# Copyright 2025 designbench contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/..
PYTHON := $(ROOT_DIR)/venv/bin/python
export PYTHONPATH := "$(ROOT_DIR)/src:$(PYTHONPATH)"


# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    = --fail-on-warning
SPHINXBUILD   = $(ROOT_DIR)/venv/bin/sphinx-build
SOURCEDIR     = source
BUILDDIR      = build

.DEFAULT_GOAL := help

html spelling help:
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS)

server: html
	cd $(BUILDDIR)/html && $(PYTHON) -m http.server
