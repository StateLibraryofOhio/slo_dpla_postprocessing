#!/bin/bash
#
# The intent of this script is to create a tab-delimited
# text file that can be opened as a spreadsheet in Excel.
#
# The output will list -- on a collection-by-collection
# basis -- the set name, the REPOX setSpec, the number of
# IIIF records, and the total number of records.  This 
# can be opened in Excel, cleaned up a bit, and sent to
# Penelope for review before uploading.
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
OUTFILE=$INGEST_REPORTDIR/iiif_count_by_collection.txt
PREDIR=`pwd`

rm -f $OUTFILE
cd $INDIR

echo "Record Count	IIIF Viable	Set OAI setSpec	Set Name" >> $OUTFILE

ls *xml | while read FILENAME
do
    IIIFCOUNT=`grep '<dcterms:isReferencedBy>' $FILENAME | wc -l | cut -f 1 -d ' '`
    RECORDCOUNT=`grep '<edm:isShownAt>'  $FILENAME | wc -l | cut -f 1 -d ' '`
    SETNAME=`grep '<dcterms:isPartOf>' $FILENAME | head -n 1 | cut -f 2 -d '>' | cut -f 1 -d '<'`
    SETSPEC=`echo $FILENAME | sed -e 's/.xml//g'`
    echo "$RECORDCOUNT	$IIIFCOUNT	$SETSPEC	$SETNAME" >> $OUTFILE
done

cd $PREDIR

cat <<EOF

A tab-delimited input file showing record counts 
(including IIIF counts) can be found here:

  $INGEST_REPORTDIR/iiif_count_by_collection.txt

EOF
