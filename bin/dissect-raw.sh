#!/bin/bash
########################################################################
# This script is intended to perform an initial analysis of the OAI-PMH
# data which has been harvested from an ODN contributor.
#
# The data analyzed will be the "archivized" data, which has been
# supplemented with OAI-PMH aggregation metadata.
#
# see:  https://www.openarchives.org/OAI/2.0/guidelines-provenance.htm
#
#
# Once the XML has had the supplemental aggregator metadata inserted,
# it will be ready to re-map the incoming metadata values to the
# appropriate ODN/DPLA fields.  This script's output is intended to
# assist with the analysis of the metadata and creation of the
# set-level, "base" XSLT transform
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


# ensure this script is run under the $SLODATA_WORKING
# directory

. $SLODPLA_BIN/check-safewrite.sh


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

        $ ./dissect-raw.sh ohmem_p16007coll99

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
	   echo "That is not a recognized ODN setSpec.  Exiting."
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


# Confirm that this data has been downloaded so we can actually
# analyze it.
if [ ! -f $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml ]
then
    echo "ERROR:  The 'raw' datafile is missing.  I looked here:"
    echo ""
    echo "  $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml"
    echo ""
    echo "You may need to harvest the data from the contributing"
    echo "OAI-PMH server.  This might help:"
    echo ""
    echo "    gr $SETSPEC"
    echo ""
    exit
elif [ ! -f $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml ]
then
    echo "ERROR:  The 'archivized' datafile is missing.  I looked here:"
    echo ""
    echo "  $SLODATA_RAW/$SETSPEC-odn-$ORIG_PREFIX.xml"
    echo ""
    exit

else
    # XML data has been downloaded from contributor's OAI-PMH server
    # AND OAI-PMH metadata has been added to it
    echo "Found the two required datafiles at:"
    echo ""
    echo "  $SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml"
    echo "  $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml"
    echo ""
    cp $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml .
    sed -e "s/^[ ]*//g" $SETSPEC-odn-$ORIG_PREFIX.xml > 2u.xml
fi


# Figure out how many records are in the dataset.  Some records might
# be "deleted" and were removed during the process of adding the 
# OAI-PMH aggregation metadata.

echo "Counting records..."
echo ""
BEFORECOUNT=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/count-records.xsl -s:$SLODATA_RAW/$SETSPEC-raw-$ORIG_PREFIX.xml)
AFTERCOUNT=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/count-records.xsl -s:$SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml)
let DELETEDCOUNT=$BEFORECOUNT-$AFTERCOUNT
COUNTDATE=$(date +"%Y-%m-%d %H:%M:%S")

echo "  Count, raw:  $BEFORECOUNT"
echo "  Count, deleted:  $DELETEDCOUNT"
echo "  Count, archivized:  $AFTERCOUNT"
echo ""


cat <<EOF
Collecting details about the untransformed metadata to assist in 
constructing the set-specific / base XSLT transform.

EOF


# figure out which fields have metadata; You need this information
# when you are creating the set-level XSLT base transform
echo "Determining fields used for sending metadata..."
java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/list-fields.xsl -s:$SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml > fields-with-metadata-in-raw.txt
echo "Complete.  See the list of fields:"
echo ""
echo "    cat fields-with-metadata-in-raw.txt"
echo ""


# check for null elements that we can remove; we don't want to send empty elements to DPLA
rm -f null-elements.txt
grep '/>' $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml | sort | uniq > null-elements.txt
if [ -s null-elements.txt ]
then
    echo '*** There are null elements in the original data'
    echo '*** see file:  null-elements.txt'
    echo ""
fi


# check for semicolons; these may indicate that the field has subfields which should be broken out into their own elements via tokenize:
#
#    <xsl:for-each select="tokenize(normalize-space(.), ';')">
#      <xsl:if test="normalize-space(.) != ''">
#        <xsl:element name="dcterms:contributor" namespace="http://purl.org/dc/terms/">
#          <xsl:value-of select="normalize-space(.)"/>
#        </xsl:element>
#      </xsl:if>
#    </xsl:for-each>

rm -f values-with-semicolons.txt
cat  $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml | sed -e 's/&amp;//g' | grep ';' >> values-with-semicolons.txt
if [ -s values-with-semicolons.txt ]
then
    echo '*** There are semicolons in the data.  Check:  Are they subfields?'
    echo '*** see file:  values-with-semicolons.txt'
    echo ""
else
    echo "Checking for semicolons in the data (potentially delimiters):  OK"
    echo ""
fi


# checking for encoded < characters, indicative of HTML in the metadata (bad!)

if [ "`grep '&lt;' $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml | wc -l`" -gt 0 ]
then
    echo '*** Found data that might be HTML tags!'
    echo '*** see file:  html.txt'
    grep '&lt;'  $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml > html.txt
    echo ""
else
    echo "Checking for potential HTML contamination:  OK"
fi


# checking for dates using the format "1969-01-30T08:00:00Z".  If these exist, then we want to modify
# the transform to truncate beginning with the "T".

if [ "`grep '<date>' $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml | grep T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]*Z | wc -l`" -gt 0 ]
then
   rm -f datevals.txt
   echo "*** There may be date values using the ISO-8601 format "
   echo "*** see file:  datevals.txt"
   grep "<date>" $SLODATA_ARCHIVIZED/$SETSPEC-odn-$ORIG_PREFIX.xml | grep "T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]*Z" | head -n 3 | cut -f 2 -d '>' | cut -f 1 -d '<' | sed -e "s/^/   /g" > datevals.txt
   echo ""
else
   echo "Checking for ISO-8601 date formats:  OK"
   echo ""
fi

cat <<EOF
Finished.

Use this output to customize the set-specific XSLT for this set.
You can find the set-specific XSLT for this set at:

  $SLODPLA_LIB/bySet/base-transform/$SETSPEC.xsl

Use the 'bt' or 'base-transform.sh' command to apply the appropriate
set-specific XSLT transforms against the archivized metadata:

    base-transform.sh $SETSPEC

EOF


