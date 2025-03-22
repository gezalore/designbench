#!/bin/bash
set -x
set -e
cmp --verbose mem-expect-0.hex mem-dump-0.hex
