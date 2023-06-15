This is a set of scripts which will be used for preparing
XML data for upload to DPLA.

The lifecycle of the process is as follows:

 - Site makes their metadata available for harvesting
 - SLO loads the data into REPOX
 - SLO creates an XSLT file in REPOX that transforms the metadata from 
   its unique format to a uniform, standardized format ("QDC")
 - SLO exports the QDC data from REPOX into separate files, one for 
   each REPOX set
 - SLO removes "deleted record" references from the QDC data
 - SLO adds IIIF metadata to qualifying records in the QDC data
 - SLO removes from the QDC data any records that have problems with 
   accessibility rights
 - SLO compresses the XML files for upload to DPLA
 - SLO uploads the compressed XML files to DPLA on the date that DPLA 
   specifies

I have attempted to automate as much of this as possible, and to 
do so in a manner that allows for easier debugging if there are 
problems during the process.  There will still be some manual work 
on the part of the user, however.


Pre-requisites
 - Java
 - Saxon XSLT
 - Python 3
 - https://github.com/StateLibraryofOhio/slo_dpla_postprocessing



The general procedure is to:

1. Copy this directory structure to a new location for this upload

   All files downloaded/manipulated will be contained within this
   copied directory.  Allow for AT LEAST 9 Gb of drive space, and 
   assume that number will grow as time passes.  (today: 6/24/2022)


2. Edit the "conf/upload.conf" file

   The "conf/upload.conf" file contains a variable that points to
   your copy of the directory structure.  This variable is commented
   out, and must be un-commented and altered to point at your chosen
   storage location.


3. Run the scripts in the "bin" directory in the appropriate order

   The scripts are mostly prefaced with a number or "report__".

   The scripts prefaced with numbers should be run in the order of
   the numbers.  i.e. first run the "00_" script, then the "01_" 
   script, and so on.


