#!/bin/bash
#
# This script is intended to ensure that those scripts which 
# produce output files are only invoked in the SLODATA_WORKING
# area of the filesystem.
#
# The SLODATA_WORKING filesystem should be segregated on its own
# QCOW2 file to avoid catastrophic failure of this VM which can
# occur if the OS filesystem is filled to capacity.
#
pwd
echo "$SLODATA_WORKING/*"
if [[ $(pwd)/ = $SLODATA_WORKING/* ]]
then
    echo "This is a safe place to run the command."
else
    echo ""
    echo "You should run this command in a sub-directory under:"
    echo ""
    echo "     $SLODATA_WORKING"
    echo ""
    exit
fi

