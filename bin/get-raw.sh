#!/bin/bash
#######################################################################
# This script is intended to perform OAI harvests against contributors'
# OAI-PMH endpoints.
#
# The data retrieved will be the "raw" data, which has not been run
# through an XSLT REPOX processor.
#
# After retrieval, the "raw" data will undergo an XSLT transformation
# that will add supplemental aggregator metadata.  For more details,
# see:  https://www.openarchives.org/OAI/2.0/guidelines-provenance.htm
#
# Once the XML has had the supplemental aggregator metadata inserted,
# it will be ready to re-map the incoming metadata values to the
# appropriate ODN/DPLA fields.
#
# The script will look for information about the target harvest site
# in a 'transform.conf' file in the current directory.  That file is 
# created by running 'gu-setup'.
# 
# Alternately, a REPOX / ODN setSpec can be passed to this script as
# a parameter on the command line and the script will query the MySQL
# database for the appropriate details.
#
# Output from this script is ........................
#
# 
#
#   $SETSPEC-raw--DPLA_PREFIX.xml:  ...........................
# 
#
# $SETSPEC is assumed to be of the REPOX-form:  "contrib_setid"
# It can be found in MySQL under "source > odnSet"
# or in transform.conf as "SETSPEC=contrib_setid"
#
############################################################
# preliminary checks to confirm environment is configured

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
    Either run gt-setup.sh to create a transform.conf,
    or change to the correct directory and try again.

    Alternately, provide the ODN setSpec on the commandline
    as the first option.  For example:

        $ ./get-raw.sh ohmem_p16007coll99

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
    else
        . transform.conf
    fi
    # Retrieve the OAI-PMH metadataPrefix for the harvest from the
    # contributor's server
    SELECT_STATEMENT="select metadataPrefix from source where odnSet='"${SETSPEC}"'"
    ORIG_PREFIX=$(mysql -sNe "$SELECT_STATEMENT")
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


###################################################################
# Preliminary checks OK.  Begin step 1:  Get data from the site.

# We retrieve the contributor's original base OAI-PMH URL from mariadb.
# SETSPEC is set in the transform.conf, dotted earlier in this script.


SELECT_STATEMENT="select oaiSource from source where odnSet='"${SETSPEC}"'"
CONTRIBUTOR_BASE_URL=$(mysql -se "$SELECT_STATEMENT ")

SELECT_STATEMENT="select oaiSet from source where odnSet='"${SETSPEC}"'"
CONTRIBUTOR_SETSPEC=$(mysql -se "$SELECT_STATEMENT")

echo ' '
echo 'Attempting retrieval of OAI-PMH data from source repository:'

if [ -f $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml ]
then
    chmod +w $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml
fi

python3 $SLODPLA_BIN/harvestOAI.py -l $CONTRIBUTOR_BASE_URL -o $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml -s $CONTRIBUTOR_SETSPEC -m $ORIG_PREFIX

cat <<EOF

Data is at:

  $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml
EOF


# Remove write permissions on the newly downloaded files to ensure we don't
# contaminate the data.

chmod 555 $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml



########################################################################################
#
# XML data has been downloaded from contributor's OAI-PMH server.
#
# Begin step 2:  Modify the "raw" XML using XSLT to insert OAI-PMH archival metadata
# as described at https://www.openarchives.org/OAI/2.0/guidelines-provenance.htm


SELECT_STATEMENT="select namespace from metadataSchemas where shortDesignation='$ORIG_PREFIX'"
origMetadataNamespace=$(mysql -sNe "$SELECT_STATEMENT")

cat <<EOF

Beginning XSLT transform to add OAI-PMH aggregator metadata,
and remove the "deleted" records from the data.  One moment...

EOF

java net.sf.saxon.Transform \
    -xsl:$SLODPLA_LIB/archivize-raw-harvest.xsl \
    -s:$SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml \
    -o:$SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml \
     odnSetSpec="$SETSPEC" \
     origMetadataNamespace="$origMetadataNamespace" \
     oaiProvenanceBaseUrl="$CONTRIBUTOR_BASE_URL"

xmllint --format $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml > tmp.xml
sed -e "s/^[ ]*//g" < tmp.xml > 2a.xml
cp tmp.xml $SETSPEC-not_transformed-$ORIG_PREFIX.xml
chmod 664 $SETSPEC-not_transformed-$ORIG_PREFIX.xml
mv tmp.xml $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml

BEFORECOUNT=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/count-records.xsl -s:$SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml)
AFTERCOUNT=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/count-records.xsl -s:$SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml)
let DELETEDCOUNT=$BEFORECOUNT-$AFTERCOUNT
COUNTDATE=$(date +"%Y-%m-%d %H:%M:%S")


#
# The following IF statement's contents aren't indented because
# of the way Bash handles environment variables and indentation
# with cat <<EOF.  It's ugly, but ultimately prettier than it
# might otherwise be.
#
# If there weren't any records in the file we downloaded, then
# something went wrong.  Proceed according to the number of
# records returned.

if [ $BEFORECOUNT -gt 0 ]
then

# add a record to the "recordcount" table of the slo_aggregator DB
# documenting the datetime and record counts for this harvest.
mysql <<EOF
  update recordcount 
  set
     recordCount =  $BEFORECOUNT,
     deletedRecords = $DELETEDCOUNT,
     lastCountDate = '$COUNTDATE'
  where odnSet = '$SETSPEC';
EOF

# update the "source" table's "lastIngest" row for this set
mysql <<EOF
  update source
    set lastIngest = '$(date "+%Y-%m-%d %H:%M:%S")'
  where odnSet = '$SETSPEC';
EOF

# add an entry to the oldTasks table for this harvest to
# track harvest history
mysql <<EOF
  insert into oldTasks (
    oldTaskTime,
    odnSet,
    records
  )
  values
  (
    '$(date "+%Y-%m-%d %H:%M:%S")',
    '$SETSPEC',
    '$AFTERCOUNT'
  );
EOF


cat <<EOF
Finished adding the OAI-PMH aggregator metadata.

$BEFORECOUNT records in; $AFTERCOUNT records out.

Archival output is at:

  $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml

Run a set of diagnostics against the archival data:

    dissect-raw.sh $SETSPEC

That information will be useful when customizing the base-transform XSLT
file, which you'll find at:

  $SLODPLA_LIB/bySet/base-transform/$SETSPEC.xsl

Run the base XSLT transformation on the data to map fields to ODN equivalents:

    base-transform.sh $SETSPEC

EOF

else
# unexpected error; don't insert records
cat<<EOF

   ERROR:  No records found in the OAI-PMH data retrieved

EOF
fi
