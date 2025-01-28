#!/bin/bash
set -x
set -e
DESIGN_DIR=$1
TEST=$2
# Copy memory image to run directory
gzip -dc ${DESIGN_DIR}/tests/rom.vmem > rom.vmem
gzip -dc ${DESIGN_DIR}/tests/otp.vmem > otp.vmem
gzip -dc ${DESIGN_DIR}/tests/${TEST/-*}.vmem > flash0.vmem
