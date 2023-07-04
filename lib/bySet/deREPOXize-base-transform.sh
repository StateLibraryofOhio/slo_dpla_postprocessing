#!/bin/bash
#
# The intent of this script is to change the collection-level
# XSLT files used in REPOX en masse.  The changed files will
# be useable without additional modifications within the new
# XML processing workflow.
#
# Usage:  copy the XSLT files from REPOX's "configuration"
#         directory into a temporary directory and run this
#         script in that directory.
#
# Your SLODPLA environment must be setup.
#

ls *xsl | while read FILENAME
do
    sed -e 's/<xsl:template match="()|@"\/>//g' \
        -e 's/omit-xml-declaration="yes"/omit-xml-declaration="no"/g' \
        -e "s|odn_templates.xsl|$SLODPLA_LIB/bySet/base-transform/odn_templates.xsl|g" \
        $FILENAME > 1.dat
    mv 1.dat $FILENAME
done





