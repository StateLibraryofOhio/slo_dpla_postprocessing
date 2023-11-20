#!/bin/bash
#
# This script is intended to run "archivized" data through the initial,
# set-specific XSLT transform for the collection.  The transformation
# will rewrite the XML so that the metadata values are mapped to their
# ODN equivalents (e.g. "dc:title" to "dcterms:title"), thereby
# standardizing the XML so it's using the same ODN Metadata Application
# Profile as the other contributed datasets.
#
# The input data will be the "archivized" data, which has had OAI-PMH
# aggregation metadata added via a non-set-specific  XSLT transform, 
# but which still has the original, set-specific metadata mappings.
#
# The output will be the equivalent of the "transformed" metadata 
# delivered by REPOX.
#
#
# REQUIREMENTS
#
# This script needs a REPOX-style setSpec.
#
# If you run this script with an argument, then this script will
# treat that argument as the desired setSpec.
#
# If you run this script without an argument, then the script will
# attempt to determine the setSpec based on the contents of a
# 'transform.conf' file in the current directory. when this is run.
# That file is created by running 'gu-setup'.
#
# This setSpec is used to lookup the name of the corresponding
# set-specific XSLT file, which is found in the MySQL database in
# the metadataTransformation.stylesheet field.
#
#
# Output from this script is dumped to files:
#
#   $SETSPEC-ODN-transformed-$DPLA_PREFIX.xml:  indented for easy casual reading
#
#   2b.xml:  same content, easily greppable
#
#SET_XSLT_INCLUDEFILE_REPLACEME=$SETSPEC.xsl
#OUTFILE=$SETSPEC-REPOX-transformed-qdc.xml
#
#cat <<EOF
#    echo "INFILE $INFILE"
#    echo "SETSPEC $SETSPEC"
#    echo "SET_XSLT_INCLUDEFILE_REPLACEME $SET_XSLT_INCLUDEFILE_REPLACEME"
#    echo "OUTFILE $OUTFILE"
#
#EOF
#
#sed -e "s/SET_XSLT_INCLUDEFILE_REPLACEME/$SET_XSLT_INCLUDEFILE_REPLACEME/g" < base-template.xsl > base-template_$SETSPEC.xsl
#echo "running transform"
#
#java net.sf.saxon.Transform -s:$INFILE -xsl:base-template_$SETSPEC.xsl -o:$OUTFILE
#
#xmllint --format $OUTFILE > 2.dat
#mv 2.dat $OUTFILE
#
#echo "Completed. Output file will be named $OUTFILE"
#
#echo '============================================================================================'
## base-transform.sh (arg1 - optional)
##  a.k.a. "bt"


###
### determine which set we're processing
###
echo " "
if [ "$SLODPLA_LIB" == '' ]
then
    echo "The SLODPLA_ROOT environment variable is not configured."
    echo "Aborting."
    echo
    exit
else
    BASE_TRANSFORM_DIR=$SLODPLA_LIB/bySet/base-transform
fi
if [ "$1" != "" ]
then
    ODN_SETSPEC=$1
elif [ -f transform.conf ]
then
    echo "Transform.conf file exists in the current directory.  Using it."
    . transform.conf
    ODN_SETSPEC=$SETSPEC
else
    echo " Error:  No setSpec provided on command line,"
    echo "         and no transform.conf file in cwd."
    echo " "
    echo " usage:  base-transform.sh ODN_SETSPEC"
    echo " "
    echo " Run it with a transform.conf file in this"
    echo " directory to get the SETSPEC automatically."
    echo " "
    exit
fi

###
### confirm setSpec is valid
###

QUERY_RESULT=$(mysql -sNe "select count(*) from source where odnSet='"$ODN_SETSPEC"'")

if [ "$QUERY_RESULT" = '0' ]
then
    echo "Error:  The setSpec provided ($ODN_SETSPEC) is not in the database"
    echo ""
    exit
fi


###
### confirm that a base transform exists: 2-step process
###

#
# step 1:  find the filename listed in the "metadataTransformation" table
#

##### query db to get transform filename
#####BASE_TRANSFORM_FILE=$(mysql -sNe "select stylesheet from metadataTransformation where idRepox='"$ODN_SETSPEC"'")

BASE_TRANSFORM_FILE=$ODN_SETSPEC.xsl


# test result for no matches
if [ "$BASE_TRANSFORM_FILE" == "" ]
then
    "ERROR:  no matching base transform associated with this setSpec"
    echo " "
