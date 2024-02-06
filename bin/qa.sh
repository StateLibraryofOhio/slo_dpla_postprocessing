#!/bin/bash
#
# This script is intended to:
#
#   * create a .zip archive containing XML files for review
#     by Penelope
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
if   [ ! -f transform.conf ] && [ "$1" == '' ]
then
    cat <<'    EOF'

    -- ERROR --
    No 'transform.conf' file found in current directory
    and no odnSet was provided.

    Either run gu-update to create a transform.conf,
    or change to the correct directory and try again.

    EOF
    exit
else
    if [ -f transform.conf ]
    then
        . transform.conf
    else
        SETSPEC="$1"
    fi
fi

# get the original metadata prefix, set description, 
# and provider name from MySQL

ORIG_PREFIX=$(mysql -sNe 'select metadataPrefix from source where odnSet="'$SETSPEC'"')
SET=$(mysql -sNe 'select description from source where odnSet="'$SETSPEC'"')
PROVIDER=$(mysql -sNe 'select providerName from source where odnSet="'$SETSPEC'"')

# confirm that input and output files exist
if [ ! -f $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml ]
then
    echo $'\n  Error:  The set has never been harvested.'
    echo $'  Double-check your odnSet value, or run:\n\n    get-raw.sh\n\n'
    exit
elif [ ! -f $SETSPEC-DPLA_ready.xml ]
then
    echo "  The input file $SETSPEC-DPLA_ready.xml is missing."
    echo "  Run gt (and possibly delete-removal and iiif-blanket-insert)"
    echo "  to generate the files"
    echo ""
    exit
fi

rm -f $SETSPEC-DPLA_ready.zip

cp  $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml ./$SETSPEC-not_transformed-$ORIG_PREFIX.xml
zip $SETSPEC-DPLA_ready.zip $SETSPEC-DPLA_ready.xml $SETSPEC-not_transformed-$ORIG_PREFIX.xml

IIIF_ELIGIBLE_COUNT=`grep -e '<edm:rights>http://rightsstatements.org/vocab/NoC-US/' \
      -e '<edm:rights>http://creativecommons.org/publicdomain/mark/' \
      -e '<edm:rights>http://creativecommons.org/publicdomain/zero/' \
      -e '<edm:rights>http://creativecommons.org/licenses/by/' \
      -e 'edm:rights>http://creativecommons.org/licenses/by-sa/' \
      $SETSPEC-DPLA_ready.xml | wc -l`
IIIF_MARKED_COUNT=`grep '<dcterms:isReferencedBy>' $SETSPEC-DPLA_ready.xml | wc -l`
FULL_COUNT=`grep '<record' $SETSPEC-DPLA_ready.xml | wc -l`

EDM_PREVIEW_COUNT=`grep '<edm:preview>' $SETSPEC-DPLA_ready.xml | wc -l`

PROVIDER=`grep edm:dataProvider $SETSPEC-DPLA_ready.xml | head -n 1 | cut -f 2 -d '>'|cut -f 1 -d '<'`
SET=`grep dcterms:isPartOf $SETSPEC-DPLA_ready.xml | head -n 1 | cut -f 2 -d '>'|cut -f 1 -d '<'`


cat<<EOF
-----------------------------------------------------------

ODN:  Re-harvest of "$SET" from $PROVIDER ($SETSPEC)

ODN:  Harvest of "$SET" from $PROVIDER ($SETSPEC)


Data Provider:  $PROVIDER

Set:  $SET

REPOX setSpec:  $SETSPEC


There are $FULL_COUNT records in this set.
$IIIF_MARKED_COUNT records contain IIIF metadata.
$IIIF_ELIGIBLE_COUNT records are eligible for IIIF inclusion based on the edm:rights value.

$EDM_PREVIEW_COUNT records have edm:preview values.


To perform a final review of the output, run:

    review-qdc-conversion.sh  $SETSPEC-DPLA_ready.xml


To copy the files to my desktop:

    pscp $(whoami)@$(hostname -I|sed -e 's/ //g'):`pwd`/$SETSPEC-DPLA_ready.zip .


EOF

