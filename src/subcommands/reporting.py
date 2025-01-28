# Copyright (c) 2025, designbench contributors

import argparse
import os
import json
import sys

from typing import Dict, Final, List

import tabulate
tabulate.PRESERVE_WHITESPACE = True
import scipy.stats
import numpy as np

from context import ctx
import metrics
import misc


# Returns sample mean and it's confidence interval (or mean and None if there is only 1 sample)
def meanAndConfidenceInterval(samples, confidence=0.95):
    n = len(samples)
    assert n >= 1
    # Sample mean
    mean = float(np.mean(samples))
    if n == 1:
        return mean, None
    # Sample standard deviation
    stddev = np.std(samples, ddof=1)
    if stddev == 0:
        return mean, 0
    ci = float(scipy.stats.norm.interval(confidence=confidence, loc=0, scale=stddev/np.sqrt(n))[1])
    return mean, ci



def formatMeanAndConfidenceInterval(mean, ci):
    meanStr = f"{mean:0.2f}"
    if ci is None or mean == 0:
        return meanStr + " "*10
    # Convert to % of mean
    ci = 100.0*ci/mean
    # Colorize
    ciStr = misc.styleByInterval(
        f"(±{ci:5.2f}%)", ci,
        "greenBold", 0.25, "green", 0.05, "plain", 2.0, "red", 5.0, "redBold"
    )
    return f"{meanStr} {ciStr}"


_TABLE_FORMAT: Final = tabulate.TableFormat(
    lineabove=tabulate.Line("╒═", "═", "═╤═", "═╕"),
    linebelowheader=tabulate.Line("╞═", "═", "═╪═", "═╡"),
    linebelow=tabulate.Line("╘═", "═", "═╧═", "═╛"),
    headerrow=tabulate.DataRow("│ ", " │ ", " │"),
    datarow=tabulate.DataRow("│ ", " │ ", " │"),
    linebetweenrows=None,
    padding=0,
    with_header_hide=None,
)


def reportMain(args):
    allData = metrics.readAll(args.dir)

    for step in args.steps:
        # Build the tables
        table = []
        for case, caseData in allData.items():
            if step not in caseData:
                continue
            stepData = caseData[step]
            sampleSizes = set(len(_) for _ in stepData.values())
            assert len(sampleSizes), "Inconsitent sample count"

            row = [case, sampleSizes.pop()]
            for metric in args.metrics:
                mean, ci = meanAndConfidenceInterval(stepData[metric])
                row.append(formatMeanAndConfidenceInterval(mean, ci))
            table.append(row)

        if not table:
            continue

        # Print the tables
        headers = ["Case", "#"]
        for metric in args.metrics:
            headers.append(metrics.metricTitle(metric))

        print()
        print(misc.styled(step, style="bold"))
        print(tabulate.tabulate(
            table,
            headers=headers,
            tablefmt=_TABLE_FORMAT,
            disable_numparse=True,
            colalign=["left"] + ["right"] * (len(headers) - 1),
        ))


