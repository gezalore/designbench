Comparing results
=================

One of the most important reasons RTLMeter exists, is to enable comparison
of different versions of Verilator, and to enable drawing robust conclusions
on which version is better. For this purpose, you can use
``./rtlmeter compare`` to display the difference in performance metrics
between two runs. You provide two working directories created with
``./rtlmeter run``, and ``./rtlmeter compare`` will show you the
difference in the metrics you query.

Difference of two runs
----------------------

As an example, let's say you are interested in the effect of the choice
between using GCC or Clang to compile Verilator and your verilated models.
For this we assume you have 2 different builds of Verilator available, one
configured with ``CXX=g++``, and one configured with ``CXX=clang++``. You can
then perform some runs to get a quick idea. Remember RTLMeter picks up
Verilator from your shell PATH, so let's set up some shell variables to use
throughout the following examples:

.. code:: shell

    VERILATOR_GCC=... path to 'bin' directory of Verilator configured with GCC ...
    VERILATOR_CLANG=... path to 'bin' directory of Verilator configured with Clang ...

You can then run a set of cases with each version:

.. code:: shell

    env PATH="$VERILATOR_GCC:$PATH"   ./rtlmeter run --cases 'VeeR*:default:cmark' --nExecute 3 --workRoot work-gcc
    env PATH="$VERILATOR_CLANG:$PATH" ./rtlmeter run --cases 'VeeR*:default:cmark' --nExecute 3 --workRoot work-clang

Once this is finished (it takes ~30 minutes), you can see the difference
in simulator execution time with the following:

.. code:: shell

    ./rtlmeter compare --steps execute work-gcc work-clang

This will produce a report similar to:

::

    execute - Elapsed time [s] - lower is better
    ╒══════════════════════════════╤══════╤══════╤═════════════════╤═════════════════╤══════════════╤═══════════╕
    │ Case                         │   #A │   #B │          Mean A │          Mean B │   Gain (A/B) │   p-value │
    ╞══════════════════════════════╪══════╪══════╪═════════════════╪═════════════════╪══════════════╪═══════════╡
    │ VeeR-EH1:default:cmark       │    3 │    3 │ 59.41 (± 1.25%) │ 55.70 (± 1.34%) │        1.07x │      0.00 │
    │ VeeR-EH2:default:cmark       │    3 │    3 │ 57.21 (± 0.51%) │ 42.15 (± 1.93%) │        1.36x │      0.00 │
    │ VeeR-EL2:default:cmark       │    3 │    3 │ 59.04 (± 0.61%) │ 55.03 (± 1.10%) │        1.07x │      0.00 │
    ╞══════════════════════════════╪══════╪══════╪═════════════════╪═════════════════╪══════════════╪═══════════╡
    │ Geometric mean               │      │      │                 │                 │        1.16x │           │
    │ Geometric mean - pVal < 0.05 │      │      │                 │                 │        1.16x │           │
    ╘══════════════════════════════╧══════╧══════╧═════════════════╧═════════════════╧══════════════╧═══════════╛

Here 'A' refers to results from the first working directory passed on the
command line (``work-gcc``), and 'B' refers to the second working directory
(``work-clang``).

You can see that using Clang, the simulation is on average ~16% faster across
these cases compared to using GCC. The 'gain' (ratio of means) is also shown
for each individual case.

Similar to ``./rtlmeter report``, you can use the ``--steps``, and
``--metrics`` options to compare different measurements available in the
working directories.

Significance of difference
--------------------------

To check if there is a meaningful difference in the performance metrics,
``./rtlmeter compare`` will compute a statistical significance test for the
difference between the means for each case. The corresponding *p-value* is
reported in the last column. As is standard with statistical hypothesis
testing, low p-values indicate a significant difference. A commonly used
threshold for concluding a statistically significant result is a
p-value < 0.05, so RTLMeter reports the average gain for only those cases
that meet this significance threshold. In the case of execution time above
the results are clear, Clang produces faster code.

