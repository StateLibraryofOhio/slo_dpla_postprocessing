#!/bin/bash

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
edm:rights values.

This may take some time to run to completion.  Be patient.

EOF

STAGINGDIR=$INGEST_DATADIR/09__staging
INDIR=$INGEST_DATADIR/03__iiif-blanket-insert
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
    echo "  $OUTFILE"
    echo
else
    echo "No problems found."
    echo ""
fi


