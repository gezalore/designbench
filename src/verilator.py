# Copyright (c) 2025, designbench contributors

import json
import os

from typing import Final, List, Tuple

from cgraph import CGraph, CNode
from context import ctx
from descriptors import CompileDescriptor, ExecuteDescriptor
import misc
import metrics

_PREFIX: Final[str] = "Vsim"


def _verilate(
    cgraph: CGraph,
    descr: CompileDescriptor,
    compileDir: str,
    extraArgs: List[str]
) -> CNode:
    def job() -> bool:
        with misc.inDirectory(compileDir):
            cmd = ["verilator", "--cc", "--main", "--exe", "--timing",
                "--quiet-stats", "-Wno-fatal", "--prefix", _PREFIX]
            # Top module
            cmd.extend(["--top-module", descr.topModule]);
            # Verilog defines
            cmd.extend(f"+define+{k}={v}" for k, v in sorted(descr.verilogDefines.items()))
            # Verilog incdirs
            cmd.extend(f"+incdir+{item}" for item in sorted(descr.verilogIncdirs))
            # File list (via -f to save space on the command line)
            fileList = os.path.join(compileDir, "filelist.f")
            with open(fileList, "w") as fd:
                for fileName in descr.verilogFiles:
                    fd.write(f"{fileName}\n")
            cmd.extend(["-f", fileList])
            # Extra options from descriptor
            cmd.extend(descr.verilatorArgs)
            # Extra optoins from command line
            cmd.extend(extraArgs)
            # Run it
            tag = "verilate"
            status = misc.run(cmd, tag)
            if status.isSuccessNow():
                # On successfull run, gather some metrics
                with open(f"_{tag}/time.json", "r") as fd:
                    tData = json.load(fd)
                data = { descr.case : { tag : tData } }
                with open(f"_{tag}/metrics.json", "w") as fd:
                    json.dump(data, fd)
            return status.isSuccess()
    return cgraph.addNode(f"{descr.case} - Verilate", job)


def _cppbuild(
    cgraph: CGraph,
    descr: CompileDescriptor,
    compileDir: str
) -> CNode:
    def job() -> bool:
        with misc.inDirectory(compileDir):
            cmd = ["make", "-j", str(len(ctx.usableCpus)), "-C", "obj_dir", "-f", f"{_PREFIX}.mk"]
            # Run it
            tag = "cppbuild"
            status = misc.run(cmd, tag)
            if status.isSuccessNow():
                # On successfull run, gather some metrics
                with open(f"_{tag}/time.json", "r") as fd:
                    cData = json.load(fd)
                data = { descr.case : { tag : cData } }
                # Add combined 'verilate' + 'cppbuild'
                with open(f"_verilate/time.json", "r") as fd:
                    tData = json.load(fd)
                for k, v in cData.items():
                    tData[k] = metrics.metricCombine(k, tData[k], v)
                data[descr.case]["compile"] = tData
                with open(f"_{tag}/metrics.json", "w") as fd:
                    json.dump(data, fd)
            return status.isSuccess()
    return cgraph.addNode(f"{descr.case} - Build C++", job)


def compile(
    cgraph: CGraph,
    descr: CompileDescriptor,
    compileDir: str,
    extraArgs: List[str] = []
) -> Tuple[CNode, CNode]:
    verilateNode = _verilate(cgraph, descr, compileDir, extraArgs)
    cppbuildNode = _cppbuild(cgraph, descr, compileDir)
    cgraph.addEdge(verilateNode, cppbuildNode)
    return verilateNode, cppbuildNode


def execute(
    cgraph: CGraph,
    descr: ExecuteDescriptor,
    compileDir: str,
    executeDir: str
) -> Tuple[CNode, CNode]:
    def job() -> bool:
        with misc.inDirectory(executeDir):
            cmd = [os.path.join(compileDir, "obj_dir", _PREFIX), "+verilator+quiet"]
            cmd.extend(descr.executeArgs)
            # Run it
            tag = "execute"
            status = misc.run(cmd, tag)
            if status.isSuccessNow():
                # On successfull run, gather some metrics
                with open(f"_{tag}/time.json", "r") as fd:
                    tData = json.load(fd)
                data = { descr.case : { tag : tData } }
                with open(f"_{tag}/metrics.json", "w") as fd:
                    json.dump(data, fd)
            return status.isSuccess()
    node = cgraph.addNode( f"{descr.case} - Execute simulation", job)
    return node, node
