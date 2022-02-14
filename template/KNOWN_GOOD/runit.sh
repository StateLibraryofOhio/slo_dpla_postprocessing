saxon -s:input.xml -xsl:input.xsl -o:output.xml
sed -e "s/></>\n</g" < output.xml >2.txt
mv 2.txt output.xml
xmllint --format output.xml > 2.txt
mv 2.txt output.xml
echo ""
echo "--- FIRST 30 ROWS OF OUTPUT ---" 
echo ""
head -n 30 output.xml
echo ""
echo "  (output truncated)" 
echo ""



# confirming site name changed

if [ "`grep 'THIS_PROVIDER_NAME' output.xml`" == '' ]
then
    echo "Confirming site name changed:  OK"
else
    echo ""
    echo "Confirming site name changed:  ERROR.  Still using default value!"
    echo ""
fi

# confirming collection name changed

if [ "`grep 'THIS_COLLECTION_NAME' output.xml`" == '' ]
then
    echo "Confirming collection name changed:  OK"
else
    echo ""
    echo "Confirming collection name changed:  ERROR.  Still using default value!"
    echo ""
fi


# checking for ALERT messages in output

if [ "`grep ALERT output.xml | wc -l`" -gt 0 ]
then
    echo ""
    echo "Found alerts!"
    grep ALERT output.xml | sort | uniq | sed -e "s/^/               /g"
    echo ""
else
    echo "Checking for alerts:  OK"
fi

# checking for encoded < characters, indicative of HTML

if [ "`grep '&lt;' *-transformed-*.xml | wc -l`" -gt 0 ]
then
    echo ""
    echo "Found data that might be HTML tags!  Look in the html.txt file for more details."
    grep '&lt;' *-transformed-*.xml > html.txt
    echo ""
fi 

# checking for adjacent greater-than/less-than signs

if [ "`grep '><' *-transformed-*.xml | wc -l`" -gt 0 ]
then 
    echo "Found adjacent close-aligator/open-aligator tags:"
    grep "><" *-transformed-*.xml
    echo ""
else
    echo "Checking for adjacent open aligator/close aligator tags:  OK"
fi

grep "<preview>/utils/getthumbnail/collection//id/</preview>" output.xml > testthumbs.dat
if [ -s testthumbs.dat ]
then
   echo "  *** There are thumbs that are default/incomplete CONTENTdm versions ***"
fi
rm testthumbs.dat

echo ""
