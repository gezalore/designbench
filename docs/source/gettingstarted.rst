Getting started
===============

The following are a minimal set of instruction on getting started with RTLMeter.

Cloning from Git
----------------

Start by cloning the repository, then ``cd`` to the root of the project:

.. code:: shell

 git clone https://github.com/gezalore/designbench.git rtlmeter

.. code:: shell

 cd rtlmeter

Setting up dependencies
-----------------------

Python dependencies are manged through a virtual environment (in the ``venv``
subdirectory) that you can automatically set up by running the following
command once, after cloning or updating the repository:

.. code:: shell

   make venv

Verilator is picked up from the Shell ``$PATH``. To check you have
``verilator`` available, run ``which verilator``. Otherwise please see the
`Verilator manual <https://verilator.org/guide/latest/install.html>`_ for
instructions on how to install Verilator.

Invocation
----------

All operations are invoked via the ``rtlmeter`` command line executable.
You can view the subcommands via ``./rtlmeter --help``, and the command-line
help for each subcommand using ``./rtlmeter <SUBCOMMAND> --help``.

For a quick smoke test, run:

.. code:: shell

   ./rtlmeter run --cases OpenTitan:default:hello
   ./rtlmeter report

This will take about 2 minutes to finish, and will compile and execute the
`OpenTitan:default:hello` case, then print some of the recorded metrics.

.. note::

   If the previous ``run`` command have failed, remove the ``work``
   subdirectory or add ``--retry`` before re-running. The detailed section on
   :ref:`running RTLMeter<saved-steps>` explains why this is necessary.

To see the effect of running the same case using 2 threads, and compare the
results with the single threaded version run above, you can use:

.. code:: shell

   ./rtlmeter run --cases OpenTitan:default:hello --compileArgs="--threads 2" --workRoot work-2t
   ./rtlmeter compare work work-2t

For further usage information please see the rest of the User Guide.
