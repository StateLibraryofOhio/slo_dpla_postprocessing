###############################################################
# This script is used to check the validity of an HTTPS
# connection.  Some of the servers we access use intermediate
# SSL certificates, and OpenSSL's policy is to leave the
# retrieval of intermediate SSL certs to the application.
#
# Intermediate SSL certs will need to be downloaded using a
# trusted browser and then installed on the local system.
# They will also expire on a regular basis, so they need to
# be checked not only during the initial setup of a new
# contributor, but each time that the remote server is 
# accessed.
#

echo "Checking for intermediate SSL certficate problems..."

# check for a null value, which in theory should never happen
if [ "$URL" == '' ]
then
    cat <<-EOF

    There's something wrong with this server URL.
    It doesn't start with 'http' or 'https'.
    Aborting.  Double-check the URL settings.
    
	EOF
    exit
fi

# get server protocol
SOURCE_PROTOCOL=`echo $URL | cut -f 1 -d ':'`

# test whether the URL is https or http.
# don't run the wget if it's just http.
if [ "$SOURCE_PROTOCOL" == "http" ]
then
    echo "The URL protocol isn't HTTPS, so it's not a problem."
else
    WGET_RESULT=`wget -O /dev/null -o - "$URL" | grep 'ERROR: cannot verify' | grep 'certificate, issued by'`
fi

# we now know the source protocol.  Check for problems and
# react accordingly.
if [ "$WGET_RESULT" == '' ]
then
    echo "No intermediate SSL certificate problems detected..."
    echo
else
    cat <<-EOF

    $WGET_RESULT

    Problems detected with the connection.  It is likely that this
    is related to an intermediate SSL certificate.

    OpenSSL assumes that the app developer will handle the full SSL
    certificate chain, and it will not retrieve the full SSL cert
    chain as a result.

    Intermediate SSL certs, which are used by some of ODN's contributors,
    must be downloaded to this server and installed.  These intermediate
    SSL certs can expire, and they must occasionally be re-downloaded
    and re-installed locally.

    To install the intermediate SSL certificate locally:

    - Open Chrome browser on a workstation you trust
    - Load the URL for the contributor's OAI-PMH server:
         $URL
    - View the server's SSL information by clicking on the icon to the
      left of the URL in the browser bar
    - Click on the "Connection is Secure" -> "Certificate is Valid" to
      get to Chrome's "Certificate Viewer"
    - Go to the "Details" tab of the "Certificate Viewer".  Note that
      there will be a hierarchical view of the SSL cert.  For example:
  
         DigiCert Global Root G2
           Encryption Everywhere DV TLS CA - G2
             *.alliancememory.org

    - Click/select on the lowest entry ("*.alliancememory.org" in the 
      example above) and click on the "Export..." button
    - You will be prompted to save a CRT file.  Save it to the local 
      filesystem, making note of where you're saving it
    - Copy the saved CRT file to the nopox server
    - Login to the nopox server as root
    - If it does not already exist, create the directory 
      /usr/share/ca-certificates/odn
    - Copy the CRT file to that directory
    - Run the command "dpkg-reconfigure ca-certificates".  The
      "ca-certificates configuration" UI will appear
    - Choose "Yes" in response to the question "Trust new certificates
      from certificate authorities?" and then "Ok"
    - On the "Certificates to activate:" screen, scroll through the list
      and find the you copied to /usr/share/ca-certificates/odn/
    - Hit the SPACE bar to enable the new CRT.  Save the changes by
      tabbing to "Ok" and hitting ENTER
    - Upon completion of these steps, there should be a .PEM file
      corresponding to your new CRT in the /etc/ssl/certs directory
    - In a temp directory on the server, run
         wget $URL
      to confirm that the connection is successful

    Aborting process due to errors.

	EOF
    exit
fi
