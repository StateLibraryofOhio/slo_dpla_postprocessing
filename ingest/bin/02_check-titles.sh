#!/bin/bash
#
# This script is intended to read through all of the files in the
# $SLODATA_STAGING directory and discard those that do not conform
# to the requirements for the dcterms:title values...i.e. that there
# must at least one value per record uploaded.
#

# Load values set in upload.conf

if [ ! -f conf/upload.conf ]
then
    echo "Run this script with 'conf' as a subdirectory to your CWD."
    echo "  e.g. './bin/02_check-titles.sh'"
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
INGEST_TITLES_CHECKED=$INGEST_DATADIR/02_titles-checked


if [ ! -d $INGEST_RIGHTS_CHECKED ]
then
    echo "Expected input directory not found:  $INGEST_RIGHTS_CHECKED"
    exit
fi


rm -rf $INGEST_TITLES_CHECKED
mkdir  $INGEST_TITLES_CHECKED

cat <<EOF

Reading files from:  $INGEST_RIGHTS_CHECKED

EOF

ls $INGEST_RIGHTS_CHECKED | while read FILENAME
do
    echo "  Processing $FILENAME..."
    java net.sf.saxon.Transform \
        -s:$INGEST_RIGHTS_CHECKED/$FILENAME \
        -xsl:$SLODPLA_LIB/remove-title-problems.xsl \
        -o:$INGEST_TITLES_CHECKED/$FILENAME
done




cat <<EOF


The data has been checked for dcterms:title errors.  Review the
output from this script and make corrections as necessary.

The records that passed this test have been put into this
directory:

    $INGEST_TITLES_CHECKED

These records are now ready to be uploaded to DPLA.  If you
want to take a final look at the data before it's uploaded to
DPLA, this is your last chance.

You might wish to run some of the report scripts in the
directory  $INGEST_BASEDIR/bin

If you are satisfied that the records are ready for DPLA,
then compress the files for the upload:

    ./bin/03_zip-xml-files.sh

EOF
