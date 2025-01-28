import argparse
import os
import sys
import urllib
import urllib.request
from collections import Counter, defaultdict
from typing import Dict, Set

import misc
from case_descriptor import CompileDescriptor, ExecuteDescriptor
from context import CTX
from subcommands.common import ArgPatternMatcher


def checkFile(case: str, relFileName: str, absFileName: str, attrName: str) -> bool:
    if not os.path.exists(absFileName):
        misc.error(f"{case} - '{relFileName}' does not exist (from '{attrName}')")
        return True
    if not os.path.isfile(absFileName):
        misc.error(f"{case} - '{relFileName}' is not a regular file (from '{attrName}')")
        return True
    return False


def checkFileList(desc: CompileDescriptor | ExecuteDescriptor, attrName: str) -> bool:
    hasError = False
    seen: Dict[str, str] = {}
    for absFileName in getattr(desc, attrName):
        relFileName = os.path.relpath(absFileName, desc.designDir)
        hasError = checkFile(desc.case, relFileName, absFileName, attrName) or hasError
        baseName = os.path.basename(relFileName)
        if baseName in seen:
            hasError = True
            misc.error(f"{desc.case} - base name of files in '{attrName}' must be unique")
            misc.error(
                f"{' ' * len(desc.case)}   '{relFileName}' conflicts with '{seen[baseName]}'"
            )
        seen[baseName] = relFileName
    return hasError


def main(args: argparse.Namespace) -> None:
    hasError = False
    usedFiles: Dict[str, Set[str]] = defaultdict(set)

    doneDesign: Set[str] = set()
    doneCompileDescriptor: Set[str] = set()
    for case in args.cases:
        case, _ = case.rsplit(":", maxsplit=1)
        if case in doneCompileDescriptor:
            continue
        doneCompileDescriptor.add(case)

        cDescr = CompileDescriptor(case)
        hasError = checkFileList(cDescr, "verilogSourceFiles") or hasError
        hasError = checkFileList(cDescr, "verilogIncludeFiles") or hasError
        hasError = checkFileList(cDescr, "cppSourceFiles") or hasError
        hasError = checkFileList(cDescr, "cppIncludeFiles") or hasError
        usedFiles[cDescr.designDir].update(cDescr.verilogSourceFiles)
        usedFiles[cDescr.designDir].update(cDescr.verilogIncludeFiles)
        usedFiles[cDescr.designDir].update(cDescr.cppSourceFiles)
        usedFiles[cDescr.designDir].update(cDescr.cppIncludeFiles)

        design, _ = case.split(":")
        if design in doneDesign:
            continue
        doneDesign.add(design)

        for item in CTX.descriptors[design]["origin"]:
            repo = item["repository"]
            revision = item["revision"]
            license = item["license"]
            if repo != "local":
                try:
                    urllib.request.urlopen(repo)
                except:
                    hasError = True
                    misc.error(f"{design} - Cannot open repository URL: {repo}")
            if license != "local":
                try:
                    urllib.request.urlopen(license)
                except:
                    hasError = True
                    misc.error(f"{design} - Cannot open license URL: {license}")

    for case in args.cases:
        eDescr = ExecuteDescriptor(case)
        for absFileName, _ in eDescr.executeInputFiles.items():
            relFileName = os.path.relpath(absFileName, eDescr.designDir)
            hasError = checkFile(case, relFileName, absFileName, "executeInputFiles") or hasError
            usedFiles[eDescr.designDir].add(absFileName)

        if testPrepFile := eDescr.testPrep:
            relFileName = os.path.relpath(testPrepFile, eDescr.designDir)
            if checkFile(case, relFileName, testPrepFile, "testPrep"):
                hasError = True
            elif not os.access(testPrepFile, os.X_OK):
                hasError = True
                misc.error(f"{case} - '{relFileName}' is not executable (from 'testPrep')")
            usedFiles[eDescr.designDir].add(testPrepFile)

        if testPostFile := eDescr.testPost:
            relFileName = os.path.relpath(testPostFile, eDescr.designDir)
            if checkFile(case, relFileName, testPostFile, "testPost"):
                hasError = True
            elif not os.access(testPostFile, os.X_OK):
                hasError = True
                misc.error(f"{case} - '{relFileName}' is not executable (from 'testPost')")
            usedFiles[eDescr.designDir].add(testPostFile)

    # If checked all descriptors for a design, verify there are no stray files
    checkedDesigns = Counter(_.split(":")[0] for _ in args.cases)
    allDesigns = Counter(_.split(":")[0] for _ in CTX.availableCases)
    if all(allDesigns[k] == v for k, v in checkedDesigns.items()):
        for designDir in sorted(usedFiles):
            used = usedFiles[designDir]
            used.add(os.path.join(designDir, "descriptor.yaml"))
            for dirName, _, fileNames in os.walk(designDir):
                for fileName in fileNames:
                    absFileName = os.path.join(dirName, fileName)
                    if absFileName not in used:
                        hasError = True
                        relFileName = os.path.relpath(absFileName, CTX.rootDir)
                        misc.error(f"'{relFileName}' is not used by any case")

    if hasError:
        sys.exit(1)
    if len(args.cases) == len(CTX.availableCases):
        misc.echo("Everything seems to be in order", style="greenBold")


def addSubcommands(subParsers) -> None:
    # Subcommand "validate"
    parser: argparse.ArgumentParser = subParsers.add_parser(
        "validate",
        help="Validate case descriptors",
        allow_abbrev=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.set_defaults(entryPoint=main)
    parser.add_argument(
        "--cases",
        help="Cases to run",
        type=ArgPatternMatcher("cases", lambda: CTX.availableCases),
        metavar="CASES",
        default="*",
    )
