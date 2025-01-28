#!/bin/bash
set -x
set -e
# stdout must contain 'Hit Good Trap'
grep -q "Hit Good Trap" _execute/stdout.log
