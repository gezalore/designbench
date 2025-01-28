# Copyright (c) 2025, designbench contributors

import argparse
import os
import shlex
import shutil
import sys
from collections import defaultdict
from typing import Dict, List, Tuple

import tabulate

import misc
import verilator as sim
from case_descriptor import CompileDescriptor, ExecuteDescriptor
from cgraph import CGraph, CNode, CStatus
from context import CTX
from runcmd import runcmd
from subcommands.common import ArgPatternMatcher, ArgRangedInt


def compile(
    cgraph: CGraph, descr: CompileDescriptor, compileDir: str, extraArgs: List[str]
) -> Tuple[CNode, CNode]:
    # Compilation
    startNode, endNode = sim.compile(cgraph, descr, compileDir, extraArgs)

    # Before anything else, prepare inputs for compilation
    def prep() -> bool:
        def symlinkAll(name: str) -> None:
            if files := getattr(descr, name):
                shutil.rmtree(name, ignore_errors=True)
                os.makedirs(name)
                with misc.inDirectory(name):
                    for f in files:
                        os.symlink(os.path.relpath(f), os.path.basename(f))

        symlinkAll("verilogSourceFiles")
        symlinkAll("verilogIncludeFiles")
        symlinkAll("cppSourceFiles")
        symlinkAll("cppIncludeFiles")
        return True

    prepNode = cgraph.addNode(
        f"{descr.case} - Prepare inputs for compile step", compileDir, "prep", prep
    )
    cgraph.addEdge(prepNode, startNode)
    startNode = prepNode

    # Done
    return startNode, endNode


def execute(
    cgraph: CGraph, descr: ExecuteDescriptor, compileDir: str, executeDir: str
) -> Tuple[CNode, CNode]:
    # Execution
    startNode, endNode = sim.execute(cgraph, descr, compileDir, executeDir)

    # If prep script is given, run it before execution
    if (testPrep := descr.testPrep) is not None:
        step = "testPrep"

        def prep() -> bool:
            cmd = [testPrep, descr.designDir, descr.test, descr.config]
            return runcmd(cmd, step)

        prepNode = cgraph.addNode(f"{descr.case} - testPrep hook", executeDir, step, prep)
        cgraph.addEdge(prepNode, startNode)
        startNode = prepNode

    # If post script is given, run it after execution
    if (testPost := descr.testPost) is not None:
        step = "testPost"

        def post() -> bool:
            cmd = [testPost, descr.designDir, descr.test, descr.config, "_execute/stdout.log"]
            return runcmd(cmd, step)

        postNode = cgraph.addNode(f"{descr.case} - testPost hook", executeDir, step, post)
        cgraph.addEdge(endNode, postNode)
        endNode = postNode

    # Before anything else, prepare inputs for execution
    if executeInputFiles := descr.executeInputFiles:

        def link() -> bool:
            for src, dst in executeInputFiles.items():
                if dirName := os.path.dirname(dst):
                    os.makedirs(dirName, exist_ok=True)
                os.symlink(os.path.realpath(src), dst)
            return True

        linkNode = cgraph.addNode(
            f"{descr.case} - Prepare input files for execute step", executeDir, "prep", link
        )
        cgraph.addEdge(linkNode, startNode)
        startNode = linkNode

    # Done
    return startNode, endNode


def main(args: argparse.Namespace) -> None:
    CTX.trace = args.trace
    CTX.verbose = args.verbose

    if CTX.verbose and args.compileArgs:
        misc.echo(f"compileArgs: {args.compileArgs}")

    compileRoot = args.compileRoot or args.workRoot
    executeRoot = args.executeRoot or args.workRoot

    cgraph: CGraph = CGraph()

    # Set up compilation jobs
    compileCNodes: Dict[str, List[CNode]] = defaultdict(list)
    for n in range(args.nCompile):
        for case in args.cases:
            case, _ = case.rsplit(":", maxsplit=1)

            if len(compileCNodes[case]) != n:
                continue
            assert len(compileCNodes[case]) == n

            cDescr = CompileDescriptor(case)
            compileDir = os.path.join(compileRoot, cDescr.design, cDescr.config, f"compile-{n}")

            _, endNode = compile(cgraph, cDescr, compileDir, args.compileArgs)
            compileCNodes[case].append(endNode)

    # Set up execution jobs
    for n in range(args.nExecute):
        for case in args.cases:
            # Always use the first compile node
            compileNode = compileCNodes[case.rsplit(":", maxsplit=1)[0]][0]

            eDescr: ExecuteDescriptor = ExecuteDescriptor(case)
            compileDir = os.path.join(compileRoot, eDescr.design, eDescr.config, "compile-0")
            executeDir = os.path.join(
                executeRoot, eDescr.design, eDescr.config, f"execute-{n}", eDescr.test
            )

            startNode, _ = execute(cgraph, eDescr, compileDir, executeDir)
            cgraph.addEdge(compileNode, startNode)

    # Run the graph
    nodeStatus = cgraph.runAll(args.retry)

    # Report failures if any
    table = []
    for node, status in nodeStatus.items():
        if status == CStatus.FAILURE_NOW:
            table.append([node.description, misc.styled("Failed on this run", style="redBold")])
        elif status == CStatus.FAILURE_BEFORE:
            table.append([node.description, misc.styled("Failed on earlier run", style="red")])
        elif status == CStatus.FAILED_DEPENDENCY:
            table.append(
                [node.description, misc.styled("Skipped due to failed dependency", style="yellow")]
            )
    if table:
        misc.echo("Some steps have failed", style="redBold")
        print(tabulate.tabulate(table, headers=["Step", "Status"], tablefmt="plain"))
        sys.exit(1)
    misc.echo("All cases passed", style="greenBold")


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
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.set_defaults(entryPoint=main)
    parser.add_argument(
        "--cases",
        help="Cases to run",
        type=ArgPatternMatcher("cases", lambda: CTX.availableCases),
        required=True,
        metavar="CASES",
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
        default=[],
    )
    parser.add_argument(
        "--nCompile",
        help="Number of times to repeat compilation",
        type=ArgRangedInt(1, None),
        default=1,
        metavar="N",
    )
    parser.add_argument(
        "--nExecute",
        help="Number of times to repeat execution",
        type=ArgRangedInt(0, None),
        default=1,
        metavar="N",
    )
    parser.add_argument("--retry", help="Retry steps that failed earleir", action="store_true")
    parser.add_argument(
        "--trace", help="Generate waveform dumps", metavar="FORMAT", choices=["vcd", "fst"]
    )
    parser.add_argument("--verbose", help="Report more info about the process", action="store_true")
    parserWorkRootGroup = parser.add_argument_group("Options to specify working directory")
    parserWorkRootGroup.add_argument(
        "--compileRoot",
        help="Root of working directory for compilation only, value of --workRoot by default",
        type=os.path.abspath,
        metavar="DIR",
    )
    parserWorkRootGroup.add_argument(
        "--executeRoot",
        help="Root of working directory for execution only, value of --workRoot by default",
        type=os.path.abspath,
        metavar="DIR",
    )
    parserWorkRootGroup.add_argument(
        "--workRoot",
        help="Root of working directory for compilation and execution",
        type=os.path.abspath,
        default=CTX.defaultWorkDir,
        metavar="DIR",
    )
