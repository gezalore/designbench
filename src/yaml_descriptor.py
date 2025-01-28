# Copyright (c) 2025, designbench contributors

import functools
import importlib.resources
import os
from typing import Any, Dict

import jsonschema
import yaml

import misc


# Load schema and compile validator
@functools.cache
def _validator():
    with (importlib.resources.files() / "schema.yaml").open("r", encoding="utf-8") as f:
        textSchema = f.read()
        yamlSchema = yaml.safe_load(textSchema)
        yamlSchema = {key: val for key, val in yamlSchema.items() if not key.startswith("_")}
        return jsonschema.Draft202012Validator(yamlSchema)


# Add/normalize defaults
def _applyDefaults(desc: Dict[str, Any]) -> Dict[str, Any]:
    # YAML produces absent mapped values as 'None', we want them to be {}.
    desc["compile"] = desc.get("compile") or {}
    desc["execute"] = desc.get("execute") or {}
    desc["execute"]["common"] = desc["execute"].get("common") or {}
    desc["execute"]["tests"] = desc["execute"].get("tests") or {}
    desc["execute"]["tests"] = {k: v or {} for k, v in desc["execute"]["tests"].items()}
    return desc


# Load and validate a raw yaml descriptor. Return None if invalid
def load(fileName) -> Dict[str, Any] | None:
    if not os.path.exists(fileName):
        misc.fatal(f"Design descriptor does not exists: {fileName}")

    # Parse
    with open(fileName, "r", encoding="utf-8") as f:
        desc = yaml.safe_load(f)

    # Validate
    if errors := list(_validator().iter_errors(desc)):
        misc.error(f"Invalid design descriptor: {fileName}")
        for e in errors:
            message = "".join(e.schema.get("errorMessage", [e.message]))
            misc.echo(f"{e.json_path}: {message}")
        return None

    # Normalzie
    desc = _applyDefaults(desc)
    desc["configurations"] = {
        k: _applyDefaults(v or {}) for k, v in desc.get("configurations", {"default": {}}).items()
    }

    # Done
    return desc
