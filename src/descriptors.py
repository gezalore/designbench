# Copyright (c) 2025, designbench contributors

import os

from dataclasses import dataclass
from typing import final, Any, Dict, List, Final

import jsonschema
import yaml


from context import ctx
import misc

_designAndConfigBothMissingError: Final = \
    "If '{}' is not set in 'design', then it must be set in all 'configurations'"

_validator: Final= jsonschema.Draft202012Validator(yaml.safe_load(f"""
# subschemas for later use
$defs:
    # Descriptor for 'compile' step
    compileDescriptor:
        type: object
        properties:
            verilogFiles:
                type: array
                items:
                    type: string
                uniqueItems: true
                minItems: 1
            verilogDefines:
                type: object
                additionalProperties:
                    type: [ string, number ]
            verilogIncdirs:
                type: array
                items:
                    type: string
                uniqueItems: true
            topModule:
                type: string
            mainClock:
                type: string
            verilatorArgs:
                type: array
                items:
                    type: [ string, number ]
    # Descriptor for 'execute' step
    executeDescriptor:
        type: object
        properties:
            testPrep:
                type: string
            testPost:
                type: string
            executeArgs:
                type: array
                items:
                    type: [ string, number ]
    # Helper to enforce either the 'design' or all configurations satisfy a schema
    ifNotDesignThenConfigMustSatisfy:
        $id: ifNotDesignThenConfigMustSatisfy
        if:
            not:
                properties:
                    design:
                        $dynamicRef: "#Schema"
        then:
            properties:
                configurations:
                    additionalProperties:
                        $dynamicRef: "#Schema"
        $defs:
            constraint:
                $dynamicAnchor: Schema
                not: true

# Schema for root
type: object
properties:
    origin:
        type: object
        properties:
            repository:
                type: string
            revision:
                type: [ string, integer ]
        required:
            - repository
            - revision
        additionalProperties: false
    design:
        allOf:
            - $ref: "#/$defs/compileDescriptor"
            - $ref: "#/$defs/executeDescriptor"
        unevaluatedProperties: false
    configurations:
        type: object
        minProperties: 1
        additionalProperties:
            if:
                not:
                    type: "null"
            then:
                allOf:
                    - $ref: "#/$defs/compileDescriptor"
                    - $ref: "#/$defs/executeDescriptor"
                unevaluatedProperties: false
    tests:
        type: object
        minProperties: 1
        additionalProperties:
            if:
                not:
                    type: "null"
            then:
                $ref: "#/$defs/executeDescriptor"
                unevaluatedProperties: false
required:
    - origin
    - design
    - configurations
    - tests
additionalProperties: false

allOf:
    - $id: topModuleMustBeDefined
      $ref: ifNotDesignThenConfigMustSatisfy
      $defs:
        constraint:
            $dynamicAnchor: Schema
            type: object
            required: [ topModule ]
            errorMessage: {_designAndConfigBothMissingError.format("topModule")}
    - $id: mainClockMustBeDefined
      $ref: ifNotDesignThenConfigMustSatisfy
      $defs:
        constraint:
            $dynamicAnchor: Schema
            type: object
            required: [ mainClock ]
            errorMessage: {_designAndConfigBothMissingError.format("mainClock")}
    - $id: verilogFilesMustBeDefined
      $ref: ifNotDesignThenConfigMustSatisfy
      $defs:
        constraint:
            $dynamicAnchor: Schema
            type: object
            required: [ verilogFiles ]
            errorMessage: {_designAndConfigBothMissingError.format("verilogFiles")}
"""))


# Validate a raw yaml descriptor, die if invaid
def loadRawDescriptor(fileName) -> Dict[str, Any] | None:
    if not os.path.exists(fileName):
        misc.fatal(f"Design descriptor does not exists: {fileName}")

    with open(fileName) as f:
        desc = yaml.safe_load(f)

    if errors := list(_validator.iter_errors(desc)):
        misc.error(f"Invalid descriptor: {fileName}")
        for e in errors:
            message = "".join(e.schema.get("errorMessage", [e.message]))
            misc.echo(f"{e.json_path}: {message}")
        return None
    return desc


# Get scalar attribute from the last descriptor that contains it, later overwrites earlier
def _gatherScalar(key: str, *descs: dict[str, Any]) -> str | None:
    result : str | None = None
    for desc in descs:
        if (value := desc.get(key,)) is not None:
            result = str(value)
    return result


# Get list attribute from desciptors, concatenationg them in order
def _gatherList(key: str, *descs: dict[str, Any]) -> List[str]:
    result : List[str] = []
    for desc in descs:
        result.extend(str(_) for _ in desc.get(key, []))
    return result


# Get dict attribute from desciptors, overriding earlier entries with keter entries
def _gatherDict(key: str, *descs: dict[str, Any]) -> Dict[str, str]:
    result : Dict[str, str] = {}
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

    topModule: str

    verilogFiles: List[str]
    verilogIncdirs: List[str]
    verilogDefines: Dict[str, str]

    verilatorArgs: List[str]

    def __init__(self, case: str) -> None:
        self.design, self.config = case.split(":")
        self.case = case

        yamlDesc = ctx.descriptors[self.design]
        designDesc = yamlDesc["design"] or {}
        configDesc = yamlDesc["configurations"][self.config] or {}

        gatherScalar = lambda _: _gatherScalar(_, designDesc, configDesc)
        gatherList = lambda _: _gatherList(_, designDesc, configDesc)
        gatherDict = lambda _: _gatherDict(_, designDesc, configDesc)

        self.designDir = yamlDesc["designDir"]

        # topModule is required
        if (value := gatherScalar("topModule")) is not None:
            self.topModule = value
        else:
            misc.fatal(f"{yamlDesc["__file__"]} does not specify 'topModule'")


        # verilogFiles must be non-empty
        if values := gatherList("verilogFiles"):
            self.verilogFiles = [ os.path.join(self.designDir, _) for _ in  values]
        else:
            misc.fatal(f"{yamlDesc["__file__"]} does not specify any 'verilogFiles'")
        self.verilogFiles.append(os.path.join(ctx.ROOT_DIR, "rtl", "__designbench_misc.sv"))

        # verilogIncdirs are optional
        self.verilogIncdirs = [ os.path.join(self.designDir, _) for _ in gatherList("verilogIncdirs") ]
        self.verilogIncdirs.append(os.path.join(ctx.ROOT_DIR, "rtl"))

        # verilogDefines are optional
        self.verilogDefines = gatherDict("verilogDefines")

        # mainClock is required
        if (value := gatherScalar("mainClock")) is not None:
            self.verilogDefines["__DESIGNBENCH_MAIN_CLK"] = value
        else:
            misc.fatal(f"{yamlDesc["__file__"]} does not specify 'mainClock'")

        # verilatorArgs are optional
        self.verilatorArgs = gatherList("verilatorArgs")

        # Add tracing options handled by us directly
        if ctx.trace:
            self.verilogDefines["__DESIGNBENCH_TRACE"] = "1"
            self.verilogDefines[f"__DESIGNBENCH_TRACE_{ctx.trace.upper()}"] = "1"
            if ctx.trace == "vcd":
                self.verilatorArgs.append("--trace")
            else:
                self.verilatorArgs.append("--trace-fst")


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
    executeArgs: List[str]

    def __init__(self, case: str) -> None:
        self.design, self.config, self.test = case.split(":")
        self.case = f"{self.design}:{self.config}:{self.test}"

        yamlDesc = ctx.descriptors[self.design]
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

        # args are optional
        self.executeArgs = gatherList("executeArgs")
