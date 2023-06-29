#!/bin/bash
#
# The intent of this script is to remove from the OAI
# data all references to "deleted" records.  DPLA does
# not want or need this information.
#

# Load values set in upload.conf

if [ ! -f conf/upload.conf ]
then
    echo "Run this script with 'conf' as a subdirectory to your CWD."
    echo "  e.g. './bin/01_retrieve-from-REPOX.sh'"
    echo "Exiting."
    echo
    exit
else
    . conf/upload.conf
fi


INDIR=$INGEST_DATADIR/01__each-set__from_repox
OUTDIR=$INGEST_DATADIR/02__deletes-removed
XSLT=$SLODPLA_LIB/remove-deletes.xsl

#mkdir $INDIR
cd $INDIR
ls | while read SETSPEC
do
    echo '======================================================================================='
    echo "Removing deleted records:   $SETSPEC"
    java net.sf.saxon.Transform -s:$INDIR/$SETSPEC/$SETSPEC-REPOX.xml -xsl:$XSLT -o:$OUTDIR/$SETSPEC/$SETSPEC-REPOX-noDeletes.xml
done

cat <<EOF

Removal of deleted records is complete.  The data can be found at:

  $OUTDIR

The next step is to remove references to deleted records from the data.  To do that, run

  ./bin/03_iiif-insert.sh

EOF
