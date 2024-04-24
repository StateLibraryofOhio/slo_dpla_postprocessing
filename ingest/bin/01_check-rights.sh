#!/bin/bash
#
# This script is intended to read through all of the files in the
# $SLODATA_STAGING directory and discard those that do not conform
# to the requirements for the edm:rights values...i.e. that there
# must be one and only one edm:rights value per record uploaded.
#

# Load values set in upload.conf

if [ ! -f conf/upload.conf ]
then
    echo "Run this script with 'conf' as a subdirectory to your CWD."
    echo "  e.g. './bin/01_check-rights.sh'"
    echo "Exiting."
    echo
    exit
else
    . conf/upload.conf
fi

if [ ! -d $INGEST_DATADIR ]
then
    mkdir $INGEST_DATADIR
fi

INGEST_RIGHTS_CHECKED=$INGEST_DATADIR/01_rights-checked

rm -rf $INGEST_RIGHTS_CHECKED
mkdir  $INGEST_RIGHTS_CHECKED

cat <<EOF

Reading files from:  $SLODATA_STAGING

EOF


ls $SLODATA_STAGING | while read FILENAME
do
    echo "  Processing $FILENAME..."
    java net.sf.saxon.Transform \
        -s:$SLODATA_STAGING/$FILENAME \
        -xsl:$SLODPLA_LIB/remove-rights-problems.xsl \
        -o:$INGEST_RIGHTS_CHECKED/$FILENAME
done




cat <<EOF

The data has been checked for edm:rights errors.  Review the
output from this script and make corrections as necessary.

The records that pass the edm:rights check have been saved 
to the directory:

    $INGEST_RIGHTS_CHECKED

Next, check the records to ensure that they all have at least
one title value:

    ./bin/02_check-titles.sh

EOF
