#!/bin/bash
set -x
set -e
# stdout must contain 'SW TEST PASSED'
grep -q "SW TEST PASSED" _execute/stdout.log
# stdout must contain 'TEST PASSED CHECKS'
grep -q "TEST PASSED CHECKS" _execute/stdout.log
