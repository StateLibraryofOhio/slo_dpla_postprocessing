#!/bin/bash

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


STAGINGDIR=$INGEST_DATADIR/09__staging
INDIR=$INGEST_DATADIR/03__iiif-blanket-insert
OUTDIR=$INGEST_DATADIR/04__rights_problems-removed
XSLT=$SLODPLA_LIB/remove-rights-problems.xsl
CWD=$(pwd)


rm -rf $STAGINGDIR
mkdir $STAGINGDIR

rm -rf $OUTDIR
mkdir $OUTDIR

cd $INDIR
ls | while read SETSPEC
do
    mkdir $OUTDIR/$SETSPEC
    echo '======================================================================================='
    echo "Checking rights:  $SETSPEC"
    java net.sf.saxon.Transform -o:$OUTDIR/$SETSPEC/$SETSPEC-REPOX-noDeletes-iiif-noRightsProblems.xml -xsl:$XSLT -s:$INDIR/$SETSPEC/$SETSPEC-REPOX-noDeletes-iiif.xml
    cp $OUTDIR/$SETSPEC/$SETSPEC-REPOX-noDeletes-iiif-noRightsProblems.xml $STAGINGDIR/$SETSPEC.xml
done

cat <<EOF

The data is now -- in theory -- ready to upload to DPLA.
Before doing that, you should review the XML files and 
ensure that everything looks OK.  The files can be found
at:

  $INGEST_DATADIR/09__staging

There are the beginnings of some reporting scripts that 
can be used to summarize the data, tally numbers, etc.
You can find those scripts at:

  $CWD/bin/report*.sh

When you are satisfied with the data, then the next step 
in the process is to compress the finalized files for upload
to DPLA.  To accomplish that:

  ./bin/05_zip-xml-files.sh

EOF
