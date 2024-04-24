#!/bin/bash
#
# This script is intended to provide a count of records in each set,
# including as pipe-delimited values in the output:
#
#   recordcount | odnSet ID | set contributor | set name
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


INDIR=$INGEST_DATADIR/02_titles-checked
XSLT=$INGEST_LIB/count-records-setspec-setname.xsl
OUTFILE=$INGEST_REPORTDIR/recordcount-setspec-provider-setname.txt


if [ ! -d $INDIR ]
then
    echo "Missing expected input directory.  Exiting."
    exit
fi


rm -f $OUTFILE
touch $OUTFILE
cd $INDIR
ls *xml | while read FILENAME
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
