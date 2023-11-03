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

if [ "$SLODPLA_ROOT" == "" ]
then
    cat <<'    EOF'

    -- ERROR --
    The SLODPLA_ROOT environment variable is not set.
    Aborting.

    EOF
    exit
fi


# Option 1 on command line:  site's setSpec for the OAI set.
# This will be used to lookup the metadataPrefix in MySQL.

if [ ! -f transform.conf ] && [ "$1" == "" ]
then
    cat <<'    EOF'

    -- ERROR --
    No 'transform.conf' file found in current directory.
    Either run gu-update to create a transform.conf,
    or change to the correct directory and try again.

    Alternately, provide the ODN setSpec on the commandline
    as the first option.  For example:

        $ ./queue4ingest.sh ohmem_p16007coll99

    EOF
    exit
else
    if [ "$1" != "" ]
    then
        SETSPEC=$1
        SELECT_STATEMENT="select count(*) from source where odnSet='"${SETSPEC}"'"
        RESULT=$(mysql -sNe "$SELECT_STATEMENT")
        if [ "$RESULT" == '0' ]
        then
           echo "    -- ERROR --"
           echo "    That is not a recognized ODN setSpec.  Exiting."
           echo ""
           exit

        fi
        # Retrieve the OAI-PMH metadataPrefix for the harvest from the
        # contributor's server
        SELECT_STATEMENT="select metadataPrefix from source where odnSet='"${SETSPEC}"'"
        ORIG_PREFIX=$(mysql -sNe "$SELECT_STATEMENT")
    else
        . transform.conf
    fi
fi

if [ ! -f ~/.my.cnf  ]
then
    cat <<'    EOF'

    -- ERROR --
    No '~/.my.cnf' file found; Required for MySQL login.
    Either create the file, or confirm that permissions
    are correct on the existing file.

    EOF
    exit
fi




STAGING_FILE=$SLODATA_STAGING/$SETSPEC.xml

# confirm that input and output files exist
if  [ ! -f $STAGING_FILE ]
then
    echo "Error:  The input file $STAGING_FILE is missing."
    echo "Ensure that the base XSLT transform has been run for this set."
    echo ""
    exit
fi

cp $STAGING_FILE $SLODATA_READY/$SETSPEC.xml


cat<<EOF
-----------------------------------------------------------

The file has been copied to:

  $SLODATA_READY/$SETSPEC.xml

To perform a final review of the output, run:

    review-base-transform.sh  $SLODATA_READY/$SETSPEC.xml

EOF

