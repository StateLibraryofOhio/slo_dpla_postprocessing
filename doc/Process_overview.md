# State Library of Ohio - REPOX Post-processing

## General philosophy

The only user of this toolset (at the moment) is me, and I'm a very command-line-oriented worker.  Hence, the results below.

Most of the scripts (get-transformed.sh a.k.a gt, delete-removal.sh, iiif-blanket-insert.sh, review-qdc-conversion.sh, penelope.sh) are designed in such a manner that the next command to be run will be displayed at the bottom of the script output so that all the user needs to do is run a script, copy/paste from the output to run the next script, and repeat until finished.

So, if all's working well, copy/pasting those commands will handle 90% of your work.

Additional investigation will need to be made by the analyst to examine the data being retrieved for each collection and devise an appropriate XSLT transform for that data.


## Workflow overview

The general workflow for the addition of a new collection to the system (or the re-harvest of an existing collection) is:

1:  data flows into REPOX via OAI-PMH in a contributor-specified format

2:  data flows out of REPOX via OAI-PMH in a "transformed", standardized format ("qdc")

3:  "deleted" records are removed from the OAI-PMH output from Stage 2 via XSLT / Java / shell scripting

4:  IIIF tags are added to all records from Stage 3 and are populated with metadata where needed via XSLT / Java / shell scripting

5:  Prepare data from Stage 4 for Penelope's analysis: package the contributor's unmodified XML data and the final, DPLA-ready data into a .zip file that can be emailed to her

6:  Prepare data for upload to DPLA on a quarterly schedule.


REPOX houses data from Stage 1 and Stage 2.  Data from subsequent Stages are external to REPOX.




## More detailed overview

Step 0:  Before you do anything, configure your user account by ensuring that Java is installed, and that the Saxon XSLT libraries are installed and in your CLASSPATH

Steps 1 and following need to be performed each time you work with a new collection.  Step 0 needs to be performed only once; the settings should persist across logins, and are collection-independent.

In the installation directory for the software is a "conf" subdirectory, which contains a file "SLO-DPLA-environment.conf".  Add the information in that file to the tail-end of your .bashrc file so the following commands work.


**Step 1:  Setup a work-area for the collection you are working with**

You need to configure some directory on a Linux system with this software installed and working.  Use the "gu-setup" command for this, feeding it the REPOX setSpec and the OAI-PMH metadataFormat used for harvesting the data from the Contributor's server.

In the following example, we create a directory to work in while analysing data, and then configure that directory to work with our REPOX dataset.  In REPOX, the example dataset would have a OAI-PMH setSpec of "my-new-dataset" and it would have an associated OAI-PMH schema of "oai_qdc:

    $ mkdir my-new-dataset
    $ cd my-new-dataset
    $ gu-setup my-new-dataset oai_qdc

All subsequent work must be done in this directory.  The setup script creates a configuration file which is referenced by scripts that follow.

If you somehow screw up the "gu-setup" step, then simply re-run it to over-write the bad configuration with a new config.


**Step 2:  To retrieve the un-tranformed contributor data from REPOX, use the command "gu"**

    $ gu

This downloads the untransformed XML from REPOX and performs a few basic tests on it to assist with creating a REPOX-based XSLT transform specific for this collection.  You will need to test that XSL transform as you create it, and for that you will need...


**Step 3:  To retrieve the transformed contributor data from REPOX, use the command "gt"**

    $ gt

This runs the un-transformed XML through the XSLT you have created for the collection in REPOX.  The output from this command is a standardized format; metadata sent by the Contributor has either been shoe-horned into an appropriate field in the XML, or it has been eliminated from the XML feed.

The screen output from this command will include the exact commands needed to (1) run some basic debugging against the data created by the REPOX-based XSLT (frequently needed when you're creating the REPOX-based XSL transform), and (2) remove "deleted records" from the XML.  You will run #2 after you are satisfied that the standardized XML is working as desired.


**Step 4:  To remove references to "deleted records" from the data-set, use the command "delete-removal.sh"**

    $ delete-removal.sh INPUTFILE.xml

OAI-PMH supports references to "deleted records"...URIs pointing at items that no longer exist, and alert the user to the fact that the link isn't simply temporarily unreachable, but permanently gone.  DPLA does not want these references, and we will therefore remove them from the data-set.  Some data-sets may not have any deleted records, while other data-sets may have tens of thousands.

This script uses Java/XSLT to remove the offending records from the output.

The screen output from this command will include the exact commands needed to (1) run some basic debugging against the data created by the REPOX-based XSLT (frequently needed when you're creating the REPOX-based XSL transform), and (2) add IIIF tags to the records.  You will run #2 after you are satisfied that the deleted record removal is working as desired.  This should be a pretty uneventful part of the process.


**Step 5:  To add dcterms:isReferencedBy tags to records, use the command "iiif-blanket-insert.sh"**

    $ iiif-blanket-insert.sh INPUTFILE.xml

This script uses Java/XSLT to add dcterms:isReferencedBy elements to each record.  Each record will be analyzed to determine whether it is eligible to "participate" based on the set containing the record and the permissions on the record (as listed in the edm:rights element).  "Ineligible" records will have an empty tag added (i.e. "<dcterms:isReferencedBy/>")



At various stages throughout the process, you can run a basic set of tests against your XML file by using the "review-qdc-conversion.sh" command.

This will run some very basic tests on the file, and help to debug the creation of the REPOX-based XSLT.



**Step 6:  To package the data for Penelope's review and perform a final evaluation**

    $ penelope.sh

At this point, run the "penelope.sh" script.  It will archive the appropriate files into a .zip file and dump the appropriate "pscp" command to the screen to allow you to copy it to your workstation.  It will also perform some basic tests, and spit out a few details about the data that can be included in an email to Penelope along with the .zip file.

In addition to the basic tests performed by the "penelope.sh" script, it's also a good idea to run the "review-qdc-conversion.sh" script against the final, transformed product.  The command to do so will be echoed to the screen by the "penelope.sh" script.



## Creating an XSLT transform for a new collection

### Getting the basic details

When someone submits a new collection for inclusion in the Digital Public Library of America, they will provide SLO with the following information:

- The Base OAI-PMH Harvesting URL for their server
- The OAI-PMH setSpec of set/collection they wish to add to DPLA
- The OAI-PMH metadata format they wish to use (e.g. "oai_qdc", "oai_dc", "dcq")

### Adding the set to REPOX

When you have the basic information, you need to login to REPOX and create a new set corresponding to the user's contributed data.

If the organization has never before contributed data to ODN, then go to the "Home" tab in REPOX and click on the "Create Data Provider" to create a new Provider entry for the organization.

Right-click on the Provider giving us the OAI-PMH details and choose "Create Data Set" from the resulting popup menu.

Enter the URL provided in the "OAI-URL" setting and click the "Check" button.  REPOX will query the URL and retrieve a list of sets that the remote server has to offer.  When the remote server returns the data, the "OAI Set" entry box will become a dropdown list; select the desired set from this list.

Select from the "Metadata Format" dropdown listing the metadata format that the organization specified when submitting the collection for DPLA inclusion.

The "Record Set (no spaces)" value should be created according to a "formula".  There are 2 parts to the value, separated by an underscore.  Part 1 is a value that will be applied to all sets submitted by that organization; Part 2 is a value unique to that set.

For example, if OSU submits a dataset with an OAI setSpec of "Bob", then a reasonable value for the "Record Set (no spaces" setting might be "osu_bob".




- A list of field mappings, showing how they wish their metadata fields to be mapped to the ODN fields
