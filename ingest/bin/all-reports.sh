#!/bin/bash

echo "---------------------------------------------------------------------"
echo "Running the count IIIF by setSpec report..."

./bin/report__count-iiif-by-setspec.sh

echo "---------------------------------------------------------------------"
echo "Running the count isReferencedBy occurs by record report..."

./bin/report__count-isReferencedBy-by-record.sh

echo "---------------------------------------------------------------------"
echo "Running the tally records by edm:rights value report..."

./bin/report__count-records-setspec-setname-by-right.sh

echo "---------------------------------------------------------------------"
echo "Running the count records per setSpec report..."

./bin/report__count-records-setspec-setname.sh

echo "---------------------------------------------------------------------"
echo "Running the 'count | setSpec (running tally)' report..."

./bin/report__count-uploads-by-set.sh

echo "---------------------------------------------------------------------"
echo "Running the edm:rights problems report..."

./bin/report__show-rights-problems.sh
