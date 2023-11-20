#!/bin/bash
#
# This script is intended to remove the Identity Transform
# from set-level XSLT scripts migrated from REPOX.  This
# transform is unnecessary in this non-REPOX environment.
#

ls *xsl | while read FILE
do
   sed -e 's+<xsl:template match="text()|\@\*"/>++g' < $FILE > 2.dat
   mv 2.dat $FILE
done

