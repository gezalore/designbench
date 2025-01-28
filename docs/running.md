## Running benchmarks

To run a cases, you use the `./designbench run` subcommand. This uses the
`verilator` executable from your `$PATH` to compile and execute simulations,
gathering performance metrics as it does.

### Steps during a run

Several distinct steps happen when you run a case. For example, starting from
a clean repository, run:

```shell
./designbench run --cases OpenTitan:default:hello
```

The above will perform 2 major operations:
1. _Compile_ the `OpenTitan:default` configuration into a simulator executable
2. _Execute_ the compiled simulator to run the `OpenTitan:default:hello` test

Both of these are sub-divided into smaller _steps_, and performance metrics are
recorded for each step.

Compilation contains two major steps: `verilate` to run Verilator, and
`cppbuild` to compile and link the output of Verilator (together with design
specific C++ code, if any) into the simulator executable.

Execution contains only one major step, `execute`, which corresponds to running
the simulator executable.

There are other minor steps involved, for preparing compilation and simulation
inputs, and checking simulation results, which are not relevant for performance
evaluation, and are not instrumented.

To see all major steps that designbench will instrument, you can run:

```shell
./designbench show --steps
```

### Structure of working directory

`./designbench run` will place all artifacts into a _working directory_, which
is called `work` by default. An alternative path to the working directory can
be specified with the `--workRoot` option.

After successfully running the example above, the working directory will have
the following structure (with some entries omitted):

```
work
└── OpenTitan
    └── default
        ├── compile-0
        │   ├── _files
        │   ├── _verilate
        │   └── _cppbuild
        └── execute-0
            └── hello
                ├── _files
                ├── _execute
                └── _postHook
```

For a given configuration, compilation is performed, and artifacts are stored
in the `<DESIGN>/<CONFIGURATION>/compile-0` subdirectory.

Subsequently, for a given case, execution uses the
`<DESIGN>/<CONFIGURATION>/execute-0/<TEST>` subdirectory to run the simulation.

Within each of these directories, there are subdirectories starting with `_`,
that designbench uses to keep track of various thing. There is one of these `_`
directories per internal step executed by designbench, some of which are major
steps as described above (e.g: `_verilate` corresponds to the `verilate` step),
while others are minor steps not relevant for performance evaluation (e.g.:
`_files` corresponds to setting up input files for compilation or execution).

### Specifying cases

The `--cases` command line option is used by various sub-commands to limit
operation to the specified cases.

The `--cases` option takes a single string as argument. The simplest form
is to specify a single case:

```shell
./designbench run --cases OpenTitan:default:hello
```

You can also use shell-style wildcards to specify multiple cases (be careful
to escape the file globbing of your shell). For example, to run all cases of
the OpenTitan design:

```shell
./designbench run --cases 'OpenTitan:*'
```

This will run the subset of all cases (as reported by
`./designbench show --cases`) that match the given pattern.

You can also provide multiple patterns, separated by spaces. For example, to
run two cases:

```shell
./designbench run --cases 'OpenTitan:default:hello OpenTitan:default:cmark'
```

You can prefix a pattern with `!` to exclude matching cases. The following
runs all OpenTitan cases, except for `OpenTitan:default:hello`:

```shell
./designbench run --cases 'OpenTitan:* !*:hello'
```

Patterns are processed left to right, and cases are run in the order they
are matched. Exclusions apply only to cases listed earlier. If multiple
patterns match the same case, it will only be run once, at the point it
is specified without being excluded later. For example, the following will
run the `cmark` tests on all configurations of all VeeR cores, except
`hiperf`, and then run `VeeR-EH1:highperf:cmark`:

```shell
./designbench run --cases 'VeeR*:cmark !*:hiperf:* VeeR-EH1:hiperf:cmark'
```

The point here is that you can fine tune the order in which cases are run,
in case you would like to see some results earlier than others.

If you want, you can of course run all cases with:

```shell
./designbench run --cases "*"
```

Beware however that this will take a very long time to complete.

If all patterns are exclusionary, a leading `*` is implied, so for example
you can run all but some very long and very short cases with:

```shell
./designbench run --cases "!Vortex:huge* !XiangShan:default* !*:linux !*:hello"
```

There are two further ways you can specify cases.

Cases can be marked as belonging to a special set of cases using _tags_.
To see the available tags, you can run `./designbench show --tags`.
You can specify a tag to the `--cases` option as `+<TAG>`, for example, to
run a standard set of cases suitable for baseline performance evaluation, you
can try:

