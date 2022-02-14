#
# Abort if the environment hasn't been setup properly

if [ "$SLODPLA_ROOT" == ''  ]
then
   echo "You must first setup your environment with SLO-DPLA-environment.conf"
   exit
fi


#
# get values for details about this dataset:  $DPLA_PREFIX, $ORIG_PREFIX, $SETSPEC, $BASEURL

. transform.conf

#
# confirm that the expected input file is in place,
# and abort with error if it isn't.
#
# Evaluate the command input paramter; use it if it
# is provided AND a valid file.  Exit if it is provided
# but it is not a valid file.
# 
# If no parameter is supplied on the command line, 
# then default to using the "2t.xml", and exit if it does
# not exist.


INPUTFILE=$SETSPEC--review-qdc-conversion-input.xml
INPUTFILE_INDENTED=$SETSPEC-transformed-qdc.xml

if [ "$1" != "" ]
then
    if [ -f "$1" ]
    then
        echo "$1 is a file.  Attempting to use it."
        xmllint --format $1 >  $INPUTFILE_INDENTED
        sed -e "s/^[ ]*//g" < $1 > $INPUTFILE
    else
        echo "  Error:  $1 is not a file."
        echo ""
        echo "  usage:  review-qdc-conversion.sh <inputfile>.xml"
        echo ""
        echo "          <inputfile>.xml is optional if 2t.xml exists"
        echo ""
        exit
    fi
else
    echo "  No filename supplied on command line."
    echo "  Attempting to use 2t.xml"
    if [ ! -f 2t.xml ]
    then
        echo "  Error:  The default '2t.xml' input file is missing."
        echo "          Run the 'gt' utility, then try again."
        echo ""
        exit
    else
        sed -e "s/^[ ]*//g" < 2t.xml > $INPUTFILE
        xmllint --format  2t.xml > $INPUTFILE_INDENTED
    fi
fi


#
# transform harvested data to an eye-friendly form

java net.sf.saxon.Transform  -s:$INPUTFILE -xsl:$SLODPLA_LIB/review-qdc-conversion.xsl -o:review-qdc-conversion-output.xml

xmllint --format review-qdc-conversion-output.xml > 2.txt
mv 2.txt review-qdc-conversion-output.xml


#
# dump a few rows to the screen for the user

cat <<EOF

--- FIRST 30 ROWS OF OUTPUT ---

`head -n 30 review-qdc-conversion-output.xml | sed -e "s/^/    /g"`

EOF

# display the unique edm:rights values in the set
# man, what an awful hack.

ALL_EDM_RIGHTS=$SLODPLA_LIB/ALL_DPLA-accepted_edmRights.txt
ALL_EDM_RIGHTS_COUNT=`wc -l $ALL_EDM_RIGHTS|cut -f 1 -d ' '`

cat <<EOF

Checking edm:rights values in the OAI set.  Full set:

EOF

grep '<edm:rights' $INPUTFILE | sort | uniq | cut -f 2 -d '>' | cut -f 1 -d '<' | sed -e "s/^/    /g"

grep '<edm:rights' $INPUTFILE | sort | uniq | cut -f 2 -d '>' | cut -f 1 -d '<' | while read URI
do
    echo $URI > y.dat
    cat  $ALL_EDM_RIGHTS >> y.dat
    THIS_EDM_RIGHTS_COUNT=`sort y.dat | uniq | wc -l | cut -f 1 -d ' '`
    if [ $ALL_EDM_RIGHTS_COUNT != $THIS_EDM_RIGHTS_COUNT ]
    then
        echo "    ERROR - check this URI:  $URI"
    fi
    rm y.dat

done
echo ""



# confirming site name changed

if [ "`grep 'THIS_PROVIDER_NAME' review-qdc-conversion-output.xml`" == '' ]
then
    echo "Confirming site name changed:  OK"
else
    echo ""
    echo "Confirming site name changed:  ERROR.  Still using default value!"
    echo ""
fi

# confirming collection name changed

if [ "`grep 'THIS_COLLECTION_NAME' review-qdc-conversion-output.xml`" == '' ]
then
    echo "Confirming collection name changed:  OK"
else
    echo ""
    echo "Confirming collection name changed:  ERROR.  Still using default value!"
    echo ""
fi


# checking for ALERT messages in output

if [ "`grep ALERT review-qdc-conversion-output.xml | wc -l`" -gt 0 ]
then
    echo ""
    echo "Found alerts!"
    grep ALERT review-qdc-conversion-output.xml | sort | uniq | sed -e "s/^/               /g"
    echo ""
else
    echo "Checking for alerts:  OK"
fi


# checking for adjacent greater-than/less-than characters
# these are indicative of problems with the XSLT tranform 
# if found, look for values not enclosed in XML tags

if [ "`grep '><' *-transformed-*.xml | wc -l`" -gt 0 ]
then 
    echo "Found adjacent greater-than/less-than characters:"
    grep "><" *-transformed-*.xml
    echo ""
else
    echo "Checking for adjacent greater-than/less-than characters:  OK"
    echo ""
