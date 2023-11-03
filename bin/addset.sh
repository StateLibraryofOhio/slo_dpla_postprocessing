#!/bin/bash
#
# This script is intended to add a new dataset to the list of sets
# harvested by ODN for DPLA.
#
# This script provides an interactive command-line interface which
# seeks input information from the user and performs actions
# based on that input, resulting in the creation of SQL which would
# be run against the MySQL database to add the new set.
#

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


# Option 1 on command line:  site's setSpec for the OAI set.
# This will be used to lookup the metadataPrefix in MySQL.
cat <<EOF

With this script, you will add a new dataset for harvesting into DPLA via Ohio Digital Network.

First, we'll need the name of the data provider.

Here's a list of the existing providers.  If this provider has previously submitted data to the
project, then they will be listed, and you can simply copy/paste that provider name.

If the provider you're working with is not listed, then just enter their name.

EOF

# Query MySQL for existing provider names, dump to screen for user to select
# if the provider has previously submitted data to ODN.

mysql -N -e "select distinct providerName from source;"  slo_aggregator | sed -e 's/^/    /g'

while [ "$PROVIDER" == '' ]
do
cat <<EOF

If the provider is new, then just enter the new provider name below.

Please enter the provider name and hit ENTER:
EOF
echo -n ' >>> '
read PROVIDER
done

cat <<EOF

If this provider has contributed sets before, then any existing OAI-PMH URLs for this provider 
might be listed below:

EOF

mysql -N -e "select distinct oaiSource from source where providerName='$PROVIDER';" slo_aggregator | \
   sed -e 's/^/    /g' \
       -e 's/https:/http:/g' \
       -e 's/\/$//g' | \
       sort | \
       uniq

cat <<EOF

Note that an existing provider can submit a brand new OAI-PMH URL if they have multiple OAI-PMH 
repositories.  Additionally, CONTENTdm servers may have multiple URLs...customized URLs and 
out-of-the-box URLs (e.g. "ohiomemory.org" vs. "cdm16007.contentdm.oclc.org").

EOF

URL=''
while [ "$URL" == '' ]
do
cat <<EOF
Please enter the base OAI-PMH URL for the OAI server hosting this dataset (including the http://)
and hit ENTER:
EOF
echo -n ' >>> '
read URL

if [ "$URL" == '' ]
then
    echo "Error:  You must provide a URL for OAI-PMH harvesting"
elif [ "$URL" != "$(echo $URL| sed -e 's/ //g')" ]
then
    echo "Error:  The URL must begin with http"
    URL=''
fi
done

echo "  ...retrieving data..."

# harvest the list of OAI-PMH metadataFormats from the server and dump to file for later reference
rm -f MetadataFormats.xml
wget  "$URL"'?verb=ListMetadataFormats' -O ListMetadataFormats.xml -o /dev/null

# eliminate the "http[s]" prefix from the OAI-PMH harveste URL, as some of the datasets
# are being harvested from one version of the URL for one collection, and other collections
# are being harvested from the other version of the URL.  This catches both variants 
# when we search MySQL for other sets harvested from this server.
# After this, the URL should be something like "://cdm15716.contentdm.oclc.org/oai/oai.php"
TRIMMED_URL=$(echo $URL | sed -e 's/https\?//g')

# harvest the list of sets available for OAI-PMH harvesting on that server, dump to file for later reference
rm -f ListSets.xml
wget  "$URL"'?verb=ListSets' -O ListSets.xml -o /dev/null

# The following variable will contain all of the setSpecs available for harvesting from the
# remote OAI-PMH server.  It's a string with values delimited by spaces.
ALL_SETS_FROM_SERVER=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/list-all-setSpecs.xsl -s:ListSets.xml)

# The following variable will contain all of the setSpecs that we've already harvested from 
# that server.  It's a string with values delimited by spaces.
SLO_HARVESTED_SET=$(mysql -N -e "select oaiSet from source where oaiSource like '%"$TRIMMED_URL"' order by oaiSet;" slo_aggregator | cut -f 2 | tr '\n' ' ')

# The following variable will contain ONLY the sets on the remote server that we have not
# yet added to this application.  It's a string with values delimited by spaces.
UNHARVESTED_SETS=$(echo $SLO_HARVESTED_SET $ALL_SETS_FROM_SERVER | tr ' ' '\n' | sort | uniq -u | tr '\n' ' ')


cat <<EOF

The sets we are not yet harvesting from that OAI-PMH server are:

    Set Name --- setSpec
EOF

# The "$UNHARVESTED_SETS" list is passed to the print-multiple-setNames.xsl stylesheet, and 
# set names/setSpecs are printed for those sets.  (This ensures we don't define a set for
# harvesting multiple times.)
java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/print-multiple-setNames.xsl -s:ListSets.xml SETSPEC="$UNHARVESTED_SETS" | sed -e 's/^/    /g'

# read the setSpec of the remote collection we're trying to harvest
SETSPEC=''
while [ "$SETSPEC" == '' ]
do
cat <<EOF

Please enter the setSpec (e.g. "p15716coll4") of the collection to be harvested and hit ENTER:
EOF
echo -n ' >>> '
read SETSPEC
done

# use the setSpec to get the set name and store it for later
DESCRIPTION=$(java net.sf.saxon.Transform -s:ListSets.xml -xsl:$SLODPLA_LIB/get-setName.xsl SETSPEC=$SETSPEC | sed -e "s/'/''/g")

# Multiple sites might have a "yearbook" setSpec for their dataset, so it is important that
# we create a set identifier that is locally unique.
ODN_SETSPEC=''
while [ "$ODN_SETSPEC" == '' ]
do
cat <<EOF
=================================================================================================

You need to create a locally-unique identifier, or setSpec, for this dataset.