else
    echo "Set:  $ODN_SETSPEC"
    echo "Associated XSLT:  $BASE_TRANSFORM_FILE"
fi

#
# step 2:  confirm the file exists on the filesystem
#

if [ ! -f $BASE_TRANSFORM_DIR/$BASE_TRANSFORM_FILE ]
then
  echo "Error:  transform file not found on filesystem.  Looked for:"
  echo "        $BASE_TRANSFORM_DIR/$BASE_TRANSFORM_FILE"
  exit
  else
  echo "Found XSLT:  $BASE_TRANSFORM_DIR/$BASE_TRANSFORM_FILE"
fi


###
### confirm that the input file exists on the filesystem
###

# step 1: ID the base transform for

QUERY="select metadataPrefix from source where odnSet='"$ODN_SETSPEC"'"
ORIGINAL_METADATA_FORMAT=$(mysql -sNe "$QUERY")

if [ ! -f $SLODATA_ARCHIVIZED/$ODN_SETSPEC-odn-$ORIGINAL_METADATA_FORMAT.xml ] 
then
    echo "Error:  Input file not found on filesystem."
    echo "        Looked for:  $SLODATA_ARCHIVIZED/$ODN_SETSPEC-odn-$ORIGINAL_METADATA_FORMAT.xml"
    exit
else
    echo "Input file found:  $SLODATA_ARCHIVIZED/$ODN_SETSPEC-odn-$ORIGINAL_METADATA_FORMAT.xml"
fi


#echo $QUERY_RESULT

#if [ ! -f $SLODATA_ARCHIVIZED/ ]


###
### Run the base "metadata mapping" transform against the "archivized" data
###

#
# Create a copy of the base transform template, updating it to point to 
# the appropriate set-specific XSLT file.  As far as I can tell, this
# cannot be handled via XSLT variables.
#
sed -e "s|SET_XSLT_INCLUDEFILE_REPLACEME|$BASE_TRANSFORM_DIR/$BASE_TRANSFORM_FILE|g" < $SLODPLA_LIB/base-template.xsl > base-transform.xsl
echo "Created set-specific transform:  ./base-transform.xsl"

#
# Run the base transform against the "archivized" XML
#

echo " "
echo "Running base transform..."

java net.sf.saxon.Transform \
     -xsl:./base-transform.xsl \
     -s:$SLODATA_ARCHIVIZED/$ODN_SETSPEC-odn-$ORIGINAL_METADATA_FORMAT.xml \
     -o:tmp.xml
xmllint --format tmp.xml > $ODN_SETSPEC-odn-transformed-qdc.xml
rm tmp.xml



#* create a local copy of the XSL to include the set-specific XSLTs?

#<<<------------------------------------------------->>>

#
# Is there another set-specific XSLT to run?  Check.
#

if [ -f $SLODPLA_LIB/bySet/filter-transform/$ODN_SETSPEC.xsl ]
then
    echo
    echo '************************************************'
    echo "Found collection-specific transform; running it."
    java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/bySet/filter-transform/$ODN_SETSPEC.xsl -s:$ODN_SETSPEC-odn-transformed-qdc.xml -o:2.dat
    mv 2.dat $ODN_SETSPEC-odn-transformed-qdc.xml
fi


xmllint --format $ODN_SETSPEC-odn-transformed-qdc.xml >2.txt

mv 2.txt $ODN_SETSPEC-odn-transformed-qdc.xml

cp $ODN_SETSPEC-odn-transformed-qdc.xml $ODN_SETSPEC-DPLA_ready.xml

sed -e "s/^[ ]*//g" $ODN_SETSPEC-odn-transformed-qdc.xml > 2t.xml

BEFORECOUNT=$(java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/count-records.xsl -s:$SLODATA_ARCHIVIZED/$ODN_SETSPEC-odn-$ORIGINAL_METADATA_FORMAT.xml)
AFTERCOUNT=$(java  net.sf.saxon.Transform -xsl:$SLODPLA_LIB/count-records.xsl -s:2t.xml)

tee outgt.txt <<EOF

Record counts:

  Pre-transform:  $BEFORECOUNT
  Post-transform: $AFTERCOUNT

Perform some basic diagnostics on the data:

    review-base-transform.sh $ODN_SETSPEC-odn-transformed-qdc.xml

To add unvalidated IIIF to the data, run:

    iiif-insert.sh  $ODN_SETSPEC-odn-transformed-qdc.xml

EOF

