#!/bin/bash
#
# The intent of this script is to loop through the values in the
# "summary.txt" file, which is created by the add-thumbs.sh script.
# The "summary.txt" file contains the edm:isShownAt value and the
# corresponding edm:preview value.  
#
# With each iteration of the loop, the edm:preview and edm:isShownAt
# values are inserted into a copy of a template XSLT file.  This
# XSLT file is then run against the final, nearly-ready XML to 
# insert the edm:preview in the appropriate record.
#
# After each iteration of the loop, this XSLT file is removed and
# replaced with a new one (if there are additional records to
# process).
#
# This script expects a "transform.conf" to be in the current
# working directory.  This file is created by running the
# $SLODPLA_BIN/addset.sh script.
#
# Upon completion, the processed metadata file is copied to the
# $SLODATA_STAGING directory.
#
# The "loop-through-all-sets.sh" script calls this script for
# each set, but this script can be run as a standalone script
# in order to process only a single data-set's edm:preview values.
#

. transform.conf

APM_BIN=/usr/local/SLODATA/working-area/QA/AmericasPackardMuseum/APM_bin

let COUNTER=1
INFILE_ORIG=$SETSPEC-DPLA_ready.xml
cp $INFILE_ORIG $COUNTER.xml

cat summary.txt | while read SUMMARY
do
    export URL=`echo $SUMMARY | cut -f 1 -d ' '`
    export PREVIEW=`echo $SUMMARY | cut -f 3 -d ' '`

    perl -p -e 's/XYZZY_URL/$ENV{URL}/g' $APM_BIN/insert_template.xsl > tmp1_$COUNTER.xsl
    perl -p -e 's/XYZZY_PREVIEW/$ENV{PREVIEW}/g' tmp1_$COUNTER.xsl > tmp2_$COUNTER.xsl
    let NEXT=$COUNTER+1
    java net.sf.saxon.Transform -s:$COUNTER.xml -o:$NEXT.xml -xsl:tmp2_$COUNTER.xsl
    rm tmp1_$COUNTER.xsl tmp2_$COUNTER.xsl
    cp $NEXT.xml final.xml
    let COUNTER=$COUNTER+1
done

cp final.xml $SETSPEC-thumbs-DPLA_ready.xml $SLODATA_STAGING/$SETSPEC-DPLA_ready.xml


