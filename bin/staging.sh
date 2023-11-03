#!/bin/bash
#
# This script is intended to:
#
#   * provide a summary of details that can be copied into an
#     email to Penelope
#
#   * show a command to copy the data to your Windows
#     workstation using pscp
#
#   * show a command to give you a final chance to review
#     the output using the quick, automated scripts which are
#     part of this package.
#
# This script does not change / transform data.
#
# The data will be the "transformed" data, which has run
# through ...
# ...format for upload to DPLA.
#
# There must be a 'transform.conf' file in the current directory
# when this is run.  That file is created by running 'gu-setup'.
#
# Input for this script is 2 files:
#
#
#
#
# Output from this script is dumped to a file named...
#
# For example:
#
#   Input file:   ...
#
#   Output file:  ohmem_p12345coll6-DPLA_ready.zip
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


cat<<EOF
-----------------------------------------------------------

The file has been copied to:

  $SLODATA_STAGING/$SET.xml


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

    review-qdc-conversion.sh  $STAGING_FILE

EOF

