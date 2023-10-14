#!/bin/bash

ls *xsl | while read FILENAME
do
    sed -e 's/<xsl:template match="()|@"\/>//g' -e 's/omit-xml-declaration="yes"/omit-xml-declaration="no"/g' $FILENAME -e "s|odn_templates.xsl|/usr/local/SLO-DPLA/lib/bySet/base-transform/odn_templates.xsl|g" > 1.dat
    mv 1.dat $FILENAME
done





