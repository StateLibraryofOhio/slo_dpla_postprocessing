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

INDIR=$INGEST_DATADIR/02_titles-checked
OUTDIR_GZ=$INGEST_DATADIR/10_gzipped
OUTDIR_ZIP=$INGEST_DATADIR/10_zipped

if [ ! -d $INDIR ]
then
    echo "Missing expected input directory:  $INDIR"
    exit
fi


if [ ! -d $OUTDIR_GZ ]
then
    mkdir $OUTDIR_GZ
else
    rm -rf $OUTDIR_GZ/*
fi

if [ ! -d $OUTDIR_ZIP ]
then
    mkdir $OUTDIR_ZIP
else
    rm -rf $OUTDIR_ZIP/*
fi

cat <<EOF

Reading from directory:  $INDIR

EOF

cd $INDIR
ls *xml | while read XMLFILE
do
    echo "  Compressing $XMLFILE"
    cp $XMLFILE $OUTDIR_GZ/
    gzip $OUTDIR_GZ/$XMLFILE
    zip $OUTDIR_ZIP/$XMLFILE.zip $XMLFILE
done


cat <<EOF

Compression complete.

The data is available as ZIP format, or GZIP, as you prefer.

  $OUTDIR_GZ
  $OUTDIR_ZIP

The final step in the process is to upload the files to the
DPLA AWS storage.  That can be accomplished via:

  ./bin/04_upload-to-AWS.sh

EOF

