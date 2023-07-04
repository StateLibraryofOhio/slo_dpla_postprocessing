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
# appropriate ODN/DPLA fields, and (if needed) further filtering of
# of the records.
#
# This script will look for information about the target harvest site
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
    exit 1
fi


# Confirm that the MySQL login file is present.
# Config settings are stored in MySQL.

if [ ! -f ~/.my.cnf  ]
then
    cat <<'    EOF'

    -- ERROR --
    No '~/.my.cnf' file found; Required for MySQL login.
    Either create the file, or confirm that permissions
    are correct on the existing file.
    EOF
    exit 1
fi


# Option $1 on command line used to invoke this script:
# site's setSpec for the OAI set.
#
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

        $ ./get-raw.sh ohmem_p16007coll99

    EOF
    exit 1
else
    if [ "$1" != "" ]
    then
        # try using the ODN setSpec submitted on the command line
        SETSPEC=$1
	SELECT_STATEMENT="select count(*) from source where odnSet='"${SETSPEC}"'"
	RESULT=$(mysql -sNe "$SELECT_STATEMENT")
	if [ "$RESULT" == '0' ]
	then
	   echo "That is not a recognized ODN setSpec.  Exiting."
	   echo ""
           exit 1
	fi
	# Retrieve the OAI-PMH metadataPrefix for the harvest from the
        # contributor's server
	SELECT_STATEMENT="select metadataFormat from source where odnSet='"${SETSPEC}"'"
        ORIG_PREFIX=$(mysql -sNe "$SELECT_STATEMENT")
    else
        . transform.conf
    fi
fi


# Confirm that the log directory exists, and is writeable

if [ ! -d "$SLODATA_LOGS" ]
then
    echo "The logging directory does not exist:  $SLODATA_LOGS"
    echo "Aborting."
    echo
    exit 1
elif [ ! -w "$SLODATA_LOGS" ]
then
    echo "The logging directory is not writeable:  $SLODATA_LOGS"
    echo "Aborting."
    echo
    echo 1
fi

LOG_MONTH=$(date +%Y-%m)
if [ ! -d "$SLODATA_LOGS/$LOG_MONTH" ]
then
    mkdir $SLODATA_LOGS/$LOG_MONTH
fi

JOB_LOG=${SETSPEC}_x_$(date +%Y%m%d_%H%m%s).log


###################################################################
# Preliminary checks OK.  Begin step 1:  Get data from the site.

# We retrieve the contributor's original base OAI-PMH URL from mariadb.
# SETSPEC is set in the transform.conf, dotted earlier in this script

#echo ""
#echo "DEBUG:  The SETSPEC is $SETSPEC"

SELECT_STATEMENT="select oaiSource from source where odnSet='"${SETSPEC}"'"
CONTRIBUTOR_BASE_URL=$(mysql -se "$SELECT_STATEMENT ")
#echo "DEBUG:  The CONTRIBUTOR_BASE_URL=$CONTRIBUTOR_BASE_URL"
#echo "DEBUG:  The full SELECT_STATEMENT is $SELECT_STATEMENT"

SELECT_STATEMENT="select oaiSet from source where odnSet='"${SETSPEC}"'"
CONTRIBUTOR_SETSPEC=$(mysql -se "$SELECT_STATEMENT")
#echo "DEBUG:  The CONTRIBUTOR_SETSPEC is $CONTRIBUTOR_SETSPEC"

echo ' '
echo 'Attempting retrieval of OAI-PMH data from source repository:'

if [ -f $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml ]
then
    chmod +w $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml
fi

HARVEST_DATETIME=$(date +"%Y-%m-%d %H:%M:%S")

# the "tee" in the following splits output between screen and logfile
# the "sed" in the following formats the screen output
# the "unbuffer" in the following line allows a line-by-line output to screen; requires installation of "expect" package
unbuffer python3 $SLODPLA_BIN/harvestOAI.py -l $CONTRIBUTOR_BASE_URL -o $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml -s $CONTRIBUTOR_SETSPEC -m $ORIG_PREFIX 2>&1 | sed -e 's/^/  /g' #| tee $SLODATA_LOGS/$LOG_MONTH/$JOB_LOG 

echo "  Job log at:  $SLODATA_LOGS/$LOG_MONTH/$JOB_LOG"
echo "  Data is at:  $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml"

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
#echo " "
#echo "  DEBUG:  $SELECT_STATEMENT"
origMetadataNamespace=$(mysql -sNe "$SELECT_STATEMENT")
#echo "  DEBUG:  origMetadataNamespace=$origMetadataNamespace"
#echo "  --"
#echo "  DEBUG:  oaiProvenanceBaseUrl=$CONTRIBUTOR_BASE_URL"
#echo " "


cat <<EOF

Beginning XSLT transform to add ODN OAI-PMH aggregator metadata and remove the "deleted" records from the data...
EOF

java net.sf.saxon.Transform \
    -xsl:$SLODPLA_LIB/archivize-raw-harvest.xsl \
    -s:$SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml \
    -o:$SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml \
     odnSetSpec="$SETSPEC" \
     origMetadataNamespace="$origMetadataNamespace" \
     oaiProvenanceBaseUrl="$CONTRIBUTOR_BASE_URL"

