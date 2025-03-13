# Copyright (c) 2025, designbench contributors

import json
import os
import shlex
import subprocess
import time
from typing import Dict, Final, List

import misc
from context import CTX

_TIMEFORMAT: Final[str] = """{
    "elapsed" : %e,
    "user" : %U,
    "system" : %S,
    "memory" : %M
}
"""


def runcmd(
    cmd: List[str],  # Command + arguments
    tag: str,  # Tag string to use for log and marker files
    extraEnv: Dict[str, str] | None = None,  # Additional environment variables
) -> bool:
    tagDir = f"_{tag}"
    os.makedirs(tagDir, exist_ok=True)

    # Write the command out for easier debugging of the steps
    with open(os.path.join(tagDir, "cmd"), "w", encoding="utf-8") as cmdFile:
        iterator = iter(cmd)
        cmdFile.write(shlex.quote(next(iterator)))
        for word in iterator:
            cmdFile.write(" ")
            cmdFile.write(shlex.quote(word))

    # Add extraEnv
    env = os.environ.copy()
    if extraEnv is not None:
        env.update(extraEnv)

    cwd = os.getcwd()
    logFile = os.path.join(tagDir, "stdout.log")

    # Tell the user where the stdout log is, and how they can reproduce the command
    misc.echo(f"CWD: {cwd}")
    misc.echo(f"LOG: {os.path.join(cwd, logFile)}")
    misc.echo(f"CMD: {' '.join(map(shlex.quote, cmd))}", style="magenta")

    # Add 'time' prefix
    timeFile = os.path.join(tagDir, "time.json")
    cmd = ["time", "-o", timeFile, "-f", _TIMEFORMAT] + cmd

    # Base of time stamps in stdout log
    startTime = time.monotonic_ns()

    # Start the process
    with subprocess.Popen(
        args=cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        encoding="utf-8",
        env=env,
    ) as process:
        # Gather stdout/stderr into the logfile, prefixed by time stamps for each line
        with open(logFile, "w", encoding="utf-8") as fd:
            assert process.stdout, "stdout is None"
            for line in process.stdout:
                timeStamp = (time.monotonic_ns() - startTime) / 1e9
                line = f"{timeStamp:8.2f} | {line}"
                fd.write(line)
                if CTX.verbose:
                    print(line, end="")

    # If failed, we are done
    if process.returncode != 0:
        return False

    # Tweak the data recorded by 'time'
    with open(timeFile, "r", encoding="utf-8") as fd:
        tData = json.load(fd)
        # Add 'user' + 'system' time as total 'cpu' time
        tData["cpu"] = tData["user"] + tData["system"]
        # Adjust 'memory to be in MB instead of KB
        tData["memory"] *= 1e-3
        # Make sure values are non-zero to avoid division by zero later
        tData = {k: max(v, 1e-2) for k, v in tData.items()}
    with open(timeFile, "w", encoding="utf-8") as fd:
        json.dump(tData, fd)

    # Finished successfully
    return True
