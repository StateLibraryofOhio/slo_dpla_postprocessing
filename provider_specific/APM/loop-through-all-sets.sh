#!/bin/bash
#
# This script is a wrapper for the "insert-thumbs-from-summary--apm.sh"
# script.  This will invoke the "insert-thumbs..." script separately
# for each set, thus allowing one to process all of the datasets with
# only a single command.
#

APM_BIN=/usr/local/SLODATA/working-area/QA/AmericasPackardMuseum/APM_bin

ls | grep "^set" | while read DIRECTORY
do
    echo "Processing $DIRECTORY"
    cd $DIRECTORY
    $APM_BIN/insert-thumbs-from-summary--apm.sh
    cd ..
done 









