#!/bin/bash
#
# This script is intended to copy "Staged" files into the
# "Ready" directory where they'll sit until they can be
# uploaded to DPLA.
#
# Files are kept in the "Staging" area until the base
# XSLT transform results have been approved by Penelope.
# When that approval has been received, this script will
# be run.
#
# This script does not change / transform data.
#
# Input for this script is an ODN setSpec.  The script
# will look for the corresponding file in the directory
# $SLODATA_STAGING.  That ODN setSpec should be passed
# to this script as a parameter on the command line. e.g.
# 
#   queue4ingest.sh  ohmem_p12345coll6
#
# If the file is not present in the $SLODATA_STAGING
# directory, then it's likely that it wasn't copied there
# by the prior step in this process, the "staging.sh"
# script.
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

