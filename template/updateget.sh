# get-transformed.sh
# get-untransformed.sh

if [ "$1" == '' -o "$2" == '' ]
then
    echo "missing parameters.  usage:  ./updateget.sh SITE_COLL MPREFIX"
else
    echo "got the parms."

    sed -e "s/SITE_COLL/$1/g" < get-transformed.sh > 2.txt
    mv 2.txt get-transformed.sh

    sed -e "s/SITE_COLL/$1/g" < get-untransformed.sh > 2.txt
    mv 2.txt get-untransformed.sh

    sed -e "s/MPREFIX/$2/g" < get-untransformed.sh > 2.txt
    mv 2.txt get-untransformed.sh

    chmod 755 get*sh

    rm -f transform.conf
    touch transform.conf
    echo "DPLA_PREFIX=qdc" >> transform.conf
    echo "ORIG_PREFIX=$2"  >> transform.conf
    echo "SETSPEC=$1"      >> transform.conf
    echo "BASEURL='http://ohiodplahub.library.ohio.gov:8080/repox/OAIHandler'" >> transform.conf

fi


