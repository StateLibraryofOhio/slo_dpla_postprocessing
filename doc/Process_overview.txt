The general workflow for the addition of a new collection to the system (or the re-harvest of an existing collection) is:


Stage 1:  data flows into REPOX via OAI-PMH in a contributor-specified format

Stage 2:  data flows out of REPOX via OAI-PMH in a "transformed", standardized format ("qdc")

Stage 3:  "deleted" records are removed from the OAI-PMH output from Stage 2 via XSLT / Java / shell scripting

Stage 4:  IIIF tags are added to all records from Stage 3 and are populated with metadata where needed via XSLT / Java / shell scripting

Stage 5:  Prepare data from Stage 4 for Penelope's analysis: package the contributor's unmodified XML data and the final, DPLA-ready data into a .zip file that can be emailed to her

Stage 6:  Prepare data for upload to DPLA on a quarterly schedule.


REPOX houses data from Stage 1 and Stage 2.  Data from Stages 3-6 are external to REPOX.




The following is a high-level overview of the process to download data from REPOX, create REPOX-based XSLT transforms, remove deleted records, and add IIIF information.


Step 0:  Configure your user account by editing your Linux user's .bashrc

Steps 1 and following need to be performed each time you work with a new collection.  Step 0 needs to be performed only once; the settings should persist across logins, and are collection-independent.

In the installation directory for the software is a "conf" subdirectory, which contains a file "SLO-DPLA-environment.conf".  Add the information in that file to the tail-end of your .bashrc file so the following commands work.


Step 1:  Setup a work-area for the collection you are working with

You need to configure some directory on a Linux system with this software installed and working.  Use the "gu-setup" command for this, feeding it the REPOX setSpec and the OAI-PMH metadataFormat used for harvesting the data from the Contributor's server.

   $ mkdir my-new-dataset
   $ cd my-new-dataset
   $ gu-setup my-new-dataset oai_qdc


Step 2:  To retrieve the un-tranformed contributor data from REPOX, use the command "gu"

   $ gu

This downloads the untransformed XML from REPOX and performs a few basic tests on it to assist with creating a REPOX-based XSLT transform specific for this collection.  You will need to test that XSL transform as you create it, and for that you will need...


Step 3:  To retrieve the transformed contributor data from REPOX, use the command "gt"

   $ gt

This runs the un-transformed XML through the XSLT you have created for the collection in REPOX.  The output from this command is a standardized format; metadata sent by the Contributor has either been shoe-horned into an appropriate field in the XML, or it has been eliminated from the XML feed.

The screen output from this command will include the exact commands needed to (1) run some basic debugging against the data created by the REPOX-based XSLT (frequently needed when you're creating the REPOX-based XSL transform), and (2) remove "deleted records" from the XML.  You will run #2 after you are satisfied that the standardized XML is working as desired.


Step 4:  To remove references to "deleted records" from the data-set, use the command "delete-removal.sh"

   $ delete-removal.sh INPUTFILE.xml

OAI-PMH supports references to "deleted records"...URIs pointing at items that no longer exist, and alert the user to the fact that the link isn't simply temporarily unreachable, but permanently gone.  DPLA does not want these references, and we will therefore remove them from the data-set.  Some data-sets may not have any deleted records, while other data-sets may have tens of thousands.

This script uses Java/XSLT to remove the offending records from the output.

The screen output from this command will include the exact commands needed to (1) run some basic debugging against the data created by the REPOX-based XSLT (frequently needed when you're creating the REPOX-based XSL transform), and (2) add IIIF tags to the records.  You will run #2 after you are satisfied that the deleted record removal is working as desired.  This should be a pretty uneventful part of the process.


Step 5:  To add dcterms:isReferencedBy tags to records, use the command "iiif-blanket-insert.sh"

   $ iiif-blanket-insert.sh INPUTFILE.xml

This script uses Java/XSLT to add dcterms:isReferencedBy elements to each record.  Each record will be analyzed to determine whether it is eligible to "participate" based on the set containing the record and the permissions on the record (as listed in the edm:rights element).  "Ineligible" records will have an empty tag added (i.e. "<dcterms:isReferencedBy/>")



At various stages throughout the process, you can run a basic set of tests against your XML file by using the "review-qdc-conversion.sh" command.

This will run some very basic tests on the file, and help to debug the creation of the REPOX-based XSLT.



Step 6:  To package the data for Penelope's review and perform a final evaluation

   $ penelope.sh

At this point, run the "penelope.sh" script.  It will archive the appropriate files into a .zip file and dump the appropriate "pscp" command to the screen to allow you to copy it to your workstation.  It will also perform some basic tests, and spit out a few details about the data that can be included in an email to Penelope along with the .zip file.

In addition to the basic tests performed by the "penelope.sh" script, it's also a good idea to run the "review-qdc-conversion.sh" script against the final, transformed product.  The command to do so will be echoed to the screen by the "penelope.sh" script.






