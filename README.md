

# Verilator performance test suite

This repository contains `designbench`, a collection of benchmarks and tools
for performance evaluation of Verilator.

The goal of `designbench` is to produce accurate and reproducible performance
metrics, which can be used to evaluate the performance of Verilator, and to
evaluate the effect of changes, options or other relevant differences in the
environment.

## License

In order to keep `designbench` usage simple, the `designs` subdirectory
contains code imported from open source repositories (with some local
modifications). Copyright of these resides with their respective authors,
and their licenses are available in their upstream repositories.

To see the source repositories and licenses of the imported designs, run:
```shell
./designbench show --designs
./designbench show --licenses
```

For `designbench` itself, see [LICENSE](LICENSE).

## Dependencies

We try to keep external dependencies to a minimum. You will need the following
available through $PATH:
- Python 3.9 or newer as `python3`
- An installation of Verilator as `verilator`
- Make (which Verilator requires anyway) as `make`

Python dependencies are manged through a virtual environment (in the `venv`
subdirectory) that you can automatically set up by running the following
command once after pulling or updating the repository:

```shell
make venv
```

## Usage

All operations are invoked via the `designbench` command line executable.
You can view the subcommands via `./designbench --help`, and the command-line help for each subcommand using `./designbench <SUBCOMMAND> --help`.

For a quick smoke test, run:

```shell
./designbench run --cases OpenTitan:default:hello
./designbench report
```

This will take about 2 minutes to finish, and will compile and execute the `OpenTitan:default:hello` case, then print some of the recorded metrics.

For detailed usage information, see the [documentation](docs/index.md).