#!/bin/bash
#
# The intent of this is to read an inputfile and output the number of records,
# the populated IIIF values, and the number of IIIF-compatible records in
# the data.
#

ls *xml | while read INPUTFILE
do
  PROVIDER=`grep edm:dataProvider $INPUTFILE | cut -f 2 -d '>' | cut -f 1 -d '<' | head -n 1`
  SETNAME=`grep dcterms:isPartOf $INPUTFILE | cut -f 2 -d '>' | cut -f 1 -d '<' | head -n 1`


  IIIF_ELIGIBLE_COUNT=`grep -e '<edm:rights>http://rightsstatements.org/vocab/NoC-US/' \
      -e '<edm:rights>http://creativecommons.org/publicdomain/mark/' \
      -e '<edm:rights>http://creativecommons.org/publicdomain/zero/' \
      -e '<edm:rights>http://creativecommons.org/licenses/by/' \
      -e 'edm:rights>http://creativecommons.org/licenses/by-sa/' \
      $INPUTFILE | wc -l`
  IIIF_MARKED_COUNT=`grep '<dcterms:isReferencedBy>' $INPUTFILE | wc -l`
  FULL_COUNT=`grep '<record' $INPUTFILE | wc -l`


  echo "$PROVIDER|$SETNAME|$FULL_COUNT|$IIIF_MARKED_COUNT|$IIIF_ELIGIBLE_COUNT"
done

