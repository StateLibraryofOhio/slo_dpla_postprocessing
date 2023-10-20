#!/bin/bash
#
# This script is intended to add a new repository to the 
# harvesting/archiving for ODN.
#
# It provides an interactive command-line interface which
# seeks input information from the user:
#
#   - OAI-PMH base harvest URL
#   - Provider name
#
# and it 
#

cat <<EOF

With this script, you will add a new dataset for harvesting into DPLA via Ohio Digital Network.

First, we'll need the name of the data provider.

Here's a list of the existing providers.  Use one of them, or enter a new provider name.

EOF
mysql -N -e "select distinct providerName from source;"  slo_aggregator | sed -e 's/^/    /g'

while [ "$PROVIDER" == '' ]
do
cat <<EOF

Please enter the provider name (either a new provider, or the existing provider as listed above) and hit ENTER:
EOF
echo -n ' >>> '
read PROVIDER
done

cat <<EOF

If this provider has contributed sets before, then any existing OAI-PMH URIs for this provider will be listed below, but an existing provider can submit a brand new OAI-PMH URL:

EOF

#FRANK=(`mysql -N -e "select distinct oaiSource from source where providerName='$PROVIDER';"`)
#cat <<DEBUG
#======================================================
#DEBUG
#for i in "${FRANK[@]}"; do
#  echo "$i"
#done
#
#cat <<DEBUG
#======================================================
#DEBUG

mysql -N -e "select distinct oaiSource from source where providerName='$PROVIDER';" slo_aggregator | sed -e 's/^/    /g'


cat <<EOF

Please enter the base OAI-PMH URL for this dataset and hit ENTER:
EOF
echo -n ' >>> '
read URL
echo "  ...retrieving data..."

# harvest the list of metadataFormats from the server
rm -f MetadataFormats.xml
wget  "$URL"'?verb=ListMetadataFormats' -O ListMetadataFormats.xml -o /dev/null

# harvest the list of sets, dump list to screen
rm -f ListSets.xml
wget  "$URL"'?verb=ListSets' -O ListSets.xml -o /dev/null
ALL_SETS_FROM_SERVER=$(java net.sf.saxon.Transform -xsl:ListAllSetSpecs.xsl -s:ListSets.xml)

cat <<EOF

We are already harvesting the following collections from that server:

EOF
TRIMMED_URL=$(echo $URL | sed -e 's/https\?//g')
echo "===================== $TRIMMED_URL ========================"
SLO_HARVESTED_SET=$(mysql -N -e "select oaiSet from source where oaiSource like '%"$TRIMMED_URL"' order by oaiSet;" slo_aggregator | cut -f 2 | sed -e 's/^/    /g')


cat <<EOF
  ---------------------------------------------------
  The following setSpecs on that server are currently
  NOT being harvested into ODN:

  This is horrifically slow and should be fixed.

EOF

echo $SLO_HARVESTED_SET $ALL_SETS_FROM_SERVER | tr ' ' '\n' | sort | uniq -u | while read THIS_SETSPEC
do
  THIS_SETNAME=$(java net.sf.saxon.Transform -xsl:GetSetName.xsl -s:ListSets.xml SETSPEC=$THIS_SETSPEC)
    #sed -e 's/^/    /g'
  echo "    $THIS_SETSPEC      $THIS_SETNAME"
done

cat <<EOF

  ---------------------------------------------------

press enter to continue...
EOF
read DEBUG


cat <<EOF


The full list of sets available for harvesting from that OAI server are:

    Set Name --- setSpec
EOF

java net.sf.saxon.Transform -s:ListSets.xml -xsl:ListSets.xsl | sort | sed -e 's/^/    /g'


SETSPEC=''
while [ "$SETSPEC" == '' ]
do
cat <<EOF

Please enter the setSpec (e.g. "p15716coll4") of the collection to be harvested and hit ENTER:
EOF
echo -n ' >>> '
read SETSPEC
done

DESCRIPTION=$(java net.sf.saxon.Transform -s:ListSets.xml -xsl:GetSetDescription.xsl SETSPEC=$SETSPEC | sed -e "s/'/''/g")


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
mysql -N -e "select distinct substring_index(odnSet, '_', 1) from source where providerName='$PROVIDER' order by odnSet;" slo_aggregator | sed -e 's/^/    /g'