Note that the p-value is only computed if at least 2 samples are available
from both working directories (as shown by the ``#A`` and ``#B`` columns),
otherwise the table entry for the p-value will be blank.

Let's now say you are interested in the effect of Clang vs GCC on running
Verilator itself. Earlier we only collected 1 sample for the compilation step,
so let's add a few more:

.. code:: shell

    env PATH="$VERILATOR_GCC:$PATH"   ./rtlmeter run --cases 'VeeR*:default:cmark' --nCompile 3 --workRoot work-gcc
    env PATH="$VERILATOR_CLANG:$PATH" ./rtlmeter run --cases 'VeeR*:default:cmark' --nCompile 3 --workRoot work-clang

This will perform 2 more compilations of each configuration. The first one
is available from the earlier run we did above when measuring execution time.
Simulation will also not be run, as execution results are already available
in the working directories, but if you run this with clean working directories,
you could add ``--nExecute 0`` to not perform execution. To check the effect on
verilation time, use:

.. code:: shell

    ./rtlmeter compare --steps verilate work-gcc work-clang


The report looks something like:

::

    verilate - Elapsed time [s] - lower is better
    ╒══════════════════╤══════╤══════╤═════════════════╤════════════════╤══════════════╤═══════════╕
    │ Case             │   #A │   #B │          Mean A │         Mean B │   Gain (A/B) │   p-value │
    ╞══════════════════╪══════╪══════╪═════════════════╪════════════════╪══════════════╪═══════════╡
    │ VeeR-EH1:default │    3 │    3 │  2.98 (± 2.95%) │ 2.91 (± 0.67%) │        1.03x │      0.24 │
    │ VeeR-EH2:default │    3 │    3 │ 10.06 (± 5.49%) │ 9.65 (± 3.93%) │        1.04x │      0.30 │
    │ VeeR-EL2:default │    3 │    3 │  4.81 (± 3.47%) │ 4.72 (± 3.22%) │        1.02x │      0.46 │
    ╞══════════════════╪══════╪══════╪═════════════════╪════════════════╪══════════════╪═══════════╡
    │ Geometric mean   │      │      │                 │                │        1.03x │           │
    ╘══════════════════╧══════╧══════╧═════════════════╧════════════════╧══════════════╧═══════════╛

Although it looks like Clang might be ~3% faster, the p-values indicate that
the results are not significant, the difference might just be due to a noisy
host machine.

Let's add some more samples, as some of the confidence intervals of the means
are quite wide:


.. code:: shell

    env PATH="$VERILATOR_GCC:$PATH"   ./rtlmeter run --cases 'VeeR*:default:cmark' --nCompile 30 --workRoot work-gcc
    env PATH="$VERILATOR_CLANG:$PATH" ./rtlmeter run --cases 'VeeR*:default:cmark' --nCompile 30 --workRoot work-clang


Then rerun:

.. code:: shell

    ./rtlmeter compare --steps verilate work-gcc work-clang


And you will see something like:

::

    verilate - Elapsed time [s] - lower is better
    ╒══════════════════════════════╤══════╤══════╤════════════════╤════════════════╤══════════════╤═══════════╕
    │ Case                         │   #A │   #B │         Mean A │         Mean B │   Gain (A/B) │   p-value │
    ╞══════════════════════════════╪══════╪══════╪════════════════╪════════════════╪══════════════╪═══════════╡
    │ VeeR-EH1:default             │   30 │   30 │ 2.95 (± 0.41%) │ 2.94 (± 0.39%) │        1.00x │      0.11 │
    │ VeeR-EH2:default             │   30 │   30 │ 9.67 (± 0.72%) │ 9.62 (± 0.42%) │        1.00x │      0.28 │
    │ VeeR-EL2:default             │   30 │   30 │ 4.65 (± 0.58%) │ 4.69 (± 0.40%) │        0.99x │      0.03 │
    ╞══════════════════════════════╪══════╪══════╪════════════════╪════════════════╪══════════════╪═══════════╡
    │ Geometric mean               │      │      │                │                │        1.00x │           │
    │ Geometric mean - pVal < 0.05 │      │      │                │                │        0.99x │           │
    ╘══════════════════════════════╧══════╧══════╧════════════════╧════════════════╧══════════════╧═══════════╛

Now your one statistically significant case suggests using Clang is actually
~1% slower, but as you can see, the difference is hard to measure, as it is
very small. At this point you might conclude that the difference is small
enough not to be meaningful.

If you rerun the same session yourself, the actual results might of course
differ, as they depend on the host machine, environment, or the version of the
compilers you are using. The point here is that RTLMeter gives you the
ability to draw statistically sound conclusions.

If you care, you can of course keep going until your time and patience allows.
Here are the results after 100 runs with both compilers:

::

    verilate - Elapsed time [s] - lower is better
    ╒══════════════════════════════╤══════╤══════╤════════════════╤════════════════╤══════════════╤═══════════╕
    │ Case                         │   #A │   #B │         Mean A │         Mean B │   Gain (A/B) │   p-value │
    ╞══════════════════════════════╪══════╪══════╪════════════════╪════════════════╪══════════════╪═══════════╡
    │ VeeR-EH1:default             │  100 │  100 │ 2.95 (± 0.20%) │ 2.97 (± 0.45%) │        0.99x │      0.00 │
    │ VeeR-EH2:default             │  100 │  100 │ 9.62 (± 0.27%) │ 9.69 (± 0.41%) │        0.99x │      0.01 │
    │ VeeR-EL2:default             │  100 │  100 │ 4.63 (± 0.24%) │ 4.72 (± 0.38%) │        0.98x │      0.00 │
    ╞══════════════════════════════╪══════╪══════╪════════════════╪════════════════╪══════════════╪═══════════╡
    │ Geometric mean               │      │      │                │                │        0.99x │           │
    │ Geometric mean - pVal < 0.05 │      │      │                │                │        0.99x │           │
    ╘══════════════════════════════╧══════╧══════╧════════════════╧════════════════╧══════════════╧═══════════╛

This suggests that using Clang indeed makes verilation ~1% slower on average,
across these cases. How you use that information (whether you care or not),
is of course outside the scope of this discussion, but RTLMeter can give
you robust data to help you make decisions.

Evaluating the effect of Verilator options
------------------------------------------

You can use the ``--compileArgs`` option of ``./rtlmeter run`` to pass
additional command line arguments to ``verilator`` during compilation. As an
example, let's use this to check the effect of the ``--public-flat-rw``
Verilator option. Note the ``=`` used to prevent ``./rtlmeter run`` from
trying to parse the extra option as an argument to itself:

.. code:: shell

    ./rtlmeter run --cases 'VeeR*:default:cmark' --workRoot work-base
    ./rtlmeter run --cases 'VeeR*:default:cmark' --workRoot work-pfrw --compileArgs="--public-flat-rw"


Then run:

.. code:: shell

    ./rtlmeter compare work-base work-pfrw

Which shows:

::

    verilate - Elapsed time [s] - lower is better
    ╒══════════════════╤══════╤══════╤═════════════════╤═════════════════╤══════════════╤═══════════╕
    │ Case             │   #A │   #B │          Mean A │          Mean B │   Gain (A/B) │   p-value │
    ╞══════════════════╪══════╪══════╪═════════════════╪═════════════════╪══════════════╪═══════════╡
    │ VeeR-EH1:default │    1 │    1 │  2.88           │  4.82           │        0.60x │           │
    │ VeeR-EH2:default │    1 │    1 │ 10.23           │ 16.09           │        0.64x │           │
    │ VeeR-EL2:default │    1 │    1 │  4.85           │  8.45           │        0.57x │           │
    ╞══════════════════╪══════╪══════╪═════════════════╪═════════════════╪══════════════╪═══════════╡
    │ Geometric mean   │      │      │                 │                 │        0.60x │           │
    ╘══════════════════╧══════╧══════╧═════════════════╧═════════════════╧══════════════╧═══════════╛

    execute - Elapsed time [s] - lower is better
    ╒════════════════════════╤══════╤══════╤═════════════════╤══════════════════╤══════════════╤═══════════╕
    │ Case                   │   #A │   #B │          Mean A │           Mean B │   Gain (A/B) │   p-value │
    ╞════════════════════════╪══════╪══════╪═════════════════╪══════════════════╪══════════════╪═══════════╡
    │ VeeR-EH1:default:cmark │    1 │    1 │ 55.52           │ 352.58           │        0.16x │           │
    │ VeeR-EH2:default:cmark │    1 │    1 │ 44.46           │ 458.54           │        0.10x │           │
    │ VeeR-EL2:default:cmark │    1 │    1 │ 55.74           │ 308.84           │        0.18x │           │
    ╞════════════════════════╪══════╪══════╪═════════════════╪══════════════════╪══════════════╪═══════════╡
    │ Geometric mean         │      │      │                 │                  │        0.14x │           │
    ╘════════════════════════╧══════╧══════╧═════════════════╧══════════════════╧══════════════╧═══════════╛

There is not much point in doing multiple runs here, as the difference is very
large, so you can see that ``--public-flat-rw`` causes significant slowdown both
in verilation and in execution. This is of course expected, as
``--public-flat-rw`` disables a lot of optimizations that result in both a slower
simulator executable, and slower verilation due to an increased working set
size in later Verilator passes.

If you find it easier to interpret the results, you can swap the working
directories around, to see the effect of *not using* ``--public-flat-rw``:

.. code:: shell

    ./rtlmeter compare work-pfrw work-base

Which presents:

::

    verilate - Elapsed time [s] - lower is better
    ╒══════════════════╤══════╤══════╤═════════════════╤═════════════════╤══════════════╤═══════════╕
    │ Case             │   #A │   #B │          Mean A │          Mean B │   Gain (A/B) │   p-value │
    ╞══════════════════╪══════╪══════╪═════════════════╪═════════════════╪══════════════╪═══════════╡
    │ VeeR-EH1:default │    1 │    1 │  4.82           │  2.88           │        1.67x │           │
    │ VeeR-EH2:default │    1 │    1 │ 16.09           │ 10.23           │        1.57x │           │
    │ VeeR-EL2:default │    1 │    1 │  8.45           │  4.85           │        1.74x │           │
    ╞══════════════════╪══════╪══════╪═════════════════╪═════════════════╪══════════════╪═══════════╡
    │ Geometric mean   │      │      │                 │                 │        1.66x │           │
    ╘══════════════════╧══════╧══════╧═════════════════╧═════════════════╧══════════════╧═══════════╛

    execute - Elapsed time [s] - lower is better
    ╒════════════════════════╤══════╤══════╤══════════════════╤═════════════════╤══════════════╤═══════════╕
    │ Case                   │   #A │   #B │           Mean A │          Mean B │   Gain (A/B) │   p-value │
    ╞════════════════════════╪══════╪══════╪══════════════════╪═════════════════╪══════════════╪═══════════╡
    │ VeeR-EH1:default:cmark │    1 │    1 │ 352.58           │ 55.52           │        6.35x │           │
    │ VeeR-EH2:default:cmark │    1 │    1 │ 458.54           │ 44.46           │       10.31x │           │
    │ VeeR-EL2:default:cmark │    1 │    1 │ 308.84           │ 55.74           │        5.54x │           │
    ╞════════════════════════╪══════╪══════╪══════════════════╪═════════════════╪══════════════╪═══════════╡
    │ Geometric mean         │      │      │                  │                 │        7.13x │           │
    ╘════════════════════════╧══════╧══════╧══════════════════╧═════════════════╧══════════════╧═══════════╛
