#
# change SITE_COLL to the desired value
#


python harvestOAI.py -l 'http://ohiodplahub.library.ohio.gov:8080/repox/OAIHandler' -o SITE_COLL-not_transformed-qualified-dublin-core.xml -s SITE_COLL -m MPREFIX

xmllint --format SITE_COLL-not_transformed-qualified-dublin-core.xml > 2.txt

mv 2.txt SITE_COLL-not_transformed-qualified-dublin-core.xml

sed -e "s/^[ ]*//g" < SITE_COLL-not_transformed-qualified-dublin-core.xml > 2u.xml

grep '^<' 2u.xml | cut -f 1 -d '>' | sort | uniq | grep -v '^</' > fields-with-metadata-in-raw.txt

grep '/>' 2u.xml | sort | uniq > fields-with-null-elements-in-raw.txt