def compareMain(args):
    aAllData = metrics.readAll(args.aDir)
    bAllData = metrics.readAll(args.bDir)

    commonCases = sorted(_ for _ in aAllData if _ in bAllData)
    if not commonCases:
        print("No common cases between the runs")
        sys.exit(0)

    gainStyle = ("redBold", 0.9, "red", 0.95, "plain", 1.05, "green", 1.1, "greenBold")
    for step in args.steps:
        for metric in args.metrics:
            # Build the table
            table = []
            gains = []
            sigGains = []
            for case in commonCases:
                aCaseData = aAllData[case]
                bCaseData = bAllData[case]
                if step not in aCaseData or step not in bCaseData:
                    continue
                aStepData = aCaseData[step]
                bStepData = bCaseData[step]
                assert len(set(len(_) for _ in aStepData.values())), "Inconsitent sample count in A"
                assert len(set(len(_) for _ in bStepData.values())), "Inconsitent sample count in B"

                aData = aStepData[metric]
                bData = bStepData[metric]

                aN = len(aData)
                bN = len(bData)
                aMean = np.mean(aData)
                bMean = np.mean(bData)

                # Ignore cases with very small means (e.g.: example:* or *:hello)
                # These would have a big effect on 'gain' and hide the truth
                if aMean <= 1 or bMean <= 1:
                    continue

                gain = aMean/bMean
                gainStr = misc.styleByInterval(f"{gain:.2f}x", gain, *gainStyle)
                gains.append(gain)

                pVal = None
                pValStr = ""
                if aN >= 2 and bN >= 2:
                    # This performs Welch's t-test for the difference in population mean
                    welchTest = scipy.stats.ttest_ind(aData, bData, equal_var=False)
                    pVal = welchTest.pvalue
                    pValStr = misc.styleByInterval(
                        f"{pVal:.2f}", pVal,
                        "greenBold", 0.025, "green", 0.05, "plain", 0.1, "red", 0.2, "redBold"
                    )
                    if (pVal < 0.05):
                        sigGains.append(gain)

                table.append([
                    case,
                    len(aData),
                    len(bData),
                    formatMeanAndConfidenceInterval(*meanAndConfidenceInterval(aData)),
                    formatMeanAndConfidenceInterval(*meanAndConfidenceInterval(bData)),
                    gainStr,
                    pValStr
                ])

            if not table:
                continue

            table.append(tabulate.SEPARATING_LINE)
            meanGain = scipy.stats.gmean(gains)
            meanGainStr = misc.styleByInterval(f"{meanGain:.2f}x", meanGain, *gainStyle)
            table.append(["Geometic mean", "", "", "", "", meanGainStr, ""])
            if sigGains:
                meanGain = scipy.stats.gmean(sigGains)
                meanGainStr = misc.styleByInterval(f"{meanGain:.2f}x", meanGain, *gainStyle)
                table.append(["Geometic mean - pVal < 0.5", "", "", "", "", meanGainStr, ""])

            # Print the table
            print()
            print(misc.styled(f"{step} - {metrics.metricTitle(metric)}", style="bold"))
            print(tabulate.tabulate(
                table,
                headers=["Case", "#A", "#B", "Mean A", "Mean B", "Gain (A/B)", "p-value"],
                tablefmt=_TABLE_FORMAT,
                disable_numparse=True,
                colalign=["left"] + ["right"]*(len(table[0]) - 1),

            ))


def addSubcommands(subparsers) -> None:
    # Subcommand "report"
    reportParser: argparse.ArgumentParser = subparsers.add_parser(
        "report",
        help="Report metrics gathered in working directory",
        allow_abbrev=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    reportParser.set_defaults(entryPoint=reportMain)
    reportParser.add_argument(
        "--metrics",
        help="Metrics to report",
        default=["elapsed", "cpu", "memory"],
        nargs="+",
        metavar="METRIC"
    )
    reportParser.add_argument(
        "--steps",
        help="Steps to report",
        default=["verilate", "execute"],
        nargs="+",
        metavar="STEP"
    )
    reportParser.add_argument(
        "dir",
        help="Work directory of run",
        type=os.path.abspath,
        default=ctx.DEFAULT_WORK_DIR,
        metavar="DIR",
        nargs="?"
    )

    # Subcommand "compare"
    compareParser: argparse.ArgumentParser = subparsers.add_parser(
        "compare",
        help="Compare metrics in two different working directories",
        allow_abbrev=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    compareParser.set_defaults(entryPoint=compareMain)
    compareParser.add_argument(
        "--metrics",
        help="Metrics to compare",
        nargs="+",
        metavar="METRIC",
        default=["elapsed"]
    )
    compareParser.add_argument(
        "--steps",
        help="Steps to compare",
        nargs="+",
        metavar="SEP",
        default=["verilate", "execute"]
    )
    compareParser.add_argument("aDir",
        help="Working director of first run (A)",
        type=os.path.abspath,
        metavar="ADIR"
    )
    compareParser.add_argument("bDir",
        help="Working director of second run (B)",
        type=os.path.abspath,
        metavar="BDIR"
    )
