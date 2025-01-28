# Copyright (c) 2025, designbench contributors

import argparse
import difflib
import fnmatch
import os
import shlex
import sys

from collections import defaultdict
from typing import Dict, List, Tuple

from context import ctx
from cgraph import CGraph, CNode
from descriptors import CompileDescriptor, ExecuteDescriptor
import misc
import verilator as sim


def compile(
    cgraph: CGraph,
    descr: CompileDescriptor,
    compileDir: str,
    extraArgs: List[str] = []
) -> Tuple[CNode, CNode]:
    return sim.compile(cgraph, descr, compileDir, extraArgs)


def execute(
    cgraph: CGraph,
    descr: ExecuteDescriptor,
    compileDir: str,
    executeDir: str
) -> Tuple[CNode, CNode]:
    startNode, endNode = sim.execute(cgraph, descr, compileDir, executeDir)

    # If prep script is given, run it before execution
    if (testPrep := descr.testPrep) is not None:
        def prep() -> bool:
            with misc.inDirectory(executeDir):
                cmd = [testPrep, descr.designDir, descr.test, descr.config]
                return misc.run(cmd, "prep").isSuccess()
        prepNode = cgraph.addNode(f"{descr.case} - Test prep", prep)
        cgraph.addEdge(prepNode, startNode)
        startNode = prepNode

    # If post script is given, run it after execution
    if (testPost := descr.testPost) is not None:
        def check() -> bool:
            with misc.inDirectory(executeDir):
                cmd = [testPost, descr.designDir, descr.test, descr.config, "_execute/stdout.log"]
                return misc.run(cmd, "post").isSuccess()
        postNode = cgraph.addNode(f"{descr.case} - Test post", check)
        cgraph.addEdge(endNode, postNode)
        endNode = postNode

    return startNode, endNode


def main(args: argparse.Namespace) -> None:
    ctx.retry = args.retry
    ctx.trace = args.trace
    ctx.verbose = args.verbose

    if ctx.verbose and args.compileArgs:
        misc.echo(f"compileArgs: {args.compileArgs}")

    compileRoot = args.compileRoot or args.workRoot
    executeRoot = args.executeRoot or args.workRoot

    cgraph: CGraph = CGraph()


    # Set up compilation jobs
    compileCNodes: Dict[str, List[CNode]] = defaultdict(list)
    for n in range(args.repeat if args.compileOnly else 1):
        for case in args.cases:
            case , _ = case.rsplit(":", maxsplit=1)

            if len(compileCNodes[case]) != n:
                continue
            assert len(compileCNodes[case]) == n

            cDescr = CompileDescriptor(case)
            compileDir = os.path.join(compileRoot, cDescr.design, cDescr.config, f"compile-{n}")

            _, endNode = compile(cgraph, cDescr, compileDir, args.compileArgs)
            compileCNodes[case].append(endNode)

    # Set up execution jobs
    for n in range(args.repeat if not args.compileOnly else 0):
        for case in args.cases:
            # Always use the first compile node
            compileNode = compileCNodes[case.rsplit(":", maxsplit=1)[0]][0]

            eDescr: ExecuteDescriptor = ExecuteDescriptor(case)
            compileDir = os.path.join(compileRoot, eDescr.design, eDescr.config, "compile-0")
            executeDir = os.path.join(executeRoot, eDescr.design, eDescr.config, f"execute-{n}", eDescr.test)

            startNode, _ = execute(cgraph, eDescr, compileDir, executeDir)
            cgraph.addEdge(compileNode, startNode)

    # Run the graph
    if failedNodes := cgraph.runAll():
        misc.echo("The following steps have failed:", style="redBold")
        for node in failedNodes:
            print(f"    {node.name}")
        sys.exit(1)

    misc.echo("All cases passed", style="greenBold")


# Expand case patterns and validate it's an existing case
def argCaseName(pattern: str) -> List[str]:
    cases = fnmatch.filter(ctx.availableCases, pattern)
    if not cases:
        suggestion = None
        if "*" not in pattern:
            suggestion = difflib.get_close_matches(pattern, ctx.availableCases, n=1, cutoff=0.9)
        if suggestion:
            raise argparse.ArgumentTypeError(f"'{pattern}' does not name a valid case, did you mean '{suggestion[0]}'?")
        else:
            raise argparse.ArgumentTypeError(f"'{pattern}' does not name a valid case, see 'designbench list-cases' for valid choices")
    return cases


# Flatten [[_]] into [_] of distinct elements only, preserves ordering
class FlattenDistinct(argparse.Action):
    def __call__(self, parser, namespace, values, option_string = None):
        result = []
        for items in values:
            for item in items:
                if not item in result:
                    result.append(item)
        setattr(namespace, self.dest, result)


def addSubcommands(subParsers) -> None:
    # Subcommand "run"
    parser: argparse.ArgumentParser = subParsers.add_parser(
        "run",
        help="Run some cases",
        description="""
            Execute some cases. This always uses the first compiled simulator
            (the artefacts under '<WORKDIR>/<DESIGN>/<CONFIG>/compile-0/'),
            and runs compilation if that has not yet been compiled successfully.
            """,
        allow_abbrev=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.set_defaults(entryPoint=main)
    parser.add_argument(
        "--cases",
        help="List of cases to run (space separated, can contain * patterns)",
        type=argCaseName,
        action=FlattenDistinct,
        required=True,
        nargs="+",
        metavar="CASE"
    )
    parser.add_argument(
        "--compileArgs",
        help="""
            Extra options to add to the end of the compilation command line.
            Provided as a single string that will undergo shell word splitting,
            but no other procssing (no globs or variable substitution).
        """,
        type=shlex.split,
        metavar="STRING",
        action="extend",
        default=[]
    )
    parser.add_argument(
        "--compileOnly",
        help="Only run compilation, not execution",
        action="store_true"
    )
    parser.add_argument(
        "--repeat",
        help="""
            Repeat run N times.
            With --compileOnly, compilation is repeated.
            Without --compileOnly, compilation is done once, and execution is repeated
        """,
        type = int,
        default=1,
        metavar="N"
    )
    parser.add_argument(
        "--retry",
        help="Retry steps that failed earleir",
        action="store_true"
    )
    parser.add_argument(
        "--trace",
        help="Generate waveform dumps",
        metavar="FORMAT",
        choices=["vcd", "fst"]
    )
    parser.add_argument(
        "--verbose",
        help="Report more info about the process",
        action="store_true"
    )
    parserWorkRootGroup = parser.add_argument_group("Options to specify working directory")
    parserWorkRootGroup.add_argument(
        "--compileRoot",
        help="Root of working directory for compilation only, value of --workRoot by default",
        type=os.path.abspath,
        metavar="DIR"
    )
    parserWorkRootGroup.add_argument(
        "--executeRoot",
        help="Root of working directory for execution only, value of --workRoot by default",
        type=os.path.abspath,
        metavar="DIR"
    )
    parserWorkRootGroup.add_argument(
        "--workRoot",
        help="Root of working directory for compilation and execution",
        type=os.path.abspath,
        default=ctx.DEFAULT_WORK_DIR,
        metavar="DIR"
    )
