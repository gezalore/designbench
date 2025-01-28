#!/bin/bash
set -x
set -e
DESIGN_DIR=$1
TEST=$2
# Copy memory image to run directory
gzip -dc ${DESIGN_DIR}/tests/${TEST/-*}.hex > program.hex
