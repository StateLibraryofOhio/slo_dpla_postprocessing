#
# change SITE_COLL to the desired value
#


python harvestOAI.py -l 'http://ohiodplahub.library.ohio.gov:8080/repox/OAIHandler' -o SITE_COLL-transformed-qdc.xml -s SITE_COLL -m qdc

xmllint --format SITE_COLL-transformed-qdc.xml  >2.txt

mv 2.txt SITE_COLL-transformed-qdc.xml

sed -e "s/^[ ]*//g" SITE_COLL-transformed-qdc.xml > 2t.xml

cp 2t.xml input.xml


