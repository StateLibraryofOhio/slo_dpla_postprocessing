#!/bin/bash
#
# 
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
XSLT=$INGEST_LIB/count-records-setspec-setname-by-right.xsl
OUTFILE=$INGEST_REPORTDIR/recordcount-setspec-provider-setname-by-right.txt

rm -f $OUTFILE
touch $OUTFILE
cd $INDIR
ls *xml | head -n 3| while read FILENAME
  do
    java net.sf.saxon.Transform  -xsl:$XSLT -s:$INDIR/$FILENAME >> $OUTFILE
    tail -n 1 $OUTFILE
  done
BC_EQUATION=`cut -f 1 -d ' ' $OUTFILE | tr '\n' '+' | sed -e 's/\+$//g'`
TOTAL=`echo $BC_EQUATION | bc`
echo " "
echo " " >> $OUTFILE

echo "$TOTAL records, total" 

echo " " >> $OUTFILE
echo " "
echo "output at:  $OUTFILE"
echo " "
