#
# This script is intended to create a version of OAI-harvested XML
# in which the data has been archived as per the requirements put
# forth for OAI-PMH aggregation.
#
#### There must be a 'transform.conf' file in the current directory
#### when this is run.  That file is created by running 'gu-setup'.
#
#### Input for the script must be specified on the command line as an
#### argument to the script.  e.g.  
#
####   $SLODPLA_BIN/delete-removal.sh  ohmem_p16007coll3-transformed-qdc.xml
#
#### Output from this script is dumped to a modified version of the 
#### filename used for input.  The '.xml' in the original filename is
#### replaced with '-noDeletes.xml'.  For example:
#
####   Input:  ohmem_p16007coll3-transformed-qdc.xml
#
####   Output: ohmem_p16007coll3-transformed-qdc-noDeletes.xml
# 


if [ "$1" = "" ]
then
    cat <<'    EOF'

    -- ERROR  Missing required parameters --

    usage:  archivize.sh  ODN_SETSPEC.xml

    EOF
    exit
fi


ODN_SETSPEC=$(echo $1|cut -f 1 -d '-')

OUTDIR=/home/pkukla/full_archivize/all_archivized

echo "begin"
mysql -sNe "describe source"
echo "end"

echo "#####  ODN_SETSPEC:  $ODN_SETSPEC"
OAI_PROVENANCE_BASE_URL=$(mysql -sNe "select oaiSource from source where metadataTransformations='"$ODN_SETSPEC"'") 
echo "#####  OAI_PROVENANCE_BASE_URL=$OAI_PROVENANCE_BASE_URL \n\n\n"

ORIG_PREFIX=$(mysql -sNe "select metadataPrefix from source where odnSet='"$ODN_SETSPEC"'")
echo "#####   ORIG_PREFIX=$ORIG_PREFIX"


ORIG_METADATA_NAMESPACE=$(mysql -sNe "select distinct namespace from metadataSchemas where shortDesignation='"$ORIG_PREFIX"'")
echo "#####  ORIG_PREFIX=$ORIG_METADATA_NAMESPACE \n\n\n"

NEWFILENAME=$(echo "$1" | sed -e "s/.xml/--odn.xml/")




java net.sf.saxon.Transform \
   -xsl:$SLODPLA_LIB/archivize-raw-harvest.xsl \
   -s:$1 \
   -o:$OUTDIR/$NEWFILENAME \
    odnSetSpec=$ODN_SETSPEC \
    origMetadataNamespace=$ORIG_METADATA_NAMESPACE \
    oaiProvenanceBaseUrl=$OAI_PROVENANCE_BASE_URL



