#!/bin/bash
#
# This script is intended to remove a set from the system.
#
# This script alters tables and removes files (datafiles
# and XSLT files) from the system.
#
# This script takes an ODN setSpec as a parameter.
#

# First, confirm that our environment will cooperate
if [ "$SLODPLA_ROOT" == "" ]
then
    cat <<'    EOF'
    -- ERROR --
    The SLODPLA_ROOT environment variable is not set.
    Aborting.

    EOF
    exit
fi

# Is MySQL authentication configured?
if [ ! -f ~/.my.cnf  ]
then
    cat <<'    EOF'

    -- ERROR --
    No '~/.my.cnf' file found; Required for MySQL login.
    Either create the file, or confirm that permissions
    are correct on the existing file.

    EOF
    exit
fi

# Has an ODN setSpec been provided on the command line?
if [ "$1" == "" ]
then
    cat <<'    EOF'

    -- ERROR --
    You need to provide the ODN setSpec for the set you
    wish to remove.  e.g.

          remove-set.sh  ohmem_p12345set9  

    EOF
    exit
fi

# confirm the ODN setSpec provided on the command line exists within mysql
ODNSET=$1
ODNSET_TEST=$(mysql -sNe  "select count(*) from source where odnSet='"$ODNSET"';")

if  [ "$ODNSET_TEST" == '0' ]
then
    echo "    -- ERROR --"
    echo "    There is no set configured with the ODN setSpec."
    echo "    Confirm the setSpec and try again."
    echo ""
    exit
fi


# All seems well; Let's begin actually doing stuff.

# Display a warning about what will be removed.
# Gather info about the submitted odnSetspec
#  - set description
#  - provider

PROVIDER=$(mysql -sNe  "select providerName from source where odnSet='"$ODNSET"';")
DESCRIPTION=$(mysql -sNe  "select description from source where odnSet='"$ODNSET"';")
OAISOURCE=$(mysql -sNe  "select oaiSource from source where odnSet='"$ODNSET"';")
OAISET=$(mysql -sNe  "select oaiSet from source where odnSet='"$ODNSET"';")
METADATAPREFIX=$(mysql -sNe  "select metadataPrefix from source where odnSet='"$ODNSET"';")



echo ""
echo "  The following set will be removed from the system:"
cat <<EOF

    $DESCRIPTION
    $PROVIDER
    $OAISOURCE
    $OAISET
    $METADATAPREFIX
    $ODNSET
EOF



cat <<EOF

 The following data files will be removed:

EOF

if [ -f $SLODATA_RAW/$ODNSET-raw-$METADATAPREFIX.xml ] 
then
    echo "   $SLODATA_RAW/$ODNSET-raw-$METADATAPREFIX.xml"
fi

if [ -f $SLODATA_ARCHIVIZED/$ODNSET-odn-$METADATAPREFIX.xml ]
then
    echo "   $SLODATA_ARCHIVIZED/$ODNSET-odn-$METADATAPREFIX.xml"
fi

if [ -f $SLODATA_STAGING/$ODNSET.xml ]
then
    echo "   $SLODATA_STAGING/$ODNSET.xml"
fi

if [ -f $SLODATA_INGEST/$ODNSET.xml ]
then
    echo "   $SLODATA_INGEST/$ODNSET.xml"
fi

echo
echo "  Are you SURE you want to do this?"
echo -n "  y/N >>> "
read CONFIRMATION
if [ "$CONFIRMATION" != "y" ] && [ "$CONFIRMATION" != "Y" ]
then
    echo ""
    echo "   Didn't receive confirmation; aborting."
    echo ""
else
    rm -f $SLODATA_RAW/$ODNSET-raw-.xml \
          $SLODATA_ARCHIVIZED/$ODNSET-odn-.xml \
          $SLODATA_STAGING/$ODNSET.xml \
          $SLODATA_INGEST/$ODNSET.xml 
    mysql -sNe "delete from source where odnSet='"$ODNSET"';"
    mysql -sNe "delete from recordcount where odnSet='"$ODNSET"';"
    mysql -sNe "delete from oldTasks where odnSet='"$ODNSET"';"
    mysql -sNe "delete from setRights where odnSet='"$ODNSET"';"
    echo ""
    echo "  The set has been removed from the system."
fi

if [ -f $SLODPLA_BASEXSLT/$ODNSET.xsl ] || [ -f $SLODPLA_FILTERXSLT/$ODNSET.xsl ]
then
    echo "  Associated XSLT files have not been removed."
    echo "  They can be found at:"

    if [ -f $SLODPLA_BASEXSLT/$ODNSET.xsl ]
    then
        echo "    $SLODPLA_BASEXSLT/$ODNSET.xsl"
    fi

    if [ -f $SLODPLA_FILTERXSLT/$ODNSET.xsl ]
    then
        echo "   $SLODPLA_FILTERXSLT/$ODNSET.xsl"
    fi

    echo ""
    echo "  Do you wish to remove the XSLT files, also?"
    echo -n "  y/N >>> "
    CONFIRMATION=''
    read CONFIRMATION
    if [ "$CONFIRMATION" != "y" ] && [ "$CONFIRMATION" != "Y" ]
    then
        echo ""
        echo "   Didn't receive confirmation; retaining XSLT files."
        echo ""
    else
        rm -f $SLODPLA_BASEXSLT/$ODNSET.xsl $SLODPLA_FILTERXSLT/$ODNSET.xsl
        echo "  Files removed."
        echo ""
    fi
fi
