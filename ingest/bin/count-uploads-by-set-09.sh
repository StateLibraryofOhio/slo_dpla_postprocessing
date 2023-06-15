#!/bin/bash

if [ "$INGEST_BASEDIR" == '' ]
then
    echo "The environment is not setup to run this script."
    echo "Run '. conf/upload.conf' and try again."
fi

INDIR=$INGEST_BASEDIR/data/09__staging
XSLT=/usr/local/SLO-DPLA/lib/count-records.xsl
INGESTCOUNT=$INGEST_BASEDIR/data/ingest-count--stagingdir.txt
let SETCOUNT=0

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
