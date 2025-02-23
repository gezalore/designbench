## Examining results

Once you have used `./designbench run` to run some cases, you can use
`./designbench report` to display the performance metrics. This subcommand
operates on a working directory created by `./designbench run`, which can be
specified as a positional argument, and defaults to `work`.

### Reporting metrics

Assuming you have previously run:

```shell
./designbench run --cases 'OpenTitan:*' --nExecute 3
```

Then you can see the most important metrics at a glance using

```shell
./designbench report
```

This will produce output similar to:

```
verilate
╒═══════════════════╤═════╤════════════════════╤════════════════════╕
│ Case              │   # │   Elapsed time [s] │   Peak memory [MB] │
╞═══════════════════╪═════╪════════════════════╪════════════════════╡
│ OpenTitan:default │   1 │    48.16           │  1922.16           │
╘═══════════════════╧═════╧════════════════════╧════════════════════╛

execute
╒═════════════════════════╤═════╤═══════════════════╤════════════════════╤════════════════════╕
│ Case                    │   # │   Sim speed [kHz] │   Elapsed time [s] │   Peak memory [MB] │
╞═════════════════════════╪═════╪═══════════════════╪════════════════════╪════════════════════╡
│ OpenTitan:default:aes   │   3 │    6.98 (± 2.61%) │   106.81 (± 2.58%) │    24.79 (± 0.34%) │
│ OpenTitan:default:cmark │   3 │    7.06 (± 1.06%) │   122.63 (± 1.06%) │    24.75 (± 0.34%) │
│ OpenTitan:default:hello │   3 │    7.27 (± 2.39%) │    14.12 (± 2.36%) │    24.83 (± 0.00%) │
│ OpenTitan:default:rsa   │   3 │    6.93 (± 0.65%) │   112.53 (± 0.65%) │    24.79 (± 0.34%) │
│ OpenTitan:default:sha   │   3 │    7.06 (± 1.51%) │   107.62 (± 1.51%) │    24.83 (± 0.00%) │
╘═════════════════════════╧═════╧═══════════════════╧════════════════════╧════════════════════╛
```

The two steps reported by default are:
- `verilate`, which are the measurements from running Verilator
   (not including compiling the Verilated output)
- `execute`, which are the measurements from running the simulator executable

Hopefully most of the metrics displayed by default are self explanatory. The
'Sim speed' metric shows the effective clock rate of the simulation, which
is computed as the number of simulated clock cycles, divided by elapsed (wall
clock) time.

The column labelled `#` shows the number of samples available in the working
directory the report is generated from for that row. In this case, there is
1 sample for the single configuration in `verilate`, and 3 samples for each
case in `execute`.

When multiple samples are available, the mean is displayed, with the width of
the 95% confidence interval following in parentheses. This should help judge
variance on your host.

### Available measurements

You can see all metrics and steps with available measurements in the working
directory, and a brief description of their meaning, using:

```shell
./designbench show --steps work
./designbench show --metrics work
```

You can then use the `--steps` and `--metrics` options to
`./designbench report` to see specific metrics. These options take a
single argument, that can be a space separated list of
[patterns](running.md#specifying-cases) similar to what `--cases` accepts.

E.g.: to see the elapsed time, and cumulative CPU time used by both verilating
the design, and compiling the verilated C++, use:

```shell
./designbench report --steps 'verilate cppbuild' --metrics 'elapsed cpu'
```

To see all measurements for all steps, you can use wildcards, but this
might be overwhelming after a big run:

```shell
./designbench report --steps '*' --metrics '*'
```

### Viewing specific cases

You can use the `--cases` option to report only the selected cases, for
example, to see all but the short running `hello` tests:

```shell
./designbench report --cases '!*:hello'
```

### Adding and deleting measurements

`./designbench report` simply picks up and collates all available measurements
from the given working directory.

This means it is OK to run `./designbench report` on a working directory that
is still being populated by an active `./designbench run`, to see partial
results as they become available (note however the noise this might add to
your measurements).

The actual measurements are stored in `_<STEP>/metrics.json` files under the
working directory. It is safe to delete these, or whole subdirectories of the
working directory in order to remove some measurements (maybe because they
are too noisy).

### Examining raw data

You can use `./designbench rawdata`, which has an interface similar to
`./designbench report`, but instead of displaying summary statistics, it shows
individual measurements. This can be helpful for identifying outliers.
