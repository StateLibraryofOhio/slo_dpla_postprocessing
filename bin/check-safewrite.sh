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
if [[ $(pwd)/ = $SLODATA_WORKING/* ]]
then
    echo "This is a safe-ish place to dump output."
    echo ""
else
    cat <<EOF
    You should run this command in a sub-directory under:
    
          $SLODATA_WORKING

    This will keep the data off the OS filesystem/QCOW2.

EOF
    exit
fi