Our convention is to use a  prefix_setid  syntax, where:

   prefix == something general to all sets from that contributor (e.g. "ohmem")
   setid  == a value unique to that set, typically the setSpec of the source OAI-PMH collection

Some possible options for the "prefix" portion include:

EOF

# Query MySQL for any set prefixes that are already used by this organization.
# Note:  Given that some repositories are used by multiple providers 
#        (e.g. Ohio Memory's CONTENTdm server) it's possible that multiple
#        prefixes could be associated with the same provider, or that
#        multiple providers could be associated with a given prefix.
# Dump list of existing prefixes -- if any -- to screen
mysql -N -e "select distinct substring_index(odnSet, '_', 1) from source where providerName='$PROVIDER' order by odnSet;" slo_aggregator | sed -e 's/^/    /g'

cat <<EOF

Some possible options for a local setSpec (based on guesswork) are:

EOF

# OAI-PMH setSpecs can contain colons, underscores, and potentially other characters
# that could be problematic in filenames.  Sanitize the remote setSpec for inclusion
# in our local setSpec, as it's used in filenames.
SETSPEC_SANITIZED=$(echo $SETSPEC | sed -e "s/^publication:/:/g" -e 's/://g' -e 's/_//g')

# generate sample local setSpec using calculated prefix and sanitized remote setSpec
mysql -N -e "select distinct substring_index(odnSet, '_', 1) from source where providerName='$PROVIDER' order by odnSet;" slo_aggregator | \
    sed -e "s/$/_$SETSPEC_SANITIZED/g" -e "s/^/    /g" 

cat <<EOF

Please enter the ODN setSpec to be used for the new collection and hit ENTER:
EOF
echo -n ' >>> '
read ODN_SETSPEC

ODN_SETSPEC_CHECK=`mysql -N -e "select count(*) from source where odnSet='$ODN_SETSPEC';"`

if [ "$ODN_SETSPEC_CHECK" == '1' ]
then
    echo "Error:  That setSpec is already being used.  Try another."
    ODN_SETSPEC_CHECK=''
    ODN_SETSPEC=''
fi

done


cat <<EOF

The metadataFormats available for harvesting from that OAI server are:
EOF

# parse the previously-retrieved output for metadataFormats available on this server
java net.sf.saxon.Transform -s:ListMetadataFormats.xml -xsl:$SLODPLA_LIB/list-metadataPrefixes.xsl | sort | sed -e 's/^/    /g'

METADATA_FORMAT=''
while [ "$METADATA_FORMAT" == '' ]
do
cat <<EOF

Please enter the metadataFormat to be use when harvesting this collection and hit ENTER:
EOF
echo -n ' >>> '
read METADATA_FORMAT
done

# the selected METADATA_FORMAT will have an associated "schema"; parse the ListSets.xml
# to get that information
METADATA_FORMAT_SCHEMA=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/get-metadataFormat-schema.xsl -s:ListMetadataFormats.xml METADATA_FORMAT=$METADATA_FORMAT ) 

# set default values for other settings
STATUS='unharvested'
EXPORT_DIR_PATH="/opt/repoxdata/$ODN_SETSPEC/export"
TYPE_OF_SOURCE='DataSourceOai'
LAST_INGEST=''
SOURCES_DIR_PATH=''
RETRIEVE_STRATEGY=''
FILE_EXTRACT=''
COUNTDATE=$(date +"%Y-%m-%d %H:%M:%S")


# Create an initial base XSLT transform file for this dataset
cp $SLODPLA_LIB/00_STARTINGPOINT-COLL.xsl $SLODPLA_LIB/bySet/base-transform/$ODN_SETSPEC.xsl
cat <<EOF
===================================================================================
XSLT Transform created at:

    $SLODPLA_LIB/bySet/base-transform/$ODN_SETSPEC.xsl

You will need to edit this file!


EOF


# The result of this script is SQL.  The SQL is dumped to a file,
# and instructions are dumped to the screen for running it against
# the database.
#
# Not running it against the database at this time to avoid 
# accidental creation of entries.
rm -f add-source_$ODN_SETSPEC.sql

cat <<EOF
===================================================================================
EOF

cat >add-source_$ODN_SETSPEC.sql <<EOF

  insert into 
    source (providerName, 
            metadataPrefix,
            sourceSchema,
            lastIngest,
            status,
            typeOfSource,
            description,
            oaiSource,
            oaiSet,
            odnSet,
            sourcesDirPath,
            retrieveStrategy,
            splitRecordsRecordXpath)
    values
           ('$PROVIDER',
            '$METADATA_FORMAT',
            '$METADATA_FORMAT_SCHEMA',
            '$LAST_INGEST',
            '$STATUS',
            '$TYPE_OF_SOURCE',
            '$DESCRIPTION',
            '$URL',
            '$SETSPEC',
            '$ODN_SETSPEC',
            '$SOURCES_DIR_PATH',
            '$RETRIEVE_STRATEGY',
            '$SPLIT_RECORDS');

  insert into
    recordcount
         (odnSet,
          recordcount,
          lastLineCounted,
          deletedRecords,
          lastCountDate,
          lastCountWithChangesDate)
   values
         ('$ODN_SETSPEC',
          0,
          0,
          0,
          '$COUNTDATE',
          '$COUNTDATE');

  insert into
    dataSourceState
         (stateTimeStamp,
          odnSet,
          state)
    values
         ('$COUNTDATE',
          '$ODN_SETSPEC',
          'true');

EOF
# cat add-source_$ODN_SETSPEC.sql

cat <<EOF

The SQL to add the new set has been dumped to:  add-source_$ODN_SETSPEC.sql"

If it looks good, you can load it via:

    mysql < add-source_$ODN_SETSPEC.sql

EOF

# fin

