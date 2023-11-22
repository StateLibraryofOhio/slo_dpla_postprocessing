#!/bin/bash
#
# Intent:  Populate the iiifViable value without a fresh harvest
#

ls $SLODATA_STAGING | while read NEWFILE
do
    ODN_SETSPEC=$(echo $NEWFILE | cut -f 1 -d '.')
    IIIF_ELIGIBLE_COUNT=`grep -e '<edm:rights>http://rightsstatements.org/vocab/NoC-US/' \
      -e '<edm:rights>http://creativecommons.org/publicdomain/mark/' \
      -e '<edm:rights>http://creativecommons.org/publicdomain/zero/' \
      -e '<edm:rights>http://creativecommons.org/licenses/by/' \
      -e 'edm:rights>http://creativecommons.org/licenses/by-sa/' \
      $SLODATA_STAGING/$NEWFILE | wc -l`


cat >> iiifViable-insert.sql <<EOF
    IIIF_COUNT_UPDATE_QUERY="update recordcount set iiifViable='$IIIF_ELIGIBLE_COUNT' where odnSet='$ODN_SETSPEC';"
EOF
done
