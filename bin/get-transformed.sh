#
# This script is intended to perform OAI harvests against REPOX.
#
# The data retrieved will be the "transformed" data, which has run
# through the XSLT REPOX processor and been syncronized to a similar
# format for upload to DPLA.
#
# With the implementation of IIIF and deleted record removal, the
# output from this script is only the first step in full processing
# prior to upload to DPLA.
# 
# There must be a 'transform.conf' file in the current directory
# when this is run.  That file is created by running 'gu-setup'.
#
# Output from this script is dumped to two files:
#
#   2t.xml: easily greppable
#
#   $SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml: indented for easy casual reading
# 

if [ ! -f transform.conf ]
then
    cat <<'    EOF'

    -- ERROR --
    No 'transform.conf' file found in current directory
    Either run gu-update to create a transform.conf,
    or change to the correct directory and try again.

    EOF
    exit
else
    . transform.conf
fi

python3 $SLODPLA_BIN/harvestOAI.py -l $BASEURL -o $SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml -s $SETSPEC -m $DPLA_PREFIX

if [ -f $SLODPLA_LIB/bySet/$SETSPEC.xsl ]
then
    echo 
    echo '************************************************'
    echo "Found collection-specific transform; running it."
    java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/bySet/$SETSPEC.xsl -s:$SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml -o:2.dat
    mv 2.dat $SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml
fi


xmllint --format $SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml  >2.txt

mv 2.txt $SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml

cp $SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml $SETSPEC-DPLA_ready.xml

sed -e "s/^[ ]*//g" $SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml > 2t.xml


tee outgt.txt <<EOF

Perform some basic diagnostics on the data:

     review-qdc-conversion.sh $SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml

Eliminate deleted records from the dataset:

     delete-removal.sh $SETSPEC-REPOX-transformed-$DPLA_PREFIX.xml

EOF

