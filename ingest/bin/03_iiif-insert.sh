#!/bin/bash
#
# IIIF metadata needs to be added to our records.  Whether metadata
# is added to a given record depends upon (a) the set holding the 
# record, and (b) the legal usage rights for the record.  Each record
# must be separately evaluated.
#

# Load values set in upload.conf

if [ ! -f conf/upload.conf ]
then
    echo "Run this script with 'conf' as a subdirectory to your CWD."
    echo "  e.g. './bin/01_retrieve-from-REPOX.sh'"
    echo "Exiting."
    echo
    exit
else
    . conf/upload.conf
fi



STAGINGDIR=$INGEST_DATADIR/03a__iiif_and_deleted_simple_name
OUTDIR=$INGEST_DATADIR/03__iiif-blanket-insert
INDIR=$INGEST_DATADIR/02__deletes-removed
XSLT=$SLODPLA_LIB/iiif-blanket-insert.xsl

rm -rf $STAGINGDIR/* 2>/dev/null
rm -rf $OUTDIR/* 2>/dev/null

cd $INDIR
ls | while read SETSPEC
do
    mkdir $OUTDIR/$SETSPEC
    echo "Beginning $SETSPEC"
    java net.sf.saxon.Transform -o:$OUTDIR/$SETSPEC/$SETSPEC-REPOX-noDeletes-iiif.xml -xsl:$XSLT -s:$INDIR/$SETSPEC/$SETSPEC-REPOX-noDeletes.xml
    cp $OUTDIR/$SETSPEC/$SETSPEC-REPOX-noDeletes-iiif.xml $STAGINGDIR/$SETSPEC.xml
done

cat <<EOF

The process of adding IIIF metadata to the records is complete.
The updated records can be found at:

  $INGEST_DATADIR/03__iiif-blanket-insert

The next step in the process is to remove any records that have 
problems with their edm:rights values (e.g. none at all, multiple).
To run the next step:

  ./bin/04_remove-rights-problems.sh

EOF
