#!/bin/bash
set -x
set -e
DESIGN_DIR=$1
TEST=$2
CONFIG=$3
LOG=$4
# stdout must contain 'TEST PASSED'
grep -q "TEST PASSED" $LOG
