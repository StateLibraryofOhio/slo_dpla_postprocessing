This is a set of scripts which will be used for preparing
XML data for upload to DPLA.

The lifecycle of the process is as follows:

 - Site makes their metadata available for harvesting
 - SLO harvests the data via OAI-PMH
 - SLO removes "deleted" records from the harvested data
 - SLO creates an XSLT file to map the metadata in the incoming
   XML file to the ODN standard
 - Optionally, a second XSLT file is created which will be used
   to remove additional records from the data provided by the
   contributor.  This is only necessary when the data provided
   includes instructions along the lines of "...but exclude from
   the upload any records with a 'dc:subject' value of 'Boris'"
 - SLO adds IIIF metadata to qualifying records in the QDC data
   for those datasets that have been flagged as contributing to
   WikiMedia
 - SLO removes from the QDC data any records that have problems with 
   accessibility rights, missing required fields, etc.
 - SLO compresses the XML files for upload to DPLA
 - SLO uploads the compressed XML files to DPLA on the date that DPLA 
   specifies

I have attempted to automate as much of this as possible, and to 
do so in a manner that allows for easier debugging if there are 
problems during the process.  There will still be some manual work 
on the part of the user, however.


The general procedure is to:

1. Copy this directory structure to a new location for this upload

   All files downloaded/manipulated will be contained within this
   copied directory.  Allow for AT LEAST 9 Gb of drive space, and 
   assume that number will grow as time passes.  (today: 6/24/2022)

   I recommend copying the data to the $SLODATA_INGEST directory,
   as it should be defined to be on a separate QCOW2 volume if 
   this system has been configured correctly.

   The name of the copied directory should be "YYYY-MM", where
   the "YYYY" == "year of ingest" and "MM" == "month of ingest".
   e.g. $SLODATA_INGEST/2024-03


2. Edit the "conf/upload.conf" file

   The "conf/upload.conf" file contains variables that point to
   your copy of the directory structure and to the name of the 
   directory to be used when saving the uploaded data to the 
   AWS S3 storage area.  These variables are commented out, and
   must be un-commented and altered to point at your chosen
   storage locations.


3. Run the scripts in the "bin" directory in the appropriate order

   The scripts are mostly prefaced with a number or "report__".

   The scripts prefaced with numbers should be run in the order of
   the numbers.  i.e. first run the "01_" script, then the "02_" 
   script, and so on.

   You should be in the parent directory when running scripts in
   the "bin" directory.  For example:

       pkukla@nopox:/some/path$ ./bin/01_check-rights.sh


   and not:

       pkukla@nopox:/some/path/bin$ ./01_check-rights.sh

   The "report" scripts can be used before running the final 
   ingest step which uploads the data to AWS S3.  The output
   from these scripts can be used for last-minute, final checks
   to ensure all looks well.


The first script will start by reading data from $SLODATA_STAGING
directory.  Output from that script will be put into the "data"
subdirectory, and subsequent steps will create more copies of
the XML in the "data" subdirectory.

A few last-minute checks will be run against the data,
and it will be compressed and prepped for upload to DPLA's AWS
S3 drive.

The copy of the entire directory is fine (temp files and all),
as it gives us the ability to review what went wrong if something
doesn't goe as expected and we need to troubleshoot our processes.

