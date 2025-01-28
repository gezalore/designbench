# Copyright (c) 2025, designbench contributors

import itertools
import json
import os
from typing import Final, List, Tuple

import metrics
from case_descriptor import CompileDescriptor, ExecuteDescriptor
from cgraph import CGraph, CNode
from context import CTX
from runcmd import runcmd

_PREFIX: Final[str] = "Vsim"

flatten = itertools.chain.from_iterable


def _verilate(
    cgraph: CGraph, descr: CompileDescriptor, compileDir: str, extraArgs: List[str]
) -> CNode:
    step = "verilate"

    def job() -> bool:
        cmd = [
            "verilator",
            "--cc",
            "--main",
            "--exe",
            "--timing",
            "--quiet-stats",
            "-Wno-fatal",
            "--prefix",
            _PREFIX,
        ]
        # Top module
        cmd.extend(["--top-module", descr.topModule])
        # Verilog incdirs
        if descr.verilogIncludeFiles:
            cmd.append("+incdir+verilogIncludeFiles")
        # Verilog defines
        cmd.extend(f"+define+{k}={v}" for k, v in sorted(descr.verilogDefines.items()))
        # CPP incdirs
        if descr.cppIncludeFiles:
            cmd.extend(("-CFLAGS", "-I../cppIncludeFiles"))
        # CPP defines
        cmd.extend(flatten(("-CFLAGS", f"-D{k}={v}") for k, v in sorted(descr.cppDefines.items())))
        # File list (via -f to save space on the command line)
        fileList = "filelist"
        with open(fileList, "w", encoding="utf-8") as fd:
            for fileName in descr.verilogSourceFiles:
                fd.write(f"verilogSourceFiles/{os.path.basename(fileName)}\n")
            for fileName in descr.cppSourceFiles:
                fd.write(f"cppSourceFiles/{os.path.basename(fileName)}\n")
        cmd.extend(["-f", fileList])
        # Extra options from descriptor
        cmd.extend(descr.verilatorArgs)
        # Extra optoins from command line
        cmd.extend(extraArgs)
        # Run it
        if runcmd(cmd, step):
            # On successfull run, gather some metrics
            with open(f"_{step}/time.json", "r", encoding="utf-8") as fd:
                tData = json.load(fd)
            data = {descr.case: {step: tData}}
            with open(f"_{step}/metrics.json", "w", encoding="utf-8") as fd:
                json.dump(data, fd)
            return True
        # Command failed
        return False

    return cgraph.addNode(f"{descr.case} - Verilate", compileDir, step, job)


def _cppbuild(cgraph: CGraph, descr: CompileDescriptor, compileDir: str) -> CNode:
    step = "cppbuild"

    def job() -> bool:
        cmd = ["make", "-j", str(len(CTX.usableCpus)), "-C", "obj_dir", "-f", f"{_PREFIX}.mk"]
        # Run it
        if runcmd(cmd, step):
            # On successfull run, gather some metrics
            with open(f"_{step}/time.json", "r", encoding="utf-8") as fd:
                cData = json.load(fd)
            data = {descr.case: {step: cData}}
            # Add combined 'verilate' + 'cppbuild'
            with open("_verilate/time.json", "r", encoding="utf-8") as fd:
                tData = json.load(fd)
            for k, v in cData.items():
                if (accumulate := metrics.metricDef(k).accumulate) is not None:
                    tData[k] = accumulate(tData[k], v)
            data[descr.case]["compile"] = tData
            with open(f"_{step}/metrics.json", "w", encoding="utf-8") as fd:
                json.dump(data, fd)
            return True
        # Command failed
        return False

    return cgraph.addNode(f"{descr.case} - Build C++", compileDir, step, job)


def compile(
    cgraph: CGraph, descr: CompileDescriptor, compileDir: str, extraArgs: List[str]
) -> Tuple[CNode, CNode]:
    verilateNode = _verilate(cgraph, descr, compileDir, extraArgs)
    cppbuildNode = _cppbuild(cgraph, descr, compileDir)
    cgraph.addEdge(verilateNode, cppbuildNode)
    return verilateNode, cppbuildNode


def execute(
    cgraph: CGraph, descr: ExecuteDescriptor, compileDir: str, executeDir: str
) -> Tuple[CNode, CNode]:
    step = "execute"

    def job() -> bool:
        cmd = [os.path.join(compileDir, "obj_dir", _PREFIX), "+verilator+quiet"]
        cmd.extend(descr.executeArgs)
        # Run it
        if runcmd(cmd, step):
            # On successfull run, gather some metrics
            with open(f"_{step}/time.json", "r", encoding="utf-8") as fd:
                tData = json.load(fd)
            # Add design cycles
            with open("_designbench_cycles.txt", "r", encoding="utf-8") as fd:
                kiloCycles = int(fd.read()) / 1e3
                tData["speed"] = kiloCycles / tData["elapsed"]
            data = {descr.case: {step: tData}}
            with open(f"_{step}/metrics.json", "w", encoding="utf-8") as fd:
                json.dump(data, fd)
            return True
        # Command failed
        return False

    node = cgraph.addNode(f"{descr.case} - Execute simulation", executeDir, step, job)
    return node, node
