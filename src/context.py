# Copyright (c) 2025, designbench contributors

###############################################################################
# All global state in the program are contained in the singleton Context object
###############################################################################

import functools
import os

from typing import final, Any, Dict, Final, List

lazyProperty = lambda _: property(functools.cache(_))

@final
class Context:
    # Retry steps that failed on an earlier run
    retry: bool

    # Dump waveform traces in the specified format
    trace: str | None

    # Verbose mode enable
    verbose: bool

    def __init__(self) -> None:
        self.retry = False
        self.trace = None
        self.verbose = False

    # Absolute path to root of repository
    @lazyProperty
    def ROOT_DIR(self) -> str:
        value = os.environ["DESIGNBENCH_ROOT"]
        assert os.path.isabs(value), \
            "DESIGNBENCH_ROOT must be set to the absolute path to the root of designbench"
        return value

    # Absolute path of 'designs' directory
    @lazyProperty
    def DESIGNS_DIR(self) -> str:
        return os.path.join(self.ROOT_DIR, "designs")

    # Default working directory
    @lazyProperty
    def DEFAULT_WORK_DIR(self) -> str:
        return "work"

    # YAML descriptors as loaded from disk, indexed by design name
    @lazyProperty
    def descriptors(self) -> Dict[str, Dict[str, Any]]:
        from descriptors import loadRawDescriptor
        value = {}
        for design in sorted(os.listdir(self.DESIGNS_DIR)):
            designDir = os.path.join(self.DESIGNS_DIR, design)
            fileName = os.path.join(designDir, "descriptor.yaml")
            if descr := loadRawDescriptor(fileName):
                value[design] = descr
                value[design]["__file__"] = fileName
                value[design]["designDir"] = designDir
        return value

    # All available cases
    @lazyProperty
    def availableCases(self) -> List[str]:
        value = []
        for designName, desc in self.descriptors.items():
            for configName in desc["configurations"].keys():
                for testName in desc["tests"].keys():
                    value.append(f"{designName}:{configName}:{testName}")
        return sorted(value)

    # CPUs usable by this process
    @lazyProperty
    def usableCpus(self) -> List[int]:
        return sorted(_ for _ in os.sched_getaffinity(0))

ctx: Final[Context] = Context()