#
# This script is intended to retrieve the "desc.all" file for a 
# CONTENTdm collection.  This file would typically only be used
# for debugging and/or analysis.
#
# There must be a '2u.xml' file in the current directory when 
# this is run.  That file is created by running 'get-untransformed.sh'
#
# Input for the script is taken entirely from the transfer.conf
# file.
#
# Output from this script is dumped to a file named XXXXX-desc.all
# "XXXXX" is the SETSPEC listed in the transfer.conf file.
# that follows the underscore.  For example:
#
#   SETSPEC:  ohmem_p16007coll3
#
#   Output filename: p16007coll3-desc.all
# 

if   [ ! -f transform.conf ]
then
    cat <<'    EOF'

    -- ERROR --
    No 'transform.conf' file found in current directory
    Either run gu-update to create a transform.conf,
    or change to the correct directory and try again.

    EOF
    exit
elif [ ! -f 2u.xml ]
then
   cat <<'    EOF'

    -- ERROR --
    No '2u.xml' file found in current directory.
    Either run gu to generate the file, or change
    to the correct directory and try again.

    EOF
    exit
fi

. transform.conf

OUTPUTFILE=$SETSPEC-desc.all
CDM_SETSPEC=`grep 'oaiProvenance:identifier' 2u.xml | head -n 1 | cut -f 2 -d '>' | cut -f 1 -d '/' | cut -f 3 -d ':'`
CDM_WEBSITE=`grep 'oaiProvenance:identifier' 2u.xml | head -n 1 | cut -f 2 -d '>' | cut -f 2 -d ':'`

echo "Beginnng download of the desc.all file from the CONTENTdm Website."
wget 'http://'$CDM_WEBSITE'/diag/inf.php?verb=getdesc&CISOOP=desc&CISOROOT=/'$CDM_SETSPEC -O $OUTPUTFILE

echo "Download complete.  Downloaded file can be found at:  $OUTPUTFILE"
