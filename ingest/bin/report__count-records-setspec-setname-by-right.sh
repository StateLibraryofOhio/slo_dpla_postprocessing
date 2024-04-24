#!/bin/bash
#
# This script is intended to tally record numbers for each 
# collection, by edm:right value
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
OUTFILE=$INGEST_REPORTDIR/recordcount-setspec-provider-setname-by-right.txt

rm -f $OUTFILE
touch $OUTFILE
cd $INDIR
cat <<EOF

Beginning analysis of all edm:rights values used.
This may take a while.  Please be patient.

EOF

echo "edm:rights values submitted:" >> $OUTFILE
echo >> $OUTFILE
grep '<edm:rights' *xml | cut -f 2 -d '>' | cut -f 1 -d '<' | sort | uniq | sed -e 's/^/  /g'>> $OUTFILE
echo >> $OUTFILE
echo >> $OUTFILE

grep '<edm:rights' *xml | cut -f 2 -d '>' | cut -f 1 -d '<' | sort | uniq| while read EDM_RIGHT
do
    echo "Records under $EDM_RIGHT:" >> $OUTFILE
    ls *xml | while read XMLFILE
    do
        RIGHT_COUNT=`grep "$EDM_RIGHT" $XMLFILE | wc -l`
        if [ $RIGHT_COUNT -ne '0' ]
        then
            SETSPEC=`echo $XMLFILE | sed -e 's/.xml//g'`
            PROVIDER_QUERY="select providerName from source where odnSet='"$SETSPEC"'"
            PROVIDER_NAME=`mysql -sNe "$PROVIDER_QUERY"`
            SETNAME_QUERY="select description from source where odnSet='"$SETSPEC"'"
            SETNAME=`mysql -sNe "$SETNAME_QUERY"`
            echo "  $RIGHT_COUNT : $SETNAME ($SETSPEC) : $PROVIDER_NAME" >> $OUTFILE
        fi
    done
    echo >> $OUTFILE
done    

#        java net.sf.saxon.Transform  -xsl:$XSLT -s:$INDIR/$FILENAME >> $OUTFILE
#        tail -n 1 $OUTFILE
#    done
#BC_EQUATION=`cut -f 1 -d ' ' $OUTFILE | tr '\n' '+' | sed -e 's/\+$//g'`
#TOTAL=`echo $BC_EQUATION | bc`
#echo " "
#echo " " >> $OUTFILE

#echo "$TOTAL records, total"

#echo " " >> $OUTFILE
#echo " "
cat <<EOF

Complete.  Output at:  $OUTFILE

EOF
