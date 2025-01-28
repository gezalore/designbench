#!/bin/bash
set -x
set -e
DESIGN_DIR=$1
TEST=$2
CONFIG=$3
LOG=$4
# stdout must contain 'TEST_PASSED'
grep -q "TEST_PASSED" $LOG