#mysql -N -e "select distinct oaiSource from source where providerName='$PROVIDER';" slo_aggregator | sed -e 's/^/    /g'

cat <<EOF

Some possible options for a local setSpec (based on guesswork) are:

EOF
SETSPEC_SANITIZED=$(echo $SETSPEC | sed -e "s/^publication:/:/g" -e 's/://g' -e 's/_//g')
mysql -N -e "select distinct substring_index(odnSet, '_', 1) from source where providerName='$PROVIDER' order by odnSet;" slo_aggregator | \
    sed -e "s/$/_$SETSPEC_SANITIZED/g" -e "s/^/    /g" 

cat <<EOF

Please enter the ODN setSpec to be used for the new collection and hit ENTER:
EOF
echo -n ' >>> '
read ODN_SETSPEC
done


cat <<EOF

The metadataFormats available for harvesting from that OAI server are:
EOF
java net.sf.saxon.Transform -s:ListMetadataFormats.xml -xsl:ListMetadataFormats.xsl | sort | sed -e 's/^/    /g'


METADATA_FORMAT=''
while [ "$METADATA_FORMAT" == '' ]
do
cat <<EOF

Please enter the metadataFormat to be use when harvesting this collection and hit ENTER:
EOF
echo -n ' >>> '
read METADATA_FORMAT
done

METADATA_FORMAT_SCHEMA=$(java net.sf.saxon.Transform -xsl:GetMetadataFormatSchema.xsl -s:ListMetadataFormats.xml METADATA_FORMAT=$METADATA_FORMAT ) 


EXPORT_DIR_PATH="/opt/repoxdata/$ODN_SETSPEC/export"

TYPE_OF_SOURCE='DataSourceOai'

RECORD_ID_POLICY_TYPE='IdProvided'

LAST_INGEST=''

SOURCES_DIR_PATH=''

RETRIEVE_STRATEGY=''

FILE_EXTRACT=''

rm -f new-source_$SETSPEC.sql
echo "SQL data is:  ================================================="
cat >new-source_$SETSPEC.sql <<EOF

  insert into 
    source (providerName, 
            metadataFormat,
            sourceSchema,
            lastIngest,
            status,
            typeOfSource,
            description,
            exportDirPath,
            recordIdPolicyType,
            oaiSource,
            oaiSet,
            odnSet,
            sourcesDirPath,
            retrieveStrategy,
            fileExtract,
            splitRecordsRecordXpath)
    values
           ('$PROVIDER',
            '$METADATA_FORMAT',
            '$METADATA_FORMAT_SCHEMA',
            '$LAST_INGEST',
            '$TYPE_OF_SOURCE',
            '$DESCRIPTION',
            '$EXPORT_DIR_PATH',
            '$RECORD_ID_POLICY_TYPE',
            '$URL',
            '$SETSPEC',
            '$ODN_SETSPEC',
            '$SOURCES_DIR_PATH',
            '$RETRIEVE_STRATEGY',
            '$FILE_EXTRACT',
            '$SPLIT_RECORDS')
            
EOF
cat new-source_$SETSPEC.sql
echo " "
echo "The SQL to add the new set has been dumped to:  new-source_$SETSPEC.sql"


# localkey: create-on-insert...nothing is needed for this field
# providerName Akron-Summit County Public Library
#echo "providerName is $PROVIDER"
# metadataFormat: oai_qdc

# sourceSchema: http://dublincore.org/schemas/xmls/qdc/2008/02/11/qualifieddc.xsd
# lastIngest: 2023-07-14 12:57:06
# status: OK

# typeOfSource: DataSourceOai


# recordIdPolicyType: IdProvided

#echo "recordIdPolicyType is NULL"

# oaiSource: http://cdm17124.contentdm.oclc.org/oai/oai.php

#echo "Base OAI-PMH URL:  $URL"

# oaiSet: ohioballet

#echo "The original setSpec:  $SETSPEC"

# odnSet: akronsummit_ballet

#echo "The ODN setSpec:  $ODN_SETSPEC"

# sourcesDirPath:

# retrieveStrategy:

#echo "retrieveStrategy is NULL"

# fileExtract:

#echo "fileExtract is NULL"

# splitRecordsRecordXPath:

#echo "splitRecordsRecordXPath is NULL"


