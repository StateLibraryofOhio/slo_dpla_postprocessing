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

Any existing OAI-PMH URIs for this provider will be listed below:

EOF

FRANK=(`mysql -N -e "select distinct oaiSource from source where providerName='$PROVIDER';" slo_aggregator | sed -e 's/^/    /g'`)

mysql -N -e "select distinct oaiSource from source where providerName='$PROVIDER';" slo_aggregator | sed -e 's/^/    /g'

cat <<EOF

Please enter the base OAI-PMH URL for this dataset and hit ENTER:
EOF
echo -n ' >>> '
read URL
echo "  ...retrieving data..."
echo ""
# harvest the list of metadataFormats from the server
rm -f MetadataFormats.xml
wget  "$URL"'?verb=ListMetadataFormats' -O ListMetadataFormats.xml -o /dev/null

# harvest the list of sets, dump list to screen
rm -f ListSets.xml
wget  "$URL"'?verb=ListSets' -O ListSets.xml -o /dev/null
cat <<EOF 
  The sets available for harvesting from that OAI server are:

EOF
java net.sf.saxon.Transform -s:ListSets.xml -xsl:ListSets.xsl | sort | sed -e 's/^/    /g'


SETSPEC=''
while [ "$SETSPEC" == '' ]
do
cat <<EOF

Please enter the setSpec of the desired collection and hit ENTER:
EOF
echo -n ' >>> '
read SETSPEC
done

DESCRIPTION=$(java net.sf.saxon.Transform -s:ListSets.xml -xsl:GetSetDescription.xsl SETSPEC=$SETSPEC | sed -e "s/'/''/g")


ODN_SETSPEC=''
while [ "$ODN_SETSPEC" == '' ]
do
cat <<EOF

Please enter the ODN setSpec to be used for the collection and hit ENTER:
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
cat <<EOF

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