echo "Reformatting the archivized XML for analysis..."
xmllint --format $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml > tmp.xml
sed -e "s/^[ ]*//g" < tmp.xml > 2a.xml
mv tmp.xml $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml

echo "Counting the records, and records deleted..."
let BEFORECOUNT=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/count-records.xsl -s:$SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml)
let AFTERCOUNT=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/count-records.xsl -s:$SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml)
let DELETED_RECORD_COUNT=$BEFORECOUNT-$AFTERCOUNT


# write a log entry to the database
cat >log-harvest.sql <<EOF
  insert into oldTasks
    (id,
     oldTaskTime,
     dataSourceSet,
     logName,
     ingestType,
     status,
     records,
     retries,
     retriesMax,
     retriesDelay
    )
  values
   ('${SETSPEC}_x',
    '$HARVEST_DATETIME',
    '${SETSPEC}',
    '$LOG_MONTH/$JOB_LOG',
    'incrementalIngest',
    'OK',
    '$BEFORECOUNT',
    '0',
    '3',
    '300'
   );
EOF

# update the source record with the recordcount
UPDATE_STATEMENT="update source set lastIngest='"${HARVEST_DATETIME}"' where odnSet='"${SETSPEC}"'"
CONTRIBUTOR_BASE_URL=$(mysql -se "$UPDATE_STATEMENT ")


echo "Created the SQL to log this harvest in MySQL:  log-harvest.sql"
echo "Running SQL to log this harvest in MySQL..."
mysql < log-harvest.sql
echo

cat <<EOF
====================================================================================

Collecting details about the untransformed metadata to assist in constructing
the base/mapping XSLT.

EOF

# figure out which fields have metadata; used for creating the XSLT base transform
java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/list-fields.xsl -s:2a.xml > fields-with-metadata-in-raw.txt
echo "  Elements sent:"
echo
cat fields-with-metadata-in-raw.txt | sed -e 's/^/    /g'
echo


# check for null elements that we can remove; we don't want to send empty elements to DPLA

rm -f null-elements.txt
grep '/>' 2a.xml | sort | uniq >> null-elements.txt
if [ -s null-elements.txt ]
then
    echo '  *** There are null elements in the original data'
    echo '  *** see file:  null-elements.txt'
else
    echo '  Not finding any null elements in the original data; good.'
fi


# check for semicolons; these may indicate that the field has subfields which should be broken out into their own elements via:
#
#    <xsl:for-each select="tokenize(normalize-space(.), ';')">
#      <xsl:if test="normalize-space(.) != ''">
#        <xsl:element name="dcterms:contributor" namespace="http://purl.org/dc/terms/">
#          <xsl:value-of select="normalize-space(.)"/>
#        </xsl:element>
#      </xsl:if>
#    </xsl:for-each>

rm -f values-with-semicolons.txt
cat 2a.xml | sed -e 's/&amp;//g' | grep ';' >> values-with-semicolons.txt
if [ -s values-with-semicolons.txt ]
then
    echo
    echo '  *** There are semicolons in the data.  Check:  Are they subfields?'
    echo '  *** see file:  values-with-semicolons.txt'
    echo
else
    echo '  Not finding fields with semicolons (possible delimiters)'
    echo 
fi


# checking for encoded < characters, indicative of HTML in the metadata (bad!)

if [ "`grep '&lt;' 2a.xml | wc -l`" -gt 0 ]
then
    echo ""
    echo '  *** Found data that might be HTML tags!'
    echo '  *** see file:  html.txt'
    grep '&lt;' 2a.xml > html.txt
    echo ""
else
    echo "  Did not detect any encoded '<' characters (possible HTML)"
    echo
fi


# checking for dates using the format "1969-01-30T08:00:00Z".  If these exist, then we want to modify
# the transform to truncate beginning with the "T".

if [ "`grep '<date>' 2a.xml | grep T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]*Z | wc -l`" -gt 0 ]
then
   rm -f datevals.txt
   echo ""
   echo "  *** There may be date values using the ISO-8601 format "
   echo "  *** see file:  datevals.txt"
   grep "<date>" 2a.xml | grep "T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]*Z" | head -n 3 | cut -f 2 -d '>' | cut -f 1 -d '<' | sed -e "s/^/   /g" > datevals.txt
   echo ""
else
   echo "  Checking for ISO-8601 date formats:  OK"
   echo ""
fi

echo "Finished.  Use this output to create the initial XSLT for REPOX."
echo "Use the 'bt' command to debug the REPOX transform."
echo ""



echo "$AFTERCOUNT records are ready for consideration for DPLA inclusion."
if [ $DELETED_RECORD_COUNT -gt 0 ]
then
    echo "Deleted records that were removed from the set:  $DELETED_RECORD_COUNT" 
fi
cat <<EOF
Output is at:  $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml

Run the base XSLT transformation on the data to map fields to ODN equivalents:

     base-transform.sh $SETSPEC

EOF

