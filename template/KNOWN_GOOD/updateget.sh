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

fi


