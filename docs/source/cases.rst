Organization of cases
=====================

Each executable benchmark is identified by a triplet of the form
``<DESIGN>:<CONFIGURATION>:<TEST>``, which is referred to as a 'case'.

Design
------

The ``<DESIGN>`` part names a self contained *design*. All inputs related to
a given design (Verilog and C++ sources, tool and run-time options, run-time
input and reference output files, etc.) are located in the corresponding
subdirectory under ``designs/<DESIGN>``. There are no dependencies between
different designs.

To list all available designs, and see their original repositories, you can
run:

.. code:: shell

    ./designbench show --designs

Configuration
-------------

Each design can have multiple *configurations*, named by the ``<CONFIGURATION>``
part. Different configurations of the same design usually share a set of
input files or options. Each design have at least one configuration.

The ``<DESIGN>:<CONFIGURATION>`` pair uniquely determines the inputs to
compilation and correspond to a single simulator executable used for the case.

Test
----

The ``<TEST>`` part names the test, which determines the run-time inputs used
for the simulation. All cases with the same ``<DESIGN>:<CONFIGURATION>``, but
with a different ``<TEST>`` are executed using the same simulator executable,
but with different run-time inputs.

Available cases
---------------

All cases (configurations and tests) for a given design are specified via a
declarative YAML descriptor that you can find at
``designs/<DESIGN>/descriptor.yaml``. If you do not intend to make modifications
or import new designs, you do not need to be familiar with this, but a
:ref:`description of the format it is available<design-descriptor>`.

To see all available cases, run:

.. code:: shell

    ./designbench show --cases
