#!/bin/bash
set -x
set -e
DESIGN_DIR=$1
TEST=$2
CONFIG=$3
LOG=$4
# stdout must contain 'SW TEST PASSED'
grep -q "SW TEST PASSED" $LOG
# stdout must contain 'TEST PASSED CHECKS'
grep -q "TEST PASSED CHECKS" $LOG
