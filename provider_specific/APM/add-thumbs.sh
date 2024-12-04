#!/bin/bash
#
# The intent of this script is to loop through sets specified 
# in the "setList.txt" file and generate in each set's harvest
# directory a "summary.txt" file.
#
# The "summary.txt" file will contain 2 values for every
# edm:isShownAt record in the set.  Value1 is the record's 
# edm:isShownAt value.  Value2 is the corresponding edm:preview
# URL which is harvested from the public-facing site at the
# edm:isShownAt location.
#
# Upon completion, the newly-created "summary.txt" file will be
# used by the "insert-thumbs-from-summary--apm.sh" script, which
# will insert the edm:preview values into the appropriate records.
#

cat setList.txt | while read DIRECTORY
do
    cd $DIRECTORY
    rm summary.txt
    echo " ======== Directory $DIRECTORY ======="
    grep isShownAt 2t.xml | cut -f 2 -d '>' | cut -f 1 -d '<' | while read isShownAt
        do
            wget $isShownAt -o /dev/null -O output.txt
            URL=`grep squarespace-cdn output.txt | cut -f 2 -d '>' | cut -f 1 -d '<'`
            rm output.txt
            echo "$isShownAt - $URL" >> summary.txt
        done
    cd ..
done




