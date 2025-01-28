# Copyright (c) 2025, designbench contributors

import os
from typing import Any, Dict, Final

import jsonschema
import yaml

import misc

_DESIGN_AND_CONFIG_BOTH_MISSING_ERROR: Final = (
    "If '{}' is not set in 'design', then it must be set in all 'configurations'"
)

_VALIDATOR: Final = jsonschema.Draft202012Validator(
    yaml.safe_load(f"""
# subschemas for later use
$defs:
    # Descriptor for 'compile' step
    compileDescriptor:
        type: object
        properties:
            verilogSourceFiles:
                type: array
                items:
                    type: string
                uniqueItems: true
            verilogIncludeFiles:
                type: array
                items:
                    type: string
                uniqueItems: true
            verilogDefines:
                type: object
                additionalProperties:
                    type: [ string, number ]
            cppSourceFiles:
                type: array
                items:
                    type: string
                uniqueItems: true
            cppIncludeFiles:
                type: array
                items:
                    type: string
                uniqueItems: true
            cppDefines:
                type: object
                additionalProperties:
                    type: [ string, number ]
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
            executeInputFiles:
                type: object
                additionalProperties:
                    type: string
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
        type: array
        items:
            type: object
            properties:
                repository:
                    type: string
                revision:
                    type: [ string, integer ]
                license:
                    type: string
            required:
                - repository
                - revision
                - license
            additionalProperties: false
        minItems: 1
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
            errorMessage: {_DESIGN_AND_CONFIG_BOTH_MISSING_ERROR.format("topModule")}
    - $id: mainClockMustBeDefined
      $ref: ifNotDesignThenConfigMustSatisfy
      $defs:
        constraint:
            $dynamicAnchor: Schema
            type: object
            required: [ mainClock ]
            errorMessage: {_DESIGN_AND_CONFIG_BOTH_MISSING_ERROR.format("mainClock")}
""")
)


# Load and validate a raw yaml descriptor. Return None if invalid
def load(fileName) -> Dict[str, Any] | None:
    if not os.path.exists(fileName):
        misc.fatal(f"Design descriptor does not exists: {fileName}")

    with open(fileName, "r", encoding="utf-8") as f:
        desc = yaml.safe_load(f)

    if errors := list(_VALIDATOR.iter_errors(desc)):
        misc.error(f"Invalid descriptor: {fileName}")
        for e in errors:
            message = "".join(e.schema.get("errorMessage", [e.message]))
            misc.echo(f"{e.json_path}: {message}")
        return None
    return desc
