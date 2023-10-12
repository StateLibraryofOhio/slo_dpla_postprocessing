#!/bin/bash
#
# The intent of this script is to download all metadata for all
# desired sets in REPOX.  Data is put into a separate file for
# each set.
#
# Currently, data is stored in REPOX in a basic form.  REPOX
# serves as a point where data from multiple sources -- i.e. servers
# running CONTENTdm, Drupal, etc. -- is standardized to a single
# format. 
#
# This standardized data will be retrived by this script, and 
# subsequent scripts will further refine it in preparation for
# upload to DPLA.
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

if [ ! -d $INGEST_DATADIR/01__each-set__from_repox ]
then
    echo "Creating directory $INGEST_DATADIR/01__each-set__from_repox"
    mkdir -p $INGEST_DATADIR/01__each-set__from_repox
fi

chmod u+w $INGEST_DATADIR/01__each-set__from_repox
chmod u+w $INGEST_DATADIR/01__each-set__from_repox/* 2>/dev/null

rm -rf $INGEST_DATADIR/01__each-set__from_repox/*
cd $INGEST_DATADIR/01__each-set__from_repox


# The "sets-ready.txt" file is a text file that contains all
# REPOX setSpecs that should be included in the DPLA upload.
# Each setSpec should be on a separate line.
#
# There may be sets in REPOX that are not ready for upload, so
# you will need to review the full list of setSpecs and eliminate
# those that you don't want from the list.
#
# hint:
#
#    * http://ohiodplahub.library.ohio.gov:8080/repox/OAIHandler?verb=ListSets
#    * http://ohiodplahub.library.ohio.gov:8080/repox/resources/RecordCounts.html
#
# and munge the "sets-ready.txt" data appropriately based on 
# those listings.
#

cat $INGEST_CONFDIR/sets-ready.txt | while read SETSPEC
do
    echo '======================================================================================='
    echo " Retrieving:  $SETSPEC"
    echo
    mkdir $SETSPEC
    cd $SETSPEC
    python3 $SLODPLA_BIN/harvestOAI.py \
           -l 'http://ohiodplahub.library.ohio.gov:8080/repox/OAIHandler' \
           -o $SETSPEC-REPOX.xml \
           -m qdc \
           -s $SETSPEC
 
    if [ -f $SLODPLA_LIB/bySet/$SETSPEC.xsl ]
    then
        echo
        echo '************************************************'
        echo "Found collection-specific transform; running it."
        java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/bySet/$SETSPEC.xsl -s:$SETSPEC-REPOX.xml -o:2.dat
        mv 2.dat $SETSPEC-REPOX.xml
    fi


    cd ..
    echo
done

chmod ugo-w $INGEST_DATADIR/01__each-set__from_repox
chmod ugo-w $INGEST_DATADIR/01__each-set__from_repox/* 2>/dev/null

cat <<EOF

Download from REPOX is complete.  The data can be found at:

  $INGEST_DATADIR/01__each-set__from_repox

The next step is to remove references to deleted records from the data.  To do that, run

  ./bin/02_remove-deleted-records.sh

EOF

