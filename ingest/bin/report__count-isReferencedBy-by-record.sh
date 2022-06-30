#!/bin/bash
#
# The intent of this script is to ensure that no more than
# one "dcterms:isReferencedBy" value exists per record.
#

# Load values set in upload.conf

if [ ! -f conf/upload.conf ]
then
    echo "Run this script with 'conf' as a subdirectory to your cwd."
    echo "Exiting."
    echo
    exit
else
    . conf/upload.conf
fi


INDIR=$INGEST_DATADIR/09__staging
XSLT=$INGEST_LIB/count-isReferencedBy-per-record.xsl

cd $INDIR

cat <<EOF

Analyzing data to determine whether any records have more than 
one dcterms:isReferencedBy value.  If any do, then the transforms
and the original metadata need to be examined more closely.

This may take a few minutes to run.

EOF

ls | ( while read FILENAME
    do
        java net.sf.saxon.Transform -s:$FILENAME -xsl:$XSLT
    done
) | grep -v "^1 | h" > $INGEST_REPORTDIR/count-isReferencedBy-per-record.txt

if [ `wc -l $INGEST_REPORTDIR/count-isReferencedBy-per-record.txt | cut -f 1 -d ' '` -gt 0 ]
then
    echo "Some records have more than 1 isReferencedBy value."
    echo "Research these futher.  Offending records can be seen in:  "
    echo "  $INGEST_REPORTDIR/count-isReferencedBy-per-record.txt"
    echo
else
    echo "No problems found."
    echo ""
fi


