#!/bin/bash
#
#This script will search for records that do not have any
# edm:rights values.  The records being searched are in:
#
#   $SLODATA_STAGING
#
# That setting is configured in the conf/upload.conf file.
# 
# The results of this can be used as feedback for the contributing
# organizations so they can add the metadata.

# The same check is run during our normal new collection and
# reharvest processes, but we might lose track of which sets
# still haven't been fixed and this report will allow us to
# scan every contributed record for rights problems.
#
# This may take some time to run to completion.  Be patient.
#

# Load values set in upload.conf

if [ ! -f conf/upload.conf ]
then
    echo
    echo "Run this script with 'conf' as a subdirectory to your cwd."
    echo "Exiting."
    echo
    exit
else
    . conf/upload.conf
fi

cat <<EOF

This script will search for records that do not have any
edm:rights values.  The records being searched are in:

   $SLODATA_STAGING

This may take some time to run to completion.  Be patient.
Think happy thoughts.  Praise "Bob"!

EOF

STAGINGDIR=$SLODATA_STAGING
XSLT=$SLODPLA_LIB/show-rightsless.xsl
OUTFILE=$INGEST_REPORTDIR/rightsless.txt


rm -f $OUTFILE

cd $STAGINGDIR
ls | while read SETSPEC
do
    java net.sf.saxon.Transform  -xsl:$XSLT -s:$SETSPEC -o:$OUTFILE
done


if [ `wc -l $OUTFILE | cut -f 1 -d ' '` -gt 0 ]
then
    echo "Some records have rights problems.  Research these further."
    echo "Offending records can be seen in:  "
    echo 
    echo "  $OUTFILE"
    echo
else
    echo "No problems found."
    echo ""
fi


