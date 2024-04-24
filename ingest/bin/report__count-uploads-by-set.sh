#!/bin/bash


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


INDIR=$INGEST_DATADIR/02_titles-checked
XSLT=$SLODPLA_LIB/count-records.xsl
INGESTCOUNT=$INGEST_REPORTDIR/ingest-count.txt
let SETCOUNT=0

if [ ! -d $INDIR ]
then
    echo "Missing expected input directory.  Exiting."
    exit
fi

rm -f $INGESTCOUNT
touch $INGESTCOUNT

cd $INDIR
ls | ( while read FILENAME
do
    SETSPEC=`echo $FILENAME | sed -e "s/.xml//g"`
    let SETCOUNT=`java net.sf.saxon.Transform  -xsl:$XSLT -s:$INDIR/$FILENAME`
    echo "$SETCOUNT|$SETSPEC" >> $INGESTCOUNT
    let FULLCOUNT=$FULLCOUNT+$SETCOUNT
    echo "$SETCOUNT | $SETSPEC  ($FULLCOUNT records, total)"
done
echo "$FULLCOUNT"'|All records from all sets' >> $INGESTCOUNT
echo "$FULLCOUNT"'|All records from all sets'
)
