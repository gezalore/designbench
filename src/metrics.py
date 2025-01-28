
import json
import os

from typing import Callable, Dict, Final, List, Literal, Tuple


Step = Literal[
    "verilate",
    "cppbuild",
    "compile",
    "execute",
]


_STEPS: Final[Dict[Step, str]] = {
    "verilate" : "Running Verilator",
    "cppbuild" : "Compiling Verilator output into executable",
    "compile"  : "Combined verilate + cppbuild together",
    "execute"  : "Running simulation",
}


# Returns a short pretty description of the step
def stepDescription(step: Step) -> str:
    return _STEPS[step]


Metric = Literal[
    "elapsed",
    "cpu",
    "memory",
    "user",
    "system",
]


_METRICS: Final[Dict[Metric, Tuple[str, Callable[[float, float], float]]]] = {
    "elapsed" : ("Elapsed time [s]",    lambda a, b: a + b),
    "cpu"     : ("CPU Total [s]",       lambda a, b: a + b),
    "memory"  : ("Peak memory [MB]",    lambda a, b: max(a, b)),
    "user"    : ("CPU User [s]",        lambda a, b: a + b),
    "system"  : ("CPU System [s]",      lambda a, b: a + b),
}


# Returns a short pretty description of the metric
def metricTitle(metric: Metric) -> str:
    return _METRICS[metric][0]


# Combine two values of metric
def metricCombine(metirc: Metric, a: float, b: float) -> float:
    return _METRICS[metirc][1](a, b)


# Metrics are stored as a map from 'case' to 'step' to 'metric' to list of samples
type Metrics =  Dict[str, Dict[Step, Dict[Metric, List[float]]]]


# Read all metrics from the given working directory.
def readAll(rootDir: str) -> Metrics:
    # The result
    allMetrics: Metrics = {}
    # Return subdirectories sorted by name
    def sortedSubDirs(dir: str) -> List[os.DirEntry]:
        return sorted((_ for _ in os.scandir(dir) if _.is_dir()), key=lambda _: _.name)
    # Recursively gather all metrics from directories.
    # Does not descend further once some metrics have been found.
    def gatherMetrics(dirs: List[os.DirEntry]) -> None:
        bottom = False
        for dir in dirs:
            if not dir.name.startswith("_"):
                continue
            metricsFile = os.path.join(dir.path, "metrics.json")
            if not os.path.exists(metricsFile):
                continue
            # Do not descend beyond the step root, especially not into obj_dir, which is huge
            bottom = True
            with open(metricsFile, "r") as fd:
                allData = json.load(fd)
                for case, caseData in allData.items():
                    caseMetrics = allMetrics.setdefault(case, {})
                    for step, stepData in caseData.items():
                        stepMetrics = caseMetrics.setdefault(step, {})
                        for metric, value in stepData.items():
                            stepMetrics.setdefault(metric, []).append(value)
        if bottom:
            return
        # Descend
        for dir in dirs:
            gatherMetrics(sortedSubDirs(dir.path))
    # Gather from the root
    gatherMetrics(sortedSubDirs(rootDir))
    # Done
    return allMetrics

