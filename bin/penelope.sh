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

# confirm that input and output files exist
if  [ ! -f $SETSPEC-not_transformed-$ORIG_PREFIX.xml ]
then
    echo "The input file $SETSPEC-not_transformed-$ORIG_PREFIX.xml is missing."
    echo "Run gt (and possibly delete-removal and iiif-blanket-insert)"
    echo "to generate the files"
    exit
elif [ ! -f $SETSPEC-DPLA_ready.xml ]
then
    echo "The input file $SETSPEC-DPLA_ready.xml is missing."
    echo "Run gt (and possibly delete-removal and iiif-blanket-insert)"
    echo "to generate the files"
    exit
fi

rm -f $SETSPEC-DPLA_ready.zip
zip $SETSPEC-DPLA_ready.zip $SETSPEC-DPLA_ready.xml $SETSPEC-not_transformed-$ORIG_PREFIX.xml

IIIF_VIABLE_COUNT=`grep '<dcterms:isReferencedBy>' $SETSPEC-DPLA_ready.xml | wc -l`
FULL_COUNT=`grep '<record' $SETSPEC-DPLA_ready.xml | wc -l`
EDM_PREVIEW_COUNT=`grep '<edm:preview>' $SETSPEC-DPLA_ready.xml | wc -l`


cat<<EOF
-----------------------------------------------------------


Data Provider:  `grep edm:dataProvider $SETSPEC-DPLA_ready.xml | head -n 1 | cut -f 2 -d '>'|cut -f 1 -d '<'`

Set:  `grep dcterms:isPartOf $SETSPEC-DPLA_ready.xml | head -n 1 | cut -f 2 -d '>'|cut -f 1 -d '<'`

REPOX setSpec:  $SETSPEC


There are $FULL_COUNT records in this set.
$IIIF_VIABLE_COUNT are viable IIIF records.

$EDM_PREVIEW_COUNT records have edm:preview values.


To perform a final review of the output, run:

    review-qdc-conversion.sh  $SETSPEC-DPLA_ready.xml


To copy the files to my desktop:

    pscp web@catbus:`pwd`/$SETSPEC-DPLA_ready.zip .


EOF

