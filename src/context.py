# Copyright (c) 2025, designbench contributors

###############################################################################
# All global state in the program are contained in the singleton Context object
###############################################################################

import os
from functools import cached_property
from typing import Any, Dict, Final, List, final

import yaml_descriptor


@final
class Context:
    # Dump waveform traces in the specified format
    trace: str | None

    # Verbose mode enable
    verbose: bool

    def __init__(self) -> None:
        self.trace = None
        self.verbose = False

    # Absolute path to root of repository
    @cached_property
    def rootDir(self) -> str:
        value = os.environ["DESIGNBENCH_ROOT"]
        assert os.path.isabs(value), (
            "DESIGNBENCH_ROOT must be set to the absolute path to the root of designbench"
        )
        return value

    # Default working directory
    @cached_property
    def defaultWorkDir(self) -> str:
        return "work"

    # YAML descriptors as loaded from disk, indexed by design name
    @cached_property
    def descriptors(self) -> Dict[str, Dict[str, Any]]:
        designsDir = os.path.join(self.rootDir, "designs")
        value = {}
        for design in sorted(os.listdir(designsDir)):
            designDir = os.path.join(designsDir, design)
            fileName = os.path.join(designDir, "descriptor.yaml")
            if descr := yaml_descriptor.load(fileName):
                value[design] = descr
                value[design]["__file__"] = fileName
                value[design]["designDir"] = designDir
        return value

    # All available cases
    @cached_property
    def availableCases(self) -> List[str]:
        value = []
        for designName, desc in self.descriptors.items():
            for configName in desc["configurations"].keys():
                for testName in desc["tests"].keys():
                    value.append(f"{designName}:{configName}:{testName}")
        return sorted(value)

    # CPUs usable by this process
    @cached_property
    def usableCpus(self) -> List[int]:
        return sorted(_ for _ in os.sched_getaffinity(0))


CTX: Final[Context] = Context()
