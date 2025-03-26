#!/bin/bash
#
# This script is intended to be used to show the edm:isShownAt
# URLs for records that have been converted to the ODN format
# and have no edm:rights values.
#

if [ "$1" == '' ]
then
    echo "Usage:  show-rightsless.sh INPUT_XML_FILENAME.xml"
    echo
elif [ ! $1 ]
then
    echo "The file specified is not found."
    echo
else
    java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/show-rightsless.xsl -s:$1
fi
