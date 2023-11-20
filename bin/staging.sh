#!/bin/bash
#
# This script is intended to copy data to a "Staging" directory
# ($SLODATA_STAGING) where it can be reviewed before formally
# approving it for a DPLA ingest.
#
# This script does not change / transform data.
#
# The data copied to the staging directory will be the 
# "transformed" data, which has run has been through the base
# XSLT transform (and, if applicable, the filter XSLT transform).
#
# This script takes a filename as a commandline parameter,
# where that filename corresponds to the data that has been
# through the XSLT transforms and is ready for Penelope's 
# review.
#
# The filename to pass to this script is the name of the XML
# generate will be presented to you by the prior scripts
# in this procedure.
#
#   Input file:   provided by user on command line
#
#   Output file:  $SLODATA_STAGING/{ODN_SETSPEC}.xml
#
# The script also spits out some basic details about the
# metadata from the file.
#


echo ""

# confirm that the config file exists
if [ "$1" == "" ]
then
    cat <<'    EOF'

    -- ERROR --
    You need to provide the name of the file you wish
    to be staged for Penelope's review as a parameter.   

    EOF
    exit
fi

STAGING_FILE=$1

# confirm that input and output files exist
if  [ ! -f $STAGING_FILE ]
then
    echo "The input file $STAGING_FILE is missing."
    echo "Confirm the filename and try again."
    echo ""
    exit
fi

SETSPEC=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/get-setSpec.xsl -s:$STAGING_FILE)


IIIF_ELIGIBLE_COUNT=`grep -e '<edm:rights>http://rightsstatements.org/vocab/NoC-US/' \
      -e '<edm:rights>http://creativecommons.org/publicdomain/mark/' \
      -e '<edm:rights>http://creativecommons.org/publicdomain/zero/' \
      -e '<edm:rights>http://creativecommons.org/licenses/by/' \
      -e 'edm:rights>http://creativecommons.org/licenses/by-sa/' \
      $STAGING_FILE | wc -l`
IIIF_MARKED_COUNT=`grep '<dcterms:isReferencedBy>' $STAGING_FILE | wc -l`
FULL_COUNT=`grep '<record' $STAGING_FILE | wc -l`

EDM_PREVIEW_COUNT=`grep '<edm:preview>' $STAGING_FILE | wc -l`

PROVIDER=`grep edm:dataProvider $STAGING_FILE | head -n 1 | cut -f 2 -d '>'|cut -f 1 -d '<'`
SET=`grep dcterms:isPartOf $STAGING_FILE | head -n 1 | cut -f 2 -d '>'|cut -f 1 -d '<'`

cp $STAGING_FILE $SLODATA_STAGING/$SETSPEC.xml


# update rights index in MySQL
mysql -sNe "delete from setRights where odnSet='"$SETSPEC"'"
grep edm:rights $STAGING_FILE | cut -f 2 -d '>' | cut -f 1 -d '<' | sort | uniq | while read URI
do
    mysql -sNe  "insert into setRights (odnSet, uri) values ('"$SETSPEC"', '"$URI"');"
done

cat<<EOF
-----------------------------------------------------------

The file has been copied to:

  $SLODATA_STAGING/$SETSPEC.xml


ODN:  Re-harvest of "$SET" from $PROVIDER ($SETSPEC)

ODN:  Harvest of "$SET" from $PROVIDER ($SETSPEC)


Data Provider:  $PROVIDER

Set:  $SET

ODN setSpec:  $SETSPEC


There are $FULL_COUNT records in this set.
$IIIF_MARKED_COUNT records contain IIIF metadata.
$IIIF_ELIGIBLE_COUNT records are eligible for IIIF inclusion based on the edm:rights value.

$EDM_PREVIEW_COUNT records have edm:preview values.


To perform a final review of the output, run:

    review-base-transform.sh  $STAGING_FILE

EOF

