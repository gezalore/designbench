Advanced usage examples
=======================

This section contains some advance usage examples that shows you how you
can use RTLMeter to gather data about some scenarios.

Evaluating the effect of processor affinity
-------------------------------------------

Let's say you want to see the effect of different processor assignments on
the execution time of a multi-threaded model.

RTLMeter is aware of the processor affinity it was launched with, and the
C++ build step is executed with the ``-j`` option to Make set to the number of
available processors. In order not to restrict compilation to specific CPUs,
you can compile the required configurations first, without running the execute
steps:

.. code:: shell

    echo "OpenTitan:default:cmark" > case-list.txt
    echo "XiangShan:mini*:cmark" >> case-list.txt
    echo "Vortex:sane:sgemm" >> case-list.txt
    ./rtlmeter run --cases @case-list.txt --compileRoot work-compile --nExecute 0 --compileArgs="--threads 4"

The ``--compileRoot`` option is similar to ``--workRoot``, but only applies to
the compilation steps. You can then use separate working directories to perform
multiple executions, by specifying the ``--executeRoot`` option, and run with
different processor assignments.

On the host machine this example was written on, logical CPUs 0 and 8
correspond to hardware threads that share the same physical core, and so are
CPUs 1 and 9.

You can examine ``/sys/devices/system/cpu/cpu0/topology/thread_siblings_list``
to see the list of logical CPUs that share the same physical core as CPU 0 on
your host machine.

To see the effect of running the 4-thread model on 4 physical cores, with 1
thread each, or on 2 physical cores with 2 threads each, you can run:

.. code:: shell

    numactl -C 0,1,2,3 ./rtlmeter run --cases @case-list.txt --compileRoot work-compile --executeRoot work-4-core-1-thread --nExecute 3
    numactl -C 0,1,8,9 ./rtlmeter run --cases @case-list.txt --compileRoot work-compile --executeRoot work-2-core-2-thread --nExecute 3

You can then see the effect on simulation speed with:

.. code:: shell

    ./rtlmeter compare --metrics speed work-4-core-1-thread work-2-core-2-thread

Which shows that performance is generally better when not sharing physical
cores, and you can quantify the effect precisely:

::

    execute - Sim speed [kHz] - higher is better
    ╒══════════════════════════════╤══════╤══════╤═════════════════╤═════════════════╤══════════════╤═══════════╕
    │ Case                         │   #A │   #B │          Mean A │          Mean B │   Gain (B/A) │   p-value │
    ╞══════════════════════════════╪══════╪══════╪═════════════════╪═════════════════╪══════════════╪═══════════╡
    │ OpenTitan:default:cmark      │    3 │    3 │ 13.14 (± 1.35%) │ 10.17 (± 0.67%) │        0.77x │      0.00 │
    │ Vortex:sane:sgemm            │    3 │    3 │  2.15 (± 1.82%) │  2.03 (± 0.46%) │        0.94x │      0.02 │
    │ XiangShan:mini-chisel3:cmark │    3 │    3 │ 10.96 (± 1.37%) │  9.02 (± 0.71%) │        0.82x │      0.00 │
    │ XiangShan:mini-chisel6:cmark │    3 │    3 │ 11.23 (± 1.52%) │  9.01 (± 0.31%) │        0.80x │      0.00 │
    ╞══════════════════════════════╪══════╪══════╪═════════════════╪═════════════════╪══════════════╪═══════════╡
    │ Geometric mean               │      │      │                 │                 │        0.83x │           │
    │ Geometric mean - pVal < 0.05 │      │      │                 │                 │        0.83x │           │
    ╘══════════════════════════════╧══════╧══════╧═════════════════╧═════════════════╧══════════════╧═══════════╛

Effect of cold vs hot Ccache on compile time
--------------------------------------------

You can use the ``CCACHE_RECACHE`` environment variable (which is specific to
Ccache, see ``man ccache``) to make Ccache not reuse any cached object, but
populate the cache with new objects. You might try something like:

.. code:: shell

    # Run without caching, but populate the cache
    env CCACHE_RECACHE=1 ./rtlmeter run --cases "OpenTitan:default:cmark Vortex:sane:sgemm" --nExecute 0 --workRoot work-ccache-cold
    # Run with the just populated cache
    ./rtlmeter run --cases "OpenTitan:default:cmark Vortex:sane:sgemm" --nExecute 0 --workRoot work-ccache-hot
    # Compare results
    ./rtlmeter compare --steps cppbuild --metrics "elapsed cpu"  work-ccache-cold work-ccache-hot

::

    cppbuild - Elapsed time [s] - lower is better
    ╒═══════════════════╤══════╤══════╤═════════════════╤════════════════╤══════════════╤═══════════╕
    │ Case              │   #A │   #B │          Mean A │         Mean B │   Gain (A/B) │   p-value │
    ╞═══════════════════╪══════╪══════╪═════════════════╪════════════════╪══════════════╪═══════════╡
    │ OpenTitan:default │    1 │    1 │ 72.02           │ 3.02           │       23.85x │           │
    │ Vortex:sane       │    1 │    1 │ 93.25           │ 2.56           │       36.43x │           │
    ╞═══════════════════╪══════╪══════╪═════════════════╪════════════════╪══════════════╪═══════════╡
    │ Geometric mean    │      │      │                 │                │       29.47x │           │
    ╘═══════════════════╧══════╧══════╧═════════════════╧════════════════╧══════════════╧═══════════╛

    cppbuild - CPU Total [s] - lower is better
    ╒═══════════════════╤══════╤══════╤══════════════════╤═════════════════╤══════════════╤═══════════╕
    │ Case              │   #A │   #B │           Mean A │          Mean B │   Gain (A/B) │   p-value │
    ╞═══════════════════╪══════╪══════╪══════════════════╪═════════════════╪══════════════╪═══════════╡
    │ OpenTitan:default │    1 │    1 │ 699.49           │ 38.62           │       18.11x │           │
    │ Vortex:sane       │    1 │    1 │ 647.56           │ 32.41           │       19.98x │           │
    ╞═══════════════════╪══════╪══════╪══════════════════╪═════════════════╪══════════════╪═══════════╡
    │ Geometric mean    │      │      │                  │                 │       19.02x │           │
    ╘═══════════════════╧══════╧══════╧══════════════════╧═════════════════╧══════════════╧═══════════╛

Enabling waveform tracing
-------------------------

You can turn on waveform tracing for all RTLMeter benchmarks. To compile
with trace capability, just pass the relevant Verilator options ``--trace`` or
``--trace-fst``, with possibly other ``--trace*`` options via the
``--compileArgs`` option to ``./rtlmeter run``. To actually enable tracing
at execution time, also pass ``+trace`` via ``--executeArgs``. (``+trace`` is
checked by the RTLMeter support code included in the top level module of
all benchmarks).

.. code:: shell

    # Compile with trace capability
    ./rtlmeter run --cases "VeeR-EH1:default:cmark" --compileArgs="--trace" --nExecute=0
    # Execute with tracing enabled at run-time
    ./rtlmeter run --cases "VeeR-EH1:default:cmark" --compileRoot work --executeRoot work-trace-on --executeArgs="+trace"
    # Execute without racing enabled at run-time
    ./rtlmeter run --cases "VeeR-EH1:default:cmark" --compileRoot work --executeRoot work-trace-off
