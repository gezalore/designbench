# Copyright (c) 2025, designbench contributors

import argparse
import os
import sys
from typing import Any, Final, List

import numpy as np
import scipy.stats
import tabulate
from sklearn.neighbors import LocalOutlierFactor

import metrics
import misc
from context import CTX
from subcommands.common import ArgExistingDirectory, ArgPatternMatcher, casesByTag

tabulate.PRESERVE_WHITESPACE = True


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
    ci = float(
        scipy.stats.norm.interval(confidence=confidence, loc=0, scale=stddev / np.sqrt(n))[1]
    )
    return mean, ci


def formatMeanAndConfidenceInterval(mean, ci):
    meanStr = f"{mean:0.2f}"
    if ci is None or mean == 0:
        return meanStr + " " * 10
    # Convert to % of mean
    ci = 100.0 * ci / mean
    # Colorize
    ciStr = misc.styleByInterval(
        f"(±{ci:5.2f}%)", ci, "greenBold", 0.25, "green", 0.05, "plain", 2.0, "red", 5.0, "redBold"
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


def reportMain(args: argparse.Namespace) -> None:
    allData = metrics.readAll(args.dir)

    cases = sorted(set(args.cases + [_.rpartition(":")[0] for _ in args.cases]))

    for step in args.steps:
        # Gather metrics available in this step
        availableMetrics = list(args.metrics)
        for case in cases:
            if case not in allData:
                continue
            caseData = allData[case]
            if step not in caseData:
                continue
            stepData = caseData[step]
            sampleSizes = set(len(_) for _ in stepData.values())
            assert len(sampleSizes) == 1, "Inconsistent sample count"
            availableMetrics = list(filter(stepData.__contains__, availableMetrics))
        if not availableMetrics:
            continue

        # Build the table
        table = []
        mDefs = [metrics.metricDef(_) for _ in availableMetrics]
        allRow = [_.identityValue for _ in mDefs]
        for case in cases:
            if case not in allData:
                continue
            caseData = allData[case]
            if step not in caseData:
                continue
            stepData = caseData[step]
            row = [case, len(stepData[availableMetrics[0]])]
            for i, metric in enumerate(availableMetrics):
                mean, ci = meanAndConfidenceInterval([_.value for _ in stepData[metric]])
                row.append(formatMeanAndConfidenceInterval(mean, ci))
                if (accumulate := mDefs[i].accumulate) is not None:
                    allRow[i] = accumulate(allRow[i], mean)
            table.append(row)

        if not table:
            continue

        table.append(tabulate.SEPARATING_LINE)
        table.append(
            ["All", ""]
            + [formatMeanAndConfidenceInterval(_, None) if _ is not None else "" for _ in allRow]
        )

        # Print the table
        headers = ["Case", "#"]
        for metric in availableMetrics:
            headers.append(metrics.metricDef(metric).header)

        print()
        print(misc.styled(step, style="bold"))
        print(
            tabulate.tabulate(
                table,
                headers=headers,
                tablefmt=_TABLE_FORMAT,
                disable_numparse=True,
                colalign=["left"] + ["right"] * (len(headers) - 1),
            )
        )


def compareMain(args: argparse.Namespace) -> None:
    aAllData = metrics.readAll(args.aDir)
    bAllData = metrics.readAll(args.bDir)

    cases = sorted(set(args.cases + [_.rpartition(":")[0] for _ in args.cases]))
    commonCases = sorted(_ for _ in cases if _ in aAllData and _ in bAllData)
    if not commonCases:
        print("No cases specified exist in both runs")
        sys.exit(0)

    gainStyle: Any = ("redBold", 0.9, "red", 0.95, "plain", 1.05, "green", 1.1, "greenBold")
    for step in args.steps:
        for metric in args.metrics:
            metricDef = metrics.metricDef(metric)
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
                assert len(set(len(_) for _ in aStepData.values())) == 1, (
                    "Inconsitent sample count in A"
                )
                assert len(set(len(_) for _ in bStepData.values())) == 1, (
                    "Inconsitent sample count in B"
                )
                if metric not in aStepData or metric not in bStepData:
                    continue
                aData = [_.value for _ in aStepData[metric]]
                bData = [_.value for _ in bStepData[metric]]

                aN = len(aData)
                bN = len(bData)
                aMean = np.mean(aData)
                bMean = np.mean(bData)

                # Ignore cases with very small means (e.g.: example:* or *:hello)
                # These would have a big effect on 'gain' and hide the truth
                if aMean <= 1 or bMean <= 1:
                    continue

                gain = bMean / aMean if metricDef.higherIsBetter else aMean / bMean
                gainStr = misc.styleByInterval(f"{gain:.2f}x", gain, *gainStyle)
                gains.append(gain)

                pValStr = ""
                if aN >= 2 and bN >= 2:
                    # Need to handle degenerate cases where all samples are the same.
                    # This can happen with coarse granularity metrics like memory usage.
                    allSameA = all(_ == aData[0] for _ in aData)
                    allSameB = all(_ == bData[0] for _ in bData)
                    if allSameA and allSameB:
                        pVal = 0.0 if aData[0] != bData[0] else 1.0
                    elif allSameA:
                        # t-test for difference of mean of B from constant A
                        pVal = scipy.stats.ttest_1samp(bData, aData[0], nan_policy="raise").pvalue
                    elif allSameB:
                        # t-test for difference of mean of A from constant B
                        pVal = scipy.stats.ttest_1samp(aData, bData[0], nan_policy="raise").pvalue
                    else:
                        # This performs Welch's t-test for the difference in population mean
                        pVal = scipy.stats.ttest_ind(
                            aData, bData, equal_var=False, nan_policy="raise"
                        ).pvalue
                    pValStr = misc.styleByInterval(
                        f"{pVal:.2f}",
                        pVal,
                        "greenBold",
                        0.025,
                        "green",
                        0.05,
                        "plain",
                        0.1,
                        "red",
                        0.2,
                        "redBold",
                    )
                    if pVal < 0.05:
                        sigGains.append(gain)

                table.append(
                    [
                        case,
                        len(aData),
                        len(bData),
                        formatMeanAndConfidenceInterval(*meanAndConfidenceInterval(aData)),
                        formatMeanAndConfidenceInterval(*meanAndConfidenceInterval(bData)),
                        gainStr,
                        pValStr,
                    ]
                )

            if not table:
                continue

            table.append(tabulate.SEPARATING_LINE)
            meanGain = scipy.stats.gmean(gains)
            meanGainStr = misc.styleByInterval(f"{meanGain:.2f}x", meanGain, *gainStyle)
            table.append(["Geometric mean", "", "", "", "", meanGainStr, ""])
            if sigGains:
                meanGain = scipy.stats.gmean(sigGains)
                meanGainStr = misc.styleByInterval(f"{meanGain:.2f}x", meanGain, *gainStyle)
                table.append(["Geometric mean - pVal < 0.05", "", "", "", "", meanGainStr, ""])

            # Print the table
            hilo = "higher" if metricDef.higherIsBetter else "lower"
            print()
            print(misc.styled(f"{step} - {metricDef.header} - {hilo} is better", style="bold"))
            print(
                tabulate.tabulate(
                    table,
                    headers=[
                        "Case",
                        "#A",
                        "#B",
                        "Mean A",
                        "Mean B",
                        f"Gain ({'B/A' if metricDef.higherIsBetter else 'A/B'})",
                        "p-value",
                    ],
                    tablefmt=_TABLE_FORMAT,
                    disable_numparse=True,
                    colalign=["left"] + ["right"] * (len(table[0]) - 1),
                )
            )


def rawdataMain(args: argparse.Namespace) -> None:
    allData = metrics.readAll(args.dir)

    cases = sorted(set(args.cases + [_.rpartition(":")[0] for _ in args.cases]))

    zIntervals: Any = ("plain", 1.0, "yellow", 2.0, "red", 3.0, "redBold")

    for step in args.steps:
        for metric in args.metrics:
            # Build the table
            table: List[list[str]] = []
            for case in cases:
                if case not in allData:
                    continue
                caseData = allData[case]
                if step not in caseData:
                    continue
                stepData = caseData[step]
                if metric not in stepData:
                    continue

                samples = stepData[metric]
                n = len(samples)
                # Make up some defautls that will display correctly if not enough samples
                zscores = [None for _ in samples]
                outlierVotes = [0 for _ in samples]
                if n >= 2:
                    zscores = scipy.stats.zscore(
                        [_.value for _ in samples], ddof=1, nan_policy="raise"
                    )
                if n >= 4:
                    # Add a bit of dithering to split quantized samples
                    rng = np.random.default_rng(seed=9876)
                    values = [[_.value + rng.normal(scale=1e-4)] for _ in samples]
                    # Run with up to 9 neighborhood sizes
                    minNeighbours = max(int(np.sqrt(n)), 3)
                    maxNeighbours = n - 1
                    for i in np.unique(np.linspace(minNeighbours, maxNeighbours, 9, dtype=int)):
                        lof = LocalOutlierFactor(n_neighbors=i, algorithm="brute")
                        for j, prediction in enumerate(lof.fit_predict(values)):
                            if prediction == -1:
                                outlierVotes[j] += 1

                if table:
                    table.append(tabulate.SEPARATING_LINE)
                for s, z, o in zip(samples, zscores, outlierVotes):
                    vStr = misc.styleByInterval(f"{s.value:0.2f}", np.abs(z or 0.0), *zIntervals)
                    zStr = f"{z:0.3f}" if z is not None else ""
                    table.append([case, vStr, zStr, "+" * o, os.path.relpath(s.file, args.dir)])

            if not table:
                continue

            # Print the table
            print()
            print(misc.styled(f"{step} - {metrics.metricDef(metric).header}", style="bold"))
            print(
                tabulate.tabulate(
                    table,
                    headers=["Case", "Value", "Z-score", "Outlier", "Metrics file"],
                    tablefmt=_TABLE_FORMAT,
                    disable_numparse=True,
                    colalign=["left", "right", "right", "right", "left"],
                )
            )


def addSubcommands(subparsers) -> None:
    # Subcommand "report"
    reportParser: argparse.ArgumentParser = subparsers.add_parser(
        "report",
        help="Report metrics gathered in working directory",
        allow_abbrev=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    reportParser.set_defaults(entryPoint=reportMain)
    reportParser.add_argument(
        "--cases",
        help="Report only the specified cases",
        type=ArgPatternMatcher("cases", lambda: CTX.availableCases, casesByTag),
        metavar="CASES",
        default="*",
    )
    reportParser.add_argument(
        "--metrics",
        help="Metrics to report",
        type=ArgPatternMatcher("metrics", metrics.METRICS.keys),
        metavar="METRICS",
        default="speed elapsed memory",
    )
    reportParser.add_argument(
        "--steps",
        help="Steps to report",
        type=ArgPatternMatcher("steps", metrics.STEPS.keys),
        metavar="STEPS",
        default="verilate execute",
    )
    reportParser.add_argument(
        "dir",
        help="Work directory of run",
        type=ArgExistingDirectory(),
        default=CTX.defaultWorkDir,
        metavar="DIR",
        nargs="?",
    )

    # Subcommand "compare"
    compareParser: argparse.ArgumentParser = subparsers.add_parser(
        "compare",
        help="Compare metrics in two different working directories",
        allow_abbrev=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    compareParser.set_defaults(entryPoint=compareMain)
    compareParser.add_argument(
        "--cases",
        help="Compare only the specified cases",
        type=ArgPatternMatcher("cases", lambda: CTX.availableCases, casesByTag),
        metavar="CASES",
        default="*",
    )
    compareParser.add_argument(
        "--metrics",
        help="Metrics to compare",
        type=ArgPatternMatcher("metrics", metrics.METRICS.keys),
        metavar="METRICS",
        default="elapsed",
    )
    compareParser.add_argument(
        "--steps",
        help="Steps to compare",
        type=ArgPatternMatcher("steps", metrics.STEPS.keys),
        metavar="STEPS",
        default="verilate execute",
    )
    compareParser.add_argument(
        "aDir",
        help="Working director of first run (A)",
        type=ArgExistingDirectory(),
        metavar="ADIR",
    )
    compareParser.add_argument(
        "bDir",
        help="Working director of second run (B)",
        type=ArgExistingDirectory(),
        metavar="BDIR",
    )

    # Subcommand "rawdata"
    rawdataParser: argparse.ArgumentParser = subparsers.add_parser(
        "rawdata",
        help="Display raw metrics gathered in working directory",
        allow_abbrev=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    rawdataParser.set_defaults(entryPoint=rawdataMain)
    rawdataParser.add_argument(
        "--cases",
        help="Report only the specified cases",
        type=ArgPatternMatcher("cases", lambda: CTX.availableCases, casesByTag),
        metavar="CASES",
        default="*",
    )
    rawdataParser.add_argument(
        "--metrics",
        help="Metrics to report",
        type=ArgPatternMatcher("metrics", metrics.METRICS.keys),
        metavar="METRICS",
        default="speed elapsed memory",
    )
    rawdataParser.add_argument(
        "--steps",
        help="Steps to report",
        type=ArgPatternMatcher("steps", metrics.STEPS.keys),
        metavar="STEPS",
        default="verilate execute",
    )
    rawdataParser.add_argument(
        "dir",
        help="Work directory of run",
        type=ArgExistingDirectory(),
        default=CTX.defaultWorkDir,
        metavar="DIR",
        nargs="?",
    )
