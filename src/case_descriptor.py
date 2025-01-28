# Copyright (c) 2025, designbench contributors

import os
from dataclasses import dataclass
from typing import Any, Dict, List, final

import misc
from context import CTX


# Get scalar attribute from the last descriptor that contains it, later overwrites earlier
def _gatherScalar(key: str, *descs: dict[str, Any]) -> str | None:
    result: str | None = None
    for desc in descs:
        if (value := desc.get(key)) is not None:
            result = str(value)
    return result


# Get list attribute from desciptors, concatenationg them in order
def _gatherList(key: str, *descs: dict[str, Any]) -> List[str]:
    result: List[str] = []
    for desc in descs:
        result.extend(str(_) for _ in desc.get(key, []))
    return result


# Get dict attribute from desciptors, overriding earlier entries with keter entries
def _gatherDict(key: str, *descs: dict[str, Any]) -> Dict[str, str]:
    result: Dict[str, str] = {}
    for desc in descs:
        result.update((k, str(v)) for k, v in desc.get(key, {}).items())
    return result


@final
@dataclass(init=False)
class CompileDescriptor:
    case: str
    design: str
    config: str

    designDir: str

    verilogSourceFiles: List[str]
    verilogIncludeFiles: List[str]
    verilogDefines: Dict[str, str]

    cppSourceFiles: List[str]
    cppIncludeFiles: List[str]
    cppDefines: Dict[str, str]

    topModule: str

    verilatorArgs: List[str]

    trace: str | None

    def __init__(self, case: str) -> None:
        self.design, self.config = case.split(":")
        self.case = case

        yamlDesc = CTX.descriptors[self.design]
        designDesc = yamlDesc["design"] or {}
        configDesc = yamlDesc["configurations"][self.config] or {}

        gatherScalar = lambda _: _gatherScalar(_, designDesc, configDesc)
        gatherList = lambda _: _gatherList(_, designDesc, configDesc)
        gatherDict = lambda _: _gatherDict(_, designDesc, configDesc)

        self.designDir = yamlDesc["designDir"]

        # verilogSourceFiles are optional
        self.verilogSourceFiles = [
            os.path.join(self.designDir, _) for _ in gatherList("verilogSourceFiles")
        ]
        self.verilogSourceFiles.append(os.path.join(CTX.rootDir, "rtl", "__designbench_utils.sv"))
        # verilogIncludeFiles are optional
        self.verilogIncludeFiles = [
            os.path.join(self.designDir, _) for _ in gatherList("verilogIncludeFiles")
        ]
        self.verilogIncludeFiles.append(
            os.path.join(CTX.rootDir, "rtl", "__designbench_top_include.vh")
        )
        # verilogDefines are optional
        self.verilogDefines = gatherDict("verilogDefines")

        # cppSourceFiles are optional
        self.cppSourceFiles = [
            os.path.join(self.designDir, _) for _ in gatherList("cppSourceFiles")
        ]
        # cppIncludeFiles are optional
        self.cppIncludeFiles = [
            os.path.join(self.designDir, _) for _ in gatherList("cppIncludeFiles")
        ]
        # cppDefines are optional
        self.cppDefines = gatherDict("cppDefines")

        # topModule is required
        if (value := gatherScalar("topModule")) is not None:
            self.topModule = value
        else:
            misc.fatal(f"{yamlDesc['__file__']} does not specify 'topModule'")

        # mainClock is required
        if (value := gatherScalar("mainClock")) is not None:
            self.verilogDefines["__DESIGNBENCH_MAIN_CLK"] = value
        else:
            misc.fatal(f"{yamlDesc['__file__']} does not specify 'mainClock'")

        # verilatorArgs are optional
        self.verilatorArgs = gatherList("verilatorArgs")

        # Add tracing options handled by us directly
        if CTX.trace:
            self.trace = CTX.trace
            self.verilogDefines["__DESIGNBENCH_TRACE"] = "1"
            self.verilogDefines[f"__DESIGNBENCH_TRACE_{CTX.trace.upper()}"] = "1"


@final
@dataclass(init=False)
class ExecuteDescriptor:
    case: str
    design: str
    config: str
    test: str

    designDir: str

    testPrep: str | None
    testPost: str | None

    executeInputFiles: Dict[str, str]
    executeArgs: List[str]

    def __init__(self, case: str) -> None:
        self.design, self.config, self.test = case.split(":")
        self.case = f"{self.design}:{self.config}:{self.test}"

        yamlDesc = CTX.descriptors[self.design]
        designDesc = yamlDesc["design"] or {}
        configDesc = yamlDesc["configurations"][self.config] or {}
        testDesc = yamlDesc["tests"][self.test] or {}

        gatherScalar = lambda _: _gatherScalar(_, designDesc, configDesc, testDesc)
        gatherList = lambda _: _gatherList(_, designDesc, configDesc, testDesc)
        gatherDict = lambda _: _gatherDict(_, designDesc, configDesc, testDesc)

        self.designDir = yamlDesc["designDir"]

        # testPrep is optional
        if (value := gatherScalar("testPrep")) is not None:
            self.testPrep = os.path.join(self.designDir, value)
        else:
            self.testPrep = None

        # testPost is optional
        if (value := gatherScalar("testPost")) is not None:
            self.testPost = os.path.join(self.designDir, value)
        else:
            self.testPost = None

        # executeInputFiles are optional
        self.executeInputFiles = {
            os.path.join(self.designDir, k): v for k, v in gatherDict("executeInputFiles").items()
        }

        # args are optional
        self.executeArgs = gatherList("executeArgs")
