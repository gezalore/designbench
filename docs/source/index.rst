Designbench reference
#####################

Documentation is organized into two parts.

The User guide explains how to use designbench to evaluate Verilator.

The Developer guide explains designbench internals, most importantly, how to
import new designs to the benchmark suite.

The canonical reference for the command line interface is the built-in help
produced by either of:

.. code:: shell

   designbench --help

.. code:: shell

   designbench <SUBCOMMAND> --help

.. toctree::
   :maxdepth: 1
   :caption: User guide

   cases.rst
   running.rst
   report.rst
   compare.rst
   advanced.rst

.. toctree::
   :maxdepth: 1
   :caption: Developer guide

   import.rst
   descriptor.rst

