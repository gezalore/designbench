import argparse
import difflib
import fnmatch
import os
from functools import cached_property
from typing import Callable, Iterable, List, Set, final


# Expand and validate argument patterns
@final
class ArgPatternMatcher:
    what: str
    choicesLazy: Callable[[], Iterable[str]]

    def __init__(self, what: str, choicesLazy: Callable[[], Iterable[str]]) -> None:
        self.what = what
        self.choicesLazy = choicesLazy

    @cached_property
    def choices(self) -> List[str]:
        result = list(self.choicesLazy())
        assert len(result) == len(set(result)), "should be distinct"
        return result

    def __call__(self, spec: str) -> List[str]:
        patterns = spec.split()
        if not patterns:
            raise argparse.ArgumentTypeError(f"{self.what} specifier is empty")
        if all(_.startswith("!") for _ in patterns):
            patterns.insert(0, "*")
        result: List[str] = []
        included: Set[str] = set()
        for pattern in patterns:
            if matches := fnmatch.filter(self.choices, pattern.removeprefix("!")):
                if pattern.startswith("!"):
                    result = [_ for _ in result if _ not in matches]
                    included.difference_update(matches)
                else:
                    result.extend(_ for _ in matches if _ not in included)
                    included.update(matches)
                assert len(result) == len(included), "'result' should be distinct"
            else:
                msg = f"'{pattern}' does not name any valid {self.what}"
                if "*" not in pattern:
                    if suggestions := difflib.get_close_matches(pattern, self.choices, cutoff=0.8):
                        raise argparse.ArgumentTypeError(f"{msg}, did you mean '{suggestions[0]}'?")
                raise argparse.ArgumentTypeError(
                    f"{msg}, for valid choicese see 'designbench show --{self.what}'"
                )
        assert set(result) == included, "'result' and 'incldued' does not match"
        return result


@final
class ArgRangedInt:
    minVal: int | None
    maxVal: int | None

    def __init__(self, minVal: int | None, maxVal: int | None) -> None:
        self.minVal = minVal
        self.maxVal = maxVal

    def __call__(self, val: str) -> int:
        try:
            value = int(val)
        except Exception as e:
            raise argparse.ArgumentTypeError("must be an integer") from e
        if self.minVal is not None and value < self.minVal:
            raise argparse.ArgumentTypeError(f"value must be at least {self.minVal}")
        if self.maxVal is not None and value > self.maxVal:
            raise argparse.ArgumentTypeError(f"value must be at most {self.maxVal}")
        return value


@final
class ArgExistingDirectory:
    def __call__(self, val: str) -> str:
        if not os.path.exists(val):
            raise argparse.ArgumentTypeError(f"'{val}' does not exist")
        if not os.path.isdir(val):
            raise argparse.ArgumentTypeError(f"'{val}' is not a directory")
        return os.path.abspath(val)
