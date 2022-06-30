#!/bin/bash
#
# The intent of this script is to upload the compressed
# files to the DPLA AWS storage.
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

if [ "$INGEST_DESTINATION" == "" ]
then
    echo
    echo "You must set the INGEST_DESTINATION config setting"
    echo "in the conf/upload.conf file before using this script."
    echo
fi


INDIR=$INGEST_DATADIR/10__gzipped

echo "This procedure will begin the upload to DPLA."
echo "Are you ABSOLUTELY SURE you are ready to do this?"
echo
echo "Type 'yes' to continue"

read REQUEST

if [ "$REQUEST" != 'yes' ]
then
    exit
fi


cd $INDIR
ls *xml.gz | while read XMLFILE
do
    echo "uploading $XMLFILE"
    aws s3 cp $XMLFILE s3://dpla-hub-ohio/2022-03-28/
    sleep 1
done


