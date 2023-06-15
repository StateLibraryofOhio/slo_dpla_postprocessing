#!/bin/bash
#
# The intent of this script is to compress the XML
# files for shipment to DPLA.  Both GZip and ZIP
# files are created, since GZs aren't readable on
# Windows.
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

INDIR=$INGEST_DATADIR/09__staging
OUTDIR_GZ=$INGEST_DATADIR/10__gzipped
OUTDIR_ZIP=$INGEST_DATADIR/10__zipped


rm -rf $OUTDIR_GZ/*
rm -rf $OUTDIR_ZIP/*

cd $INDIR
ls *xml | while read XMLFILE
do
    echo "Compressing $XMLFILE"
    cp $XMLFILE $OUTDIR_GZ/
    gzip $OUTDIR_GZ/$XMLFILE
    zip $OUTDIR_ZIP/$XMLFILE.zip $XMLFILE
done


cat <<EOF

Compression complete.

Available as ZIP format, or GZIP, as you prefer.

  $OUTDIR_GZ
  $OUTDIR_ZIP

The final step in the process is to upload the files to the
DPLA AWS storage.  That can be accomplished via:

  ./bin/06_upload_to_AWS.sh

EOF

