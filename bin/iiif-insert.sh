#!/bin/bash
#
# This script is intended to insert IIIF URIs into an XML file.
#
# The input data will be the "transformed" data, which has run
# through the XSLT REPOX processor and been syncronized to a uniform
# format for upload to DPLA.
#
# There must be a 'transform.conf' file in the current directory
# when this is run.  That file is created by running 'gu-setup'.
#
# Input for this script is the name of the file to update.
#
# Output from this script is dumped to a file with an altered name,
# where the file extension is replaced with "_iiif-added.xml".
# For example:
#
#   Input file:   ohmem_p12345coll6_transformed.xml
#
#   Output file:  ohmem_p12345coll6_transformed_iiif-added.xml
#
echo ""

if [ "$1" == '' ]
then
    echo "missing parameters.  usage: iiif-insert.sh  ohmem_p12345coll6_odn-transformed-qdc.xml"
    echo "output file will be named '..._iiif-added.xml'"
    exit
else
    echo "parameters received; processing data..."
fi

XMLFILE=$1

ODN_SETSPEC=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/get-setSpec.xsl -s:$XMLFILE)

echo "I read odnSet of:  $ODN_SETSPEC"

QUERY="select count(odnSet) from source where odnSet='"$ODN_SETSPEC"'"
ROWCOUNT=$(mysql -sNe "$QUERY")

if [ "$ROWCOUNT" == '0' ]
then
    echo "This file contains the following odnSet identifier:  $ODN_SETSPEC"
    echo "This appears to be an invalid identifier."
    exit
fi



NEWFILE=`echo $XMLFILE | sed -e 's/.xml/_iiif-added.xml/g'`

java net.sf.saxon.Transform -s:$XMLFILE -xsl:$SLODPLA_LIB/iiif-blanket-insert.xsl -o:$NEWFILE
xmllint --format $NEWFILE > 2.dat
mv 2.dat $NEWFILE

IIIF_ELIGIBLE_COUNT=`grep -e '<edm:rights>http://rightsstatements.org/vocab/NoC-US/' \
      -e '<edm:rights>http://creativecommons.org/publicdomain/mark/' \
      -e '<edm:rights>http://creativecommons.org/publicdomain/zero/' \
      -e '<edm:rights>http://creativecommons.org/licenses/by/' \
      -e 'edm:rights>http://creativecommons.org/licenses/by-sa/' \
      $NEWFILE | wc -l` 
IIIF_MARKED_COUNT=`grep '<dcterms:isReferencedBy>' $NEWFILE | wc -l`
FULL_COUNT=`grep '<record' $NEWFILE | wc -l`

cp $NEWFILE $ODN_SETSPEC-DPLA_ready.xml

sed -e "s/^[ ]*//g" $ODN_SETSPEC-DPLA_ready.xml > 2t.xml

tee outiiif.txt <<EOF

Complete!

There are $FULL_COUNT records in this set.
$IIIF_MARKED_COUNT records include IIIF metadata.
$IIIF_ELIGIBLE_COUNT records are eligible for IIIF inclusion based on the edm:rights value.

The output can be found at:

  $NEWFILE

To perform a final review of the output, run:

    review-base-transform.sh  $NEWFILE

To copy the data to the Staging area, run:

    staging.sh $NEWFILE 

EOF
