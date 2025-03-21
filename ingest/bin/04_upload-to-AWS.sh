#!/bin/bash
#
# The intent of this script is to upload the compressed
# files to the DPLA AWS storage.
#


# Load values set in upload.conf

if [ ! -f conf/upload.conf ]
then
    echo "Run this script with 'conf' as a subdirectory to your CWD."
    echo "  e.g. './bin/04_upload-to-AWS.sh'"
    echo "Exiting."
    echo
    exit
else
    . conf/upload.conf
fi

if [ "$INGEST_DESTINATION" == "" ]
then
    echo
    echo "You must set the INGEST_DESTINATION config setting"
    echo "in the conf/upload.conf file before using this script."
    echo "Exiting."
    echo
    exit
fi


INDIR=$INGEST_DATADIR/10_gzipped

#UPLOAD_DIR=$(date +%Y-%m-%d)
UPLOAD_DIR=$INGEST_DESTINATION

cat <<EOBLOCK
This procedure will begin the upload to DPLA.

The data being uploaded is in this directory:

  $INGEST_DATADIR/10_gzipped


The data will be uploaded to:

  s3://dpla-hub-ohio/$UPLOAD_DIR/


Are you ABSOLUTELY SURE you are ready to do this?

Type 'yes' to continue
EOBLOCK


read REQUEST

if [ "$REQUEST" != 'yes' ]
then
    echo "The answer I received wasn't 'yes'.  Aborting upload."
    exit
fi


cd $INDIR
ls *xml.gz | while read XMLFILE
do
    echo "uploading $XMLFILE"
    aws s3 cp $XMLFILE $UPLOAD_DIR/
    sleep 1
done


