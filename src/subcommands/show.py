# Copyright (c) 2025, designbench contributors

import argparse
from typing import Set

import tabulate

import metrics
from context import CTX
from subcommands.common import ArgExistingDirectory


def showCases(workRoot: str | None) -> None:
    if workRoot is None:
        items = CTX.availableCases
    else:
        allData = metrics.readAll(workRoot)
        items = sorted(_ for _ in allData if _.count(":") == 2)
    # Print them
    for item in items:
        print(item)


def showDesigns(workRoot: str | None, showLicense: bool) -> None:
    if workRoot is None:
        items = list(CTX.descriptors.items())
    else:
        allData = metrics.readAll(workRoot)
        valid = set(_.partition(":")[0] for _ in allData)
        items = [_ for _ in CTX.descriptors.items() if _[0] in valid]
    # Print them
    table = []
    for design, descr in items:
        for i, origin in enumerate(descr["origin"]):
            if not showLicense:
                # Show source repositories
                table.append([design if i == 0 else "", origin["repository"], origin["revision"]])
            else:
                # Show licenses
                table.append([design if i == 0 else "", origin["license"]])
        table.append(tabulate.SEPARATING_LINE)
    headers = ["Design"]
    if not showLicense:
        headers.extend(["Repositories", "Revision"])
    else:
        headers.extend(["Licenses"])
    print(tabulate.tabulate(table, headers=headers, tablefmt="simple"))


def showMetrics(workRoot: str | None) -> None:
    items = list(metrics.METRICS.keys())
    if workRoot is not None:
        allData = metrics.readAll(workRoot)
        available: Set[metrics.Metric] = set()
        for caseData in allData.values():
            for stepData in caseData.values():
                available.update(stepData.keys())
        # Might be bust
        if not available:
            print(f"No metrics recored in {workRoot}")
            return
        items = [_ for _ in items if _ in available]
    # Print them
    table = []
    for metric in items:
        mdef = metrics.metricDef(metric)
        table.append([metric, mdef.header, mdef.description])
    print(
        tabulate.tabulate(
            table,
            headers=["Metric", "Label", "Description"],
            tablefmt="simple",
            maxcolwidths=[None, None, 70],
        )
    )


def showSteps(workRoot: str | None) -> None:
    items = list(metrics.STEPS.keys())
    if workRoot is not None:
        allData = metrics.readAll(workRoot)
        # Gather all metrics
        available: Set[metrics.Step] = set()
        for caseData in allData.values():
            available.update(caseData.keys())
        # Might be bust
        if not available:
            print(f"No steps recored in {workRoot}")
            return
        items = [_ for _ in items if _ in available]
    # Print them
    table = [[_, metrics.stepDescription(_)] for _ in items]
    print(tabulate.tabulate(table, headers=["Step", "Description"], tablefmt="simple"))


def main(args: argparse.Namespace) -> None:
    if args.cases:
        showCases(args.workRoot)
    elif args.designs:
        showDesigns(args.workRoot, False)
    elif args.licenses:
        showDesigns(args.workRoot, True)
    elif args.metrics:
        showMetrics(args.workRoot)
    elif args.steps:
        showSteps(args.workRoot)
    else:
        raise RuntimeError("unreachable")


def addSubcommands(subparsers) -> None:
    # Subcommand "show"
    parser: argparse.ArgumentParser = subparsers.add_parser(
        "show",
        help="Display information about designbench",
        description="""
            If a working directory 'DIR' is not given, display all available
            items known to designbench. If 'DIR' is given, display only items
            that have recorded results in the given working directory.
        """,
        allow_abbrev=False,
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.set_defaults(entryPoint=main)
    group.add_argument("--cases", help="List available cases", action="store_true")
    group.add_argument("--designs", help="List designs", action="store_true")
    group.add_argument("--licenses", help="List licenses", action="store_true")
    group.add_argument("--metrics", help="List valid metrics", action="store_true")
    group.add_argument("--steps", help="List valid steps", action="store_true")
    parser.add_argument(
        "workRoot",
        help="Root of working directory",
        type=ArgExistingDirectory(),
        metavar="DIR",
        nargs="?",
    )
