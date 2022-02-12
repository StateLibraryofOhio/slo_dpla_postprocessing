#
# This script is intended to remove XML records that have headers
# marking the records as "deleted".
#
# There must be a 'transform.conf' file in the current directory
# when this is run.  That file is created by running 'gu-setup'.
#
# Input for the script must be specified on the command line as an
# argument to the script.  e.g.  
#
#   $SLODPLA_BIN/delete-removal.sh  ohmem_p16007coll3-transformed-qdc.xml
#
# Output from this script is dumped to a modified version of the 
# filename used for input.  The '.xml' in the original filename is
# replaced with '-noDeletes.xml'.  For example:
#
#   Input:  ohmem_p16007coll3-transformed-qdc.xml
#
#   Output: ohmem_p16007coll3-transformed-qdc-noDeletes.xml
# 

echo "I was interrupted in the middle of this and something is probably broken."

INPUTFILE="review-qdc-conversion-output.xml"
OUTPUTFILE=`echo "$INPUTFILE" | sed -e 's/.xml$/-noDeletes.xml/g'`

if [ "$INPUTFILE" == '' ]
then
    cat <<'    EOF'

    -- ERROR --
    No filenames given as input.
    usage:  delete-removal.sh input-file.xml
    
    The "input-file.xml" should be a "tranformed" file from REPOX.

    EOF
    exit
elif [ ! -f "$INPUTFILE" ]
then
    cat <<'    EOF'

    -- ERROR --
    The input XML file specified was not found.
    usage:  delete-removal.sh input-file.xml

    The "input-file.xml" should be a "tranformed" file from REPOX.
    EOF
    exit

elif   [ ! -f transform.conf ]
then
    cat <<'    EOF'

    -- ERROR --
    No 'transform.conf' file found in current directory
    Either run gu-update to create a transform.conf,
    or change to the correct directory and try again.

    EOF
    exit
fi

. transform.conf

java net.sf.saxon.Transform -s:$INPUTFILE -xsl:$SLODPLA_LIB/remove-deletes.xsl -o:$OUTPUTFILE

BEFORECOUNT=`grep '<record' $INPUTFILE | wc -l`
AFTERCOUNT=`grep '<record' $OUTPUTFILE | wc -l`

cp $OUTPUTFILE $SETSPEC-DPLA_ready.xml
sed -e "s/^[ ]*//g" $SETSPEC-DPLA_ready.xml > 2t.xml

cat <<END_OF_BLOCK

Complete!

$BEFORECOUNT records in; $AFTERCOUNT records out.
Output is:  $OUTPUTFILE

Perform some basic diagnostics on the data:

     review-qdc-conversion.sh $OUTPUTFILE

To add unvalidated IIIF to the data, run:

     iiif-blanket-insert.sh  $OUTPUTFILE

END_OF_BLOCK


