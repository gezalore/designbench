

# Verilator performance test suite

This repository contains `designbench`, a collection of benchmarks and tools
for performance evaluation of Verilator.

The goal of `designbench` is to produce accurate and reproducible performance
metrics, which can be used to evaluate the performance of Verilator, and to
evaluate the effect of changes, options or other relevant differences in the
environment.

## License

In order to keep `designbench` easily usable, the `designs` subdirectory
contains code imported from open source repositories (with some local
modifications). Copyright of these resides with their respective authors,
and their licenses are available in their upstream repositories as reported
by `./designbench show --designs`.

For everything else see [LICENSE](LICENSE).

## Dependencies

We try to keep external dependencies to a minimum. You will need the following
available through $PATH:
- An installation of Verilator
- Make (which Verilator requires anyway)
- Python 3.9 or newer

Python dependencies are manged through a virtual environment (in the `venv`
subdirectory) that you can automatically set up by running the following
command once after pulling the repository:

```shell
make venv
```

## Usage

All running and reporting is done via the `designbench` executable. You can
view the subcommands via `./designbench --help`, and the command-line help for
each subcommand using `./designbench <SUBCOMMAND> --help`.

### Organization of cases

Each benchmark is identified by as a string `<DESIGN>:<CONFIGURATION>:<TEST>`
triplet, which is referred to as a 'case'.

To see all available cases run `./designbench show --cases`

`<DESIGN>` names a design. All inputs (Verilog sources, tool and run-time
options, run-time inputs, etc.) for a given design are located in the
corresponding subdirectory in `designs/<DESIGN>`.

Each design can have multiple configurations, named by `<CONFIGURATION>`.
Different configurations of the same design usually share a set of inputs.

The `<DESIGN>:<CONFIGURATION>` pair uniquely determines the inputs to
compilation and correspond to a single simulator executable used for the case.

The `<TEST>` part names the test, which determines the run-time inputs used
for the simulation. All cases with the same `<DESIGN>:<CONFIGURATION>`, but
different `<TEST>` are run using the same simulator executable, but with
different run-time inputs.

Cases for each design are defined via a YAML descriptor that you can find at
`designs/<DESIGN>/descriptor.yaml`.

### Running benchmarks

To run some benchmarks, use the `./designbench run` command. For example, to
run the case `OpenTitan:default:hello`, you can use

```shell
./designbench run --cases OpenTitan:default:hello
```

By default this will compile the `OpenTitan:default` configuration, and then
executes the `OpenTitan:default:hello` test, which should take a few minutes.
All artifacts are placed under the working directory, which defaults to `work`.

See `./designbench run --help` for additional options.

For each step involving an external command, designbench prints the working
directory (CWD), command line (CMD), and the location of the log file holding
the stdout/stderr produced by the command (LOG). For example, the run
above will print something like:

```
@@@ OpenTitan:default - Verilate
@@@ CWD: work/OpenTitan/default/compile-0
@@@ LOG: work/OpenTitan/default/compile-0/_verilate/stdout.log
@@@ CMD: verilator --cc --main --exe <BUNCH> <OF> <BUNCH>
```

The intention here is to make it easy to reproduce the step manually. You
should be able to `cd` into the working directory (CWD), and invoke the
command (CMD) directly. The command is also written to the file `cmd`,
located next to the log file, so to reproduce the step above, you can also use:

```shell
cd work/OpenTitan/default/compile-0
bash _verilate/cmd
```

### Saving of intermediate steps

If you try to run the same benchmark twice:

```shell
./designbench run --cases OpenTitan:default:hello
./designbench run --cases OpenTitan:default:hello
```

You will notice that the second invocation will skip steps already successfully
performed by an earlier one. In order to save CPU time, designbench keeps
the results of intermediate steps in the working directory, and will reuse
them on a later invocations. For example, if you decide to run a different
case, compilation will not be performed if an earlier run already compiled the
relevant configuration:

