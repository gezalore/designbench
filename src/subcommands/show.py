# Copyright 2025 RTLMeter contributors
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
import os
from typing import Set

import tabulate

import metrics
from context import CTX
from descriptors import ExecuteDescriptor
from subcommands.common import TAGS, ArgExistingDirectory


def showCases(workRoot: str | None) -> None:
    items = CTX.availableCases
    if workRoot is not None:
        allData = metrics.readAll(workRoot)
        items = [_ for _ in items if _ in allData]
    # Print them
    table = [[_, ", ".join(ExecuteDescriptor(_).tags)] for _ in items]
    print(tabulate.tabulate(table, headers=["Case", "Tags"], tablefmt="simple"))


def showDesigns(workRoot: str | None, showLicense: bool) -> None:
    items = list(CTX.descriptors.keys())
    if workRoot is not None:
        allData = metrics.readAll(workRoot)
        available = set(_.partition(":")[0] for _ in allData)
        items = [_ for _ in items if _ in available]
    # Print them
    table = []
    for design in items:
        descr = CTX.descriptors[design]
        for i, origin in enumerate(descr["origin"]):
            if not showLicense:
                # Show source repositories
                table.append([design if i == 0 else "", origin["repository"], origin["revision"]])
            else:
                for j, license in enumerate(origin["licenses"]):
                    # Show licenses
                    path = os.path.relpath(os.path.join(descr["designDir"], license))
                    table.append([design if i == 0 and j == 0 else "", path])
        table.append(tabulate.SEPARATING_LINE)
    headers = ["Design"]
    if not showLicense:
        headers.extend(["Repositories", "Revision"])
    else:
        headers.extend(["License files"])
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


def showTags(workRoot: str | None) -> None:
    items = list(TAGS.keys())
    if workRoot is not None:
        allData = metrics.readAll(workRoot)
        cases = sorted(_ for _ in allData if _.count(":") == 2)
        available = set(tag for case in cases for tag in ExecuteDescriptor(case).tags)
        items = [_ for _ in items if _ in available]
    # Print them
    table = [[_, TAGS[_]] for _ in items]
    print(tabulate.tabulate(table, headers=["Tag", "Description"], tablefmt="simple"))


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
    elif args.tags:
        showTags(args.workRoot)
    else:
        raise RuntimeError("unreachable")


def addSubcommands(subparsers) -> None:
    # Subcommand "show"
    parser: argparse.ArgumentParser = subparsers.add_parser(
        "show",
        help="Display information about RTLMeter",
        description="""
            If a working directory 'DIR' is not given, display all available
            items known to RTLMeter. If 'DIR' is given, display only items
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
    group.add_argument("--tags", help="List case tags", action="store_true")
    parser.add_argument(
        "workRoot",
        help="Root of working directory",
        type=ArgExistingDirectory(),
        metavar="DIR",
        nargs="?",
    )
