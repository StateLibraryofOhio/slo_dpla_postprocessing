#!/bin/bash
#
# The intent of this script is to download from REPOX 
# a list of all of the OAI setSpecs that are currently
# defined in REPOX.
#
# This list of setSpecs will be dumped to a file.  THE
# SYSADMIN RUNNING THESE SCRIPTS MUST REVIEW THIS FULL
# LIST OF SETS!!!

# Ensure that any sets that should not be uploaded to DPLA 
# are removed from the automatically generated list.
#
# A set might be in the "full" list if it has been defined
# in REPOX, but all records have been removed from REPOX
# because the library is remediating the data, or because
# SLO hasn't yet developed a "qdc" XSLT transformation for
# the set in REPOX.
#
# The file that must be edited is:
#
#    $INGEST_CONFDIR/sets-ready.txt
#
# A copy of the file, intended to be a reflection of the
# un-edited version of the file, will be created at:
#
#   $INGEST_SETUPDIR/sets-available.txt 
#

# Load values set in upload.conf

if [ ! -f conf/upload.conf ]
then
    echo "Run this script with 'conf' as a subdirectory to your CWD."
    echo "  e.g. './bin/01_retrieve-from-REPOX.sh'"
    echo "Exiting."
    echo
    exit
else
    . conf/upload.conf
fi


wget -o $INGEST_SETUPDIR/wget.log -O $INGEST_SETUPDIR/listSets.xml $INGEST_REPOX_URL?verb=ListSets

xmllint --format $INGEST_SETUPDIR/listSets.xml > $INGEST_SETUPDIR/listSets-friendly.xml
grep setSpec $INGEST_SETUPDIR/listSets-friendly.xml | cut -f 2 -d '>' | cut -f 1 -d '<' > $INGEST_SETUPDIR/sets-available.txt

cat $INGEST_SETUPDIR/sets-available.txt | sort > $INGEST_CONFDIR/sets-ready.txt


cat <<END_OF_TEXT

The full list of REPOX setSpecs has been dumped to the 
files:

  $INGEST_SETUPDIR/sets-available.txt

and

  $INGEST_CONFDIR/sets-ready.txt

You should examine the set listing at:

   http://ohiodplahub.library.ohio.gov:8080/repox/resources/RecordCounts.html

...and remove from the "sets-ready.txt" file any setSpecs
 that do not have records to upload to DPLA.

The "sets-available.txt" is simply a version of the file
that you'll know always contains the full list of REPOX 
sets, in case you need the full list for reference after
you begin editing the list of sets you wish to upload.

When you are ready to proceed to the next step, run

  ./bin/01_retrieve-from-REPOX.sh

END_OF_TEXT


