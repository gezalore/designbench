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

import argparse

import subcommands.reporting
import subcommands.run
import subcommands.show
import subcommands.validate

if __name__ == "__main__":
    # Create the command line parser
    parser = argparse.ArgumentParser(
        prog="designbench", description="Verilator performance test suite", allow_abbrev=False
    )
    subparsers = parser.add_subparsers(title="subcommands", required=True)

    # Add the subcommands
    subcommands.show.addSubcommands(subparsers)
    subcommands.run.addSubcommands(subparsers)
    subcommands.reporting.addSubcommands(subparsers)
    subcommands.validate.addSubcommands(subparsers)

    # Parse arguments and dispatch to entry point
    args = parser.parse_args()
    args.entryPoint(args)
