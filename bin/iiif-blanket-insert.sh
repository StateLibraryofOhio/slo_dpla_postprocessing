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
#   Output file:  ohmem_p12345coll6_transformed_iiif-blanket-added.xml
#
echo ""

if   [ ! -f transform.conf ]
then
    cat <<'    EOF'

    -- ERROR --
    No 'transform.conf' file found in current directory
    Either run gu-update to create a transform.conf,
    or change to the correct directory and try again.

    EOF
    exit
else
    . transform.conf
fi

if [ "$1" == '' ]
then
    echo "missing parameters.  usage: iiif-blanket-insert.sh ohmem_p12345coll6_transformed.xml"
    echo "output file will be name '..._iiif-blanket-added.xml'"
    exit
else
    echo "parameters received; processing data..."
fi

XMLFILE=$1

NEWFILE=`echo $XMLFILE | sed -e 's/.xml/_iiif-blanket-added.xml/g'`

java net.sf.saxon.Transform -s:$XMLFILE -xsl:$SLODPLA_LIB/iiif-blanket-insert.xsl -o:$NEWFILE
xmllint --format $NEWFILE > 2.dat
mv 2.dat $NEWFILE

IIIF_VIABLE_COUNT=`grep '<dcterms:isReferencedBy>' $NEWFILE | wc -l`
FULL_COUNT=`grep '<record' $NEWFILE | wc -l`

cp $NEWFILE $SETSPEC-DPLA_ready.xml

sed -e "s/^[ ]*//g" $SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml > 2t.xml

cat<<EOF
There are $FULL_COUNT records in this set.
$IIIF_VIABLE_COUNT are viable IIIF records

The output can be found at:  $NEWFILE

To perform a final review of the output, run:

     review-qdc-conversion.sh  $NEWFILE

EOF
