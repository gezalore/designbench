#!/bin/bash
set -x
set -e
# stdout must contain 'All threads hit good tap - PASS'
grep -q "All threads hit good tap - PASS" _execute/stdout.log

