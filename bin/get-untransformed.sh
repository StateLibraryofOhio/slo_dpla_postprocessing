#
# This script is intended to perform OAI harvests against REPOX.
#
# The data retrieved will be the "un-transformed" data, which has
# not been run through the XSLT REPOX processor, but rather is
# the raw data directly from the contributing library's OAI server.
#
# After retrieving the data, this script runs several diagnostics
# against it to assist in creating the REPOX XSLT.

#
# REQUIREMENTS
#
# There must be a 'transform.conf' file in the current directory
# when this is run.  That file is created by running 'gu-setup'.
#
#
# OUTPUT
#
# The output from this script is intended for use in creating the
# initial XSLT transform that runs on REPOX; Pull the raw data 
# down, analyze it, and figure out what we need to do to make
# the XSLT that results in the "2t.xml" file created by 
# "get-transformed.sh".
#
# File output:
#
#   - 2u.xml: easily greppable
#
#   - $SETSPEC-not_transformed-$ORIG_PREFIX.xml: indented for easy casual reading
#
#   - fields-with-metadata-in-raw.txt - a listing of all of the metadata tags from
#                         the metadata.  Better to use saxon.Gizmo "paths"
#
#   - null-elements.txt - any tags such as <dc:subject/> that can be eliminated 
#                         from the feed via XSLT
#
#   - values-with-semicolons.txt - any metadata values that include semicolons.
#                         These might be subfield indicators. Lots of false positives.
#
#   - html.txt - any values containing encoded "<" characters.  A sign of HTML
#                         in the metadata that can be removed via XSLT.
#
#   - datevals.txt - any date values using the format "1970-01-30T08:00:00Z"
#                         These should be truncated at the "T" before upload via XSLT.
#
# Screen output includes details about very basic tests which help in creating
#

if [ ! -f transform.conf ]
then
    cat <<'    EOF'

  -- ERROR --
  No 'transform.conf' file found in current directory.
  Either run gu-update to create a transform.conf,
  or change to the correct directory and try again.

    EOF
    exit
else
    . transform.conf
fi

# retrieve OAI data for this collection

python3 /usr/local/SLO-DPLA/bin/harvestOAI.py -l $BASEURL -o $SETSPEC-not_transformed-$ORIG_PREFIX.xml -s $SETSPEC -m $ORIG_PREFIX

# make the retrieved data easier to read

xmllint --format $SETSPEC-not_transformed-$ORIG_PREFIX.xml > 2.txt
mv 2.txt $SETSPEC-not_transformed-$ORIG_PREFIX.xml
sed -e "s/^[ ]*//g" < $SETSPEC-not_transformed-$ORIG_PREFIX.xml > 2u.xml


# figure out which fields have metadata
# used for creating the XSLT

java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/list-fields.xsl -s:2u.xml > fields-with-metadata-in-raw.txt

echo ""

# check for null elements that we can remove; we don't want to send empty elements to DPLA

rm -f null-elements.txt
grep '/>' 2u.xml | sort | uniq >> null-elements.txt
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
cat 2u.xml | sed -e 's/&amp;//g' | grep ';' >> values-with-semicolons.txt
if [ -s values-with-semicolons.txt ]
then
    echo
    echo '  *** There are semicolons in the data.  Check:  Are they subfields?'
    echo '  *** see file:  values-with-semicolons.txt'
fi


# checking for encoded < characters, indicative of HTML in the metadata (bad!)

if [ "`grep '&lt;' 2u.xml | wc -l`" -gt 0 ]
then
    echo ""
    echo '  *** Found data that might be HTML tags!'
    echo '  *** see file:  html.txt'
    grep '&lt;' 2u.xml > html.txt
    echo ""
fi


# checking for dates using the format "1969-01-30T08:00:00Z".  If these exist, then we want to modify
# the transform to truncate beginning with the "T".

if [ "`grep '<date>' 2u.xml | grep T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]*Z | wc -l`" -gt 0 ]
then
   rm -f datevals.txt
   echo ""
   echo "  *** There may be date values using the ISO-8601 format "
   echo "  *** see file:  datevals.txt"
   grep "<date>" 2u.xml | grep "T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]*Z" | head -n 3 | cut -f 2 -d '>' | cut -f 1 -d '<' | sed -e "s/^/   /g" > datevals.txt
   echo ""
else
   echo "Checking for ISO-8601 date formats:  OK"
   echo ""
fi

echo ""
echo "Finished.  Use this output to create the initial XSLT for REPOX."
echo "Use the 'gt' command to debug the REPOX transform."
echo ""