```shell
# Compiles the 'default' configuration on OpenTitan,
# then runs the 'hello' test
./designbench run --cases OpenTitan:default:hello
# Recognizes the 'OpenTitan:default' is already built,
# then runs the 'cmark' test using the same simulator executable
./designbench run --cases OpenTitan:default:cmark
```

The structure of the working directory after executing the two commands
above is:

```
work
└── OpenTitan
    └── default
        ├── compile-0
        │   ├── _cppbuild
        │   └── _verilate
        └── execute-0
            ├── cmark
            │   ├── _execute
            |   ├── _post
            │   └── _prep
            └── hello
                ├── _execute
                ├── _post
                └── _prep
```

In general, a benchmark run involved 2 major steps:
- compilation of the configuration
- execution of the test

All artifacts produced during compilation, including the simulator executable
are placed in the working directory under the
`<DESIGN>/<CONFIGURATION>/compile-<N>` subdirectory, where `<N>` is generally
0.

Execution of the test will pick up the simulator executable from this
compilation directory, and will put the artifacts produced during execution
under the `<DESIGN>/<CONFIGURATION>/execute-<N>/<TEST>` subdirectory.

The number `<N>` disambiguates repeated runs when using the `--repeat` option
of `designbench run`, as explained later.

The compilation and execution steps are subdivided into certain sub steps.
Saving of intermediate results is done on a sub step granularity. Metadata for
each sub step is saved in the `_<SUBSTEP>` directory under the compilation or
execution subdirectories.

The simplest way to force a new run, is to delete the working directory, or
to specify a different one using the `--workRoot` option of `designbench run`.

If you want to force rerunning only of certain sub step, you can either delete
the relevant subdirectory from the working directory. E.g., delete
`<DESIGN>/<CONFIGURATION>/execute-<N>/<TEST>` if you want to rerun the
execution of `<DESIGN>:<CONFIGURATION>:<TEST>`, or alternatively you can
delete the `_<STEP>/status` file from the relevant subdirectory. You should
rarely have to do this during a standard benchmark run. See also the
`--retry` option of `designbench run`.

Caution: designbench is not aware of input dependencies (sources, command
line options, or other environment differences) when reusing saved intermediate
artifacts. This that the following will not do what you might think:

```
# Compiles the 'default' configuration on OpenTitan,
# then runs the 'hello' test
./designbench run --cases OpenTitan:default:hello
# This will use the same, single threaded executable
# produced on by the previous execution, ignoring the
# extra Verilator options '--threads 4'
./designbench run --cases OpenTitan:default:cmark --compileArgs="--threads 4"
```

Warning, if you change a case (design, configuration, or test), add compiler
options, or otherwise modify the environment, it is safest to start a clean
run in a new working directory using `--workRoot`.

### Reporting metrics

Once you have run some benchmarks, you can use `report` subcommand to display
the recorded metrics for each step. By default the command will display
an important sub set of metrics available in the given working directory
(default `work`). To see the results after the run above, use:

```shell
./designbench report
```

You can use the following to list all steps and metrics available from a
working directory, which you can then use with `./designbench report`:

```shell
./designbench show --steps
./designbench show --metrics
```

### Comparing metrics between runs

The purpose of designbench is to be able to evaluate the effect of changes
to Verilator. In order to do this, it has support for the repeated running of
benchmarks for averaging, and the comparison of multiple runs. For example,
you can use the following the to check the performance effect of using the
DFG optimizer:

```shell
# Run cases matching "*:cmark" 3 times, using default Verilator options
./designbench run --cases "*:cmark" --repeat 3 --workRoot work-default
# Run cases matching "*:cmark" 3 times, using default Verilator options + -fno-dfg
./designbench run --cases "*:cmark" --repeat 3 --workRoot work-no-dfg --compileArgs="-fno-dfg"
# Compare the runs
./designbench compare work-no-dfg work-default
```

This should report the statistically significant performance difference,
caused by the `-fno-dfg` options.