fi

# checking for problems with thumbnails; XSLT is defaulting to CONTENTdm servers and that's pointless for non-CDM sites

grep "<preview>/utils/getthumbnail/collection//id/</preview>" review-qdc-conversion-output.xml > testthumbs.dat
if [ -s testthumbs.dat ]
then
   echo "  *** There are thumbs that are default/incomplete CONTENTdm versions ***"
   echo ""
else
    echo "Looking for incomplete thumbnail URLs:  OK"
fi
rm testthumbs.dat


# check for null elements that we can remove; we don't want to send empty elements to DPLA (or Penelope!)

rm -f null-elements.txt
grep '/>' $INPUTFILE | grep -v -e 'isReferencedBy' | sort | uniq >> null-elements.txt
if [ -s null-elements.txt ]
then
    echo '  *** There are null elements in the original data'
    echo '  *** see file:  null-elements.txt'
    echo
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
cat $INPUTFILE | sed -e 's/&amp;//g' | grep ';' >> values-with-semicolons.txt
if [ -s values-with-semicolons.txt ]
then
    echo
    echo '  *** There are semicolons in the data; check them.'
    echo '  *** see file:  values-with-semicolons.txt'
    echo
fi


# checking for encoded < characters, indicative of HTML in the metadata (bad!)

if [ "`grep '&lt;' $INPUTFILE | wc -l`" -gt 0 ]
then
    echo ""
    echo '  *** Found data that might be HTML tags!'
    echo '  *** see file:  html.txt'
    grep '&lt;' $INPUTFILE > html.txt
    echo ""
fi



# checking for dates using the format "1969-01-30T08:00:00Z".  If these exist, then we want to modify
# the transform to truncate beginning with the "T".

if [ "`grep '<date>' $INPUTFILE | grep T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]*Z | wc -l`" -gt 0 ]
then
   rm -f datevals.txt
   echo ""
   echo "  *** There may be date values using the ISO-8601 format "
   echo "  *** see file:  datevals.txt"
   grep "<date>" $INPUTFILE | grep "T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]*Z" | head -n 3 | cut -f 2 -d '>' | cut -f 1 -d '<' | sed -e "s/^/   /g" > datevals.txt
   echo ""
else
   echo "Checking for ISO-8601 date formats:  OK"
   echo ""
fi

EDM_RIGHTS_COUNT=`grep '<edm:rights>' $INPUTFILE | wc -l`
IS_SHOWN_AT_COUNT=`grep '<edm:isShownAt>' $INPUTFILE | wc -l`

echo "  isShownAt:   = $IS_SHOWN_AT_COUNT ="
echo "  rights:      = $EDM_RIGHTS_COUNT ="

if [ "$EDM_RIGHTS_COUNT" != "$IS_SHOWN_AT_COUNT" ]
then
    echo "  *** There is a discrepancy between edm:isShownAt and edm:rights "
    echo "  *** Confirm that all records have rights"
fi

echo "=============================================================================="


# print out recordcounts and other details for a summary email to Penelope & co.

PROVIDER=`grep edm:dataProvider $INPUTFILE | cut -f 2 -d '>' | cut -f 1 -d '<' | head -n 1`
SETNAME=`grep dcterms:isPartOf $INPUTFILE | cut -f 2 -d '>' | cut -f 1 -d '<' | head -n 1`

IIIF_VIABLE_COUNT=`grep '<dcterms:isReferencedBy>' $INPUTFILE | wc -l`
FULL_COUNT=`grep '<record' $INPUTFILE | wc -l`

cat <<EOF

Data Provider:  $PROVIDER
Set Name:  $SETNAME

There are $FULL_COUNT records in this set.
There are $IIIF_VIABLE_COUNT viable IIIF records.

REPOX setSpec:  $SETSPEC

EOF

# print out URLs for untransformed and transformed
#
#cat <<EOF
#
#Untransformed:  $BASEURL?verb=ListRecords&set=$SETSPEC&metadataPrefix=$ORIG_PREFIX
#
#Transformed:    $BASEURL?verb=ListRecords&set=$SETSPEC&metadataPrefix=$DPLA_PREFIX
#
#EOF

### The following bit should be migrated to a separate "package-it-for-Penelope" script,
### and it should be mindful of the variety of possible data "states", e.g.
###   - straight from REPOX
###   - deletes removed
###   - CDM IIIF tested
###   - non-CDM IIIF inserted
###
### At this point, the data being packaged preceeds all IIIF and deleted record removals
#
# create a .zip file for Penelope's review and spit out the PSCP command to get it to the local workstation

#CWD=`pwd`
#
#echo " "
#echo "Created file for Penelope's review:  $SETSPEC-metadata.zip"
#
#rm -f $SETSPEC-metadata.zip
#zip $SETSPEC-metadata.zip $INPUTFILE_INDENTED $SETSPEC-not_transformed-$ORIG_PREFIX.xml
#echo " "
#echo "   pscp web@catbus:$CWD/$SETSPEC-metadata.zip ."
#echo " "
echo " "
