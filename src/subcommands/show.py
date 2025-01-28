# Copyright (c) 2025, designbench contributors

import argparse
import os

from typing import Set

from context import ctx
import tabulate

import metrics


def showCases() -> None:
    for item in ctx.availableCases:
        print(item)


def showDesigns() -> None:
    table = []
    for design, descr in ctx.descriptors.items():
        origin = descr["origin"]
        table.append([design, origin["repository"], origin["revision"]])
    print(tabulate.tabulate(
        table,
        headers=["Design", "Repository", "Revision"],
        tablefmt="simple"
    ))
    return


def showMetrics(workRoot: str) -> None:
    allData = metrics.readAll(workRoot)
    # Gather all metrics
    available: Set[metrics.Metric] = set()
    for caseData in allData.values():
        for stepData in caseData.values():
            available.update(stepData.keys())
    # Might be bust
    if not available:
        print(f"No metrics recored in {workRoot}")
        return
    # Display
    table = [[_, metrics.metricTitle(_)] for _ in sorted(available)]
    print(tabulate.tabulate(
        table,
        headers=["Metirc", "Description"],
        tablefmt="simple"
    ))


def showSteps(workRoot: str) -> None:
    allData = metrics.readAll(workRoot)
    # Gather all metrics
    available: Set[metrics.Step] = set()
    for caseData in allData.values():
        available.update(caseData.keys())
    # Might be bust
    if not available:
        print(f"No steps recored in {workRoot}")
        return
    # Display
    table = [[_, metrics.stepDescription(_)] for _ in sorted(available)]
    print(tabulate.tabulate(
        table,
        headers=["Step", "Description"],
        tablefmt="simple"
    ))


def main(args: argparse.Namespace) -> None:
    if args.cases:
        showCases()
    elif args.designs:
        showDesigns()
    elif (workRoot := args.metrics) is not None:
        showMetrics(workRoot)
    elif (workRoot := args.steps) is not None:
        showSteps(workRoot)
    else:
        raise RuntimeError("unreachable")


def addSubcommands(subparsers) -> None:
    # Subcommand "show"
    parser: argparse.ArgumentParser = subparsers.add_parser(
        "show",
        help="Display information about designbench",
        allow_abbrev=False
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.set_defaults(entryPoint=main)
    group.add_argument(
        "--cases",
        help="List all available cases",
        action="store_true"
    )
    group.add_argument(
        "--designs",
        help="List all designs",
        action="store_true"
    )
    group.add_argument(
        "--metrics",
        help="List metrics recored in working directory %(metavar)s",
        metavar="DIR",
        type=os.path.abspath,
        const=ctx.DEFAULT_WORK_DIR,
        nargs="?"
    )
    group.add_argument(
        "--steps",
        help="List steps recored in working directory %(metavar)s",
        metavar="DIR",
        type=os.path.abspath,
        const=ctx.DEFAULT_WORK_DIR,
        nargs="?"
    )
