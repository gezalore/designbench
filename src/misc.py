# Copyright (c) 2025, designbench contributors

import contextlib
import enum
import json
import os
import subprocess
import sys
import time

from typing import final, Any, Dict, Final, Generator, List, Literal, NoReturn

import termcolor

from context import ctx

Style = Literal[
    "plain",
    "bold",
    "grey",
    "greyBold",
    "red",
    "redBold",
    "green",
    "greenBold",
    "yellow",
    "yellowBold",
    "blue",
    "blueBold",
    "magenta",
    "magentaBold",
    "cyan",
    "cyanBold",
]

_STYLE_TO_TERMCOLOR: Final[Dict[Style, Dict[str, Any]]] = {
    "plain"       : { "color": None         , "attrs": []},
    "bold"        : { "color": None         , "attrs": ["bold"]},
    "grey"        : { "color": "grey"       , "attrs": []},
    "greyBold"    : { "color": "grey"       , "attrs": ["bold"]},
    "red"         : { "color": "red"        , "attrs": []},
    "redBold"     : { "color": "red"        , "attrs": ["bold"]},
    "green"       : { "color": "green"      , "attrs": []},
    "greenBold"   : { "color": "green"      , "attrs": ["bold"]},
    "yellow"      : { "color": "yellow"     , "attrs": []},
    "yellowBold"  : { "color": "yellow"     , "attrs": ["bold"]},
    "blue"        : { "color": "blue"       , "attrs": []},
    "blueBold"    : { "color": "blue"       , "attrs": ["bold"]},
    "magenta"     : { "color": "magenta"    , "attrs": []},
    "magentaBold" : { "color": "magenta"    , "attrs": ["bold"]},
    "cyan"        : { "color": "cyan"       , "attrs": []},
    "cyanBold"    : { "color": "cyan"       , "attrs": ["bold"]},
}


def styled(text: str, style: Style="plain") -> str:
    return termcolor.colored(text, **_STYLE_TO_TERMCOLOR[style])


def echo(message: str, style: Style="plain") -> None:
    print(f"@@@ {styled(message, style=style)}")


def warning(message: str) -> None:
    echo(f"WARNING: {message}", style="yellow")


def error(message: str) -> None:
    echo(f"ERRROR: {message}", style="red")


def fatal(message: str) -> NoReturn:
    echo(f"FATAL: {message}", style="redBold")
    sys.exit(1)


def styleByInterval(
    text: str, # Text to style
    value: float, # Discriminator value
    firstStyle: Style,
    *limitsAndStyles: float | Style, # alternating (limit, Style) pairs
) -> str:
    prevLimit = float("-inf")
    it = iter((firstStyle,) + limitsAndStyles + (float("inf"),))
    for style, limit in zip(it, it):
        assert isinstance(style, str) and isinstance(limit, float), \
               "limitsAndStyles must be an alternating sequence of float limits and styles"
        assert prevLimit < limit, "Limits must be ascending"
        if value < limit:
            return termcolor.colored(text, **_STYLE_TO_TERMCOLOR[style])
    raise ValueError(f"limit {value} is not welld defined")


@contextlib.contextmanager
def inDirectory(dir: str) -> Generator:
    prevDir = os.getcwd()
    os.makedirs(dir, exist_ok=True)
    os.chdir(dir)
    try:
        yield
    finally:
        os.chdir(prevDir)


_TIMEFORMAT: Final[str] = """{
    "elapsed" : %e,
    "user" : %U,
    "system" : %S,
    "memory" : %M
}
"""


@final
@enum.unique
class RunResult(enum.Enum):
    SUCCESS_NOW = enum.auto()
    SUCCESS_BEFORE = enum.auto()
    FAILURE_NOW = enum.auto()
    FAILURE_BEFORE = enum.auto()

    def isSuccess(self) -> bool:
        if self == RunResult.SUCCESS_NOW:
            return True
        if self == RunResult.SUCCESS_BEFORE:
            return True
        return False

    def isSuccessNow(self) -> bool:
        return self == RunResult.SUCCESS_NOW


def run(
    cmd: List[str], # Command + arguments
    tag: str,       # Tag string to use for log and marker files
) -> RunResult:
    tagDir = f"_{tag}"
    os.makedirs(tagDir, exist_ok=True)
    statusFile = os.path.join(tagDir, "status")

    # Check if this command was already done on an earlier run
    if os.path.exists(statusFile):
        with open(statusFile) as fd:
            status = int(fd.read())
            if status == 0:
                echo(f"Skipped due to success on earlier run", style="green")
                return RunResult.SUCCESS_BEFORE
            if not ctx.retry:
                echo(f"Skipped due to failure on earlier run", style="red")
                return RunResult.FAILURE_BEFORE
            else:
                echo(f"Retrying after failure on earlier run", style="yellow")

    # Write the command out for easier debugging of the steps
    with open(os.path.join(tagDir, "cmd"), "w") as cmdFile:
        iterator = iter(cmd)
        cmdFile.write(f"{next(iterator)} \\\n")
        for item in iterator:
            cmdFile.write(f"    '{item}' \\\n")

    cwd = os.getcwd()
    logFile = os.path.join(tagDir, "stdout.log")

    # Tell the user how to reproduce the step
    echo(f"CWD: {cwd}")
    echo(f"LOG: {os.path.join(cwd, logFile)}")
    echo(f"CMD: {" ".join(cmd)}", style="magenta")

    timeFile = os.path.join(tagDir, f"time.json")

    cmd = ["time", "-o", timeFile, "-f", _TIMEFORMAT] + cmd

    startTime = time.monotonic_ns()

    # Start the process
    process = subprocess.Popen(
        args=cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True
    )
    assert process.stdout

    # Gather stdout/stderr into the logfile, prefixed by time stamps for each line
    with open(logFile, "w") as fd:
        for line in process.stdout:
            timeStamp = (time.monotonic_ns() - startTime)/1e9
            line = "{:8.2f} | {}".format(timeStamp, line)
            fd.write(line)
            if ctx.verbose:
                print(line, end="")

    status = process.wait()

    # Write the status out
    print(statusFile)
    with open(statusFile, "w") as fd:
        fd.write(str(status))

    if status != 0:
        echo("=== FAILED ===", style="red")
        return RunResult.FAILURE_NOW

    # Tweak the data recorded by 'time'
    with open(timeFile, "r") as fd:
        tData = json.load(fd)
        # Add 'user' + 'system' time as total 'cpu' time
        tData["cpu"] = tData["user"] + tData["system"]
        # Adjust 'memory to be in MB instead of KB
        tData["memory"] *= 1e-3
    with open(timeFile, "w") as fd:
        json.dump(tData, fd)

    echo("=== Success ===", style="green")
    return RunResult.SUCCESS_NOW
