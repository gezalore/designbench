# Copyright (c) 2025, designbench contributors

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