```shell
./designbench run --cases "+standard"
```

You can also specify a list of patterns in a file, one per line, and pass
`@filename` to `--cases`.

You can also combine these, so for example to run some list of cases read
from a file, excluding those that might compile or execute for a long time,
you can use:

```shell
./designbench run --cases "@case-list.txt !+long !+large"
```

### Saving of intermediate steps performed earlier

When the working directory already contains the required artifacts from an
earlier run, `designbench run` will reuse those results, and skip the
corresponding steps on a subsequent run. This can be used to incrementally
collect more data while minimizing latency:

```shell
# Quick sanity check
./designbench run --cases OpenTitan:default:hello
```

If you are satisfied with the above, you can then run all remaining cases:

```shell
# Run all remaining cases
./designbench run --cases 'OpenTitan:*'
```

This second invocation will skip compilation, and will also skip running the
`hello` test, as these steps were already performed by the first invocation.

If you want to force rerunning a step (maybe because you realized some
background process kicked in on your computer and made that performance
measurement unreliable), you can delete the relevant part of the working
directory:

```shell
rm -rf work/OpenTitan/default/execute-0/aes
# This will rerun OpenTitan:default:aes
./designbench run --cases 'OpenTitan:*'
```

Note however that designbench currently does not track input dependencies among
steps, so doing this is only safe if you have not modified the design or
verilator in between the runs.

Also note that steps that have failed on an earlier run will not be run again
on a subsequent run (that is, failures are saved in the working directory as
well). This is by design, in case a long running benchmarking session
encounters a failure, we do not want to waste time re-attempting the failed
step. To force retrying steps failed on an earlier run, use the `--retry`
option of `./designbench run`, or use a new working directory.

### Rerunning external commands manually

Whenever an external command is invoked during a step, designbench prints the
working directory, command line, and the location of the log file holding the
stdout/stderr produced by the command.

This is designed to facilitate hacking on (debugging, profiling, etc)
intermediate steps, like the invocation of Verilator, or the running of the
simulation.

For example, when you first run
 `./designbench run --cases OpenTitan:default:hello`, it will print something
 akin to the following:

```
@@@ (2/6) OpenTitan:default - Verilate
@@@ CWD: work/OpenTitan/default/compile-0
@@@ LOG: work/OpenTitan/default/compile-0/_verilate/stdout.log
@@@ CMD: verilator --cc --main --exe --timing <OMITTED>
```

You should be able to `cd` into the working directory (printed after CWD),
and invoke the printed command (CMD) directly to run exactly the same thing
as designbench just did. The command is also written to the file `cmd`, under
the `_<STEP>` directory, in this case `_verilate/cmd`, so to reproduce the
step, you can:

```shell
cd work/OpenTitan/default/compile-0
sh _verilate/cmd
```

Keep in mind the Verilator `--no-skip-identical` and similar options.

### Repeating runs for better measurements

One issue with benchmarking software performance is the variability in
measurements due to random processes on the host machine (noise). To help
evaluate this variance, and to enable drawing robust conclusions, designbench
supports running compilation and execution multiple times, using the
`--nCompile` and `--nExecute` options of `./designbench run`. These will
cause designbench to perform repeated compilation and execution of each case.
For example, the following will run each of the specified cases 3 times:

```shell
./designbench run --cases 'OpenTitan:*' --nExecute 3
```

Actually, what this command really does, is it populates the
`<DESIGN>/<CONFIGURATION>/execute-<N>/<TEST>` subdirectories for `<N>`
0, 1, and 2, under the working directory, so you will have 3 samples for
the relevant measurements. If it turns out these are still too noisy, you can
add more samples by increasing the sample count:

```shell
./designbench run --cases 'OpenTitan:*' --nExecute 5
```

As described in the section about saving of intermediate results, the above
will skip execution for `<N>` 0, 1, and 2 (they are available from the
previous run), then populate `execute-3` and `execute-4`. You can collect
more samples this was as necessary in the least amount of time.

If you are interested in measuring compilation speed only, you can use:

```shell
./designbench run --cases 'OpenTitan:*' --nCompile 3 --nExecute 0
```

This will perform 3 repeated compilation of the configurations required by
the specified cases, but will not execute any of the tests.

Note that all execution will use the simulator executable from the first
compilation (that is, from the `<DESIGN>/<CONFIGURATION>/compile-0`
subdirectory of the working directory), even if multiple compilations were
performed.
