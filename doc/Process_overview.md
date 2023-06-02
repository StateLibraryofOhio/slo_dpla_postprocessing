# State Library of Ohio - REPOX Post-processing

## General philosophy

The only user of this toolset (at the moment) is me, and I'm a very command-line-oriented worker.  Hence, the results below.

Most of the scripts (get-transformed.sh a.k.a gt, delete-removal.sh, iiif-blanket-insert.sh, review-qdc-conversion.sh, penelope.sh) are designed in such a manner that the next command to be run will be displayed at the bottom of the script output so that all the user needs to do is run a script, copy/paste from the output to run the next script, and repeat until finished.

So, if all's working well, copy/pasting those commands will handle 90% of your work.

Additional investigation will need to be made by the analyst to examine the data being retrieved for each collection and devise an appropriate XSLT transform for that data.


## General overview

The 10,000-foot overview of how data goes from contributor to DPLA, and the changes the data encounters along the way, is:

I:  data flows into REPOX via OAI-PMH in a contributor-specified format

II:  data flows out of REPOX via OAI-PMH in a "transformed", standardized format ("qdc")

III:  "deleted" records are removed from the OAI-PMH output from Stage 2 via XSLT / Java / shell scripting

IV:  IIIF tags are added to all records from Stage 3 and are populated with metadata where needed via XSLT / Java / shell scripting

V:  Prepare data from Stage 4 for Penelope's analysis: package the contributor's unmodified XML data and the final, DPLA-ready data into a .zip file that can be emailed to her for review and approval

VI:  Prepare data for upload to DPLA on a quarterly schedule.


REPOX is involved in Stage 1 and Stage 2.  Data from subsequent Stages are external to REPOX.


## Adding the set to REPOX

When someone submits a new collection for inclusion in the Digital Public Library of America, they will provide SLO with the following information:

- The Base OAI-PMH Harvesting URL for their server
- The OAI-PMH setSpec of set/collection they wish to add to DPLA
- The OAI-PMH metadata format they wish to use (e.g. "oai_qdc", "oai_dc", "dcq")


When you have this, you login to REPOX and create a new Data Set corresponding to the user's contributed data.

If the organization has never before contributed data to ODN, then go to the "Home" tab in REPOX and click on the "Create Data Provider" to create a new
Provider entry for the organization.  Otherwise, find the organization in the list of existing sets.

Right-click on the Provider giving us the OAI-PMH details and choose "Create Data Set" from the resulting popup menu.

In the "OAI-PMH" tab, "Data Set" section of the pop-up:

- Enter the URL provided in the "OAI-URL" setting and click the "Check" button.  REPOX will query the URL and retrieve a list of sets that the remote server has to offer.  When the remote server returns the data, the "OAI Set" entry box will become a dropdown list; select the desired set from this list.  (If the set is not in the list, then the contributor should re-examine their server and the information they provided to us to confirm everything is configured correctly.)
- Select from the "Metadata Format" dropdown listing the metadata format that the organization specified when submitting the collection for DPLA inclusion.

In the "Output" section of the pop-up:

- Enter the "Record Set" for the new set.  There is a naming convention for the "Record Set (no spaces)" values:  There are 2 parts to the value, separated by an underscore.  Part 1 is a value that will be applied to all sets submitted by that organization; Part 2 is a value unique to that set.  (For example, if OSU submits a dataset with an OAIxsetSpec of "Bob", then a reasonable value for the "Record Set (no spaces)" setting might be "osu_bob".)

- Enter the "Description" for the new set.  This is a free-text field describing the collection for end-users to see.  Ampersands should be entered using an XML equivalent.

Click the "Save" button and you should be returned to the list of sets.

Find your newly-added collection; it should have empty values for "Last Ingest" and "Records".  Right-click on the set to see a popup menu.  Click on the "Ingest Now" option.  REPOX will queue the job for processing.  Scroll away from the page to refresh the "Ingest Status" icon and the number of records in the newly-harvested set.


## Re-harvesting a Record Set in REPOX

To re-harvest a REPOX Data Set, right-click on the chosen set in the REPOX admin interface and select "Empty Data Set" from the popup menu.  Then, right-click on the set again and select the "Ingest Now" option.  NOTE:  The "Force Record Update" option does not work.

<a name="working_repoxized"/>

## Working with metadata after it has been harvested into REPOX

The steps below walk you through the process described by the workflow outlined above.  This is for interaction with a single REPOX data set with the intention of adding a new set to REPOX, debugging a problematic XSLT transform in REPOX, or analyzing data within a single set in REPOX.  Preparing data for a full upload to DPLA ("ingest") is a different procedure that automates much of the following.


**Step 0:  Before you do anything, configure your user account by ensuring that Java is installed, and that the Saxon XSLT libraries are installed and in your CLASSPATH**

Steps 1 and following need to be performed each time you work with a new collection.  Step 0 needs to be performed only once; the settings should persist across logins, and are collection-independent.

In the installation directory for this tool is a "conf" subdirectory, which contains a file "SLO-DPLA-environment.conf".  Add the information in that file to the tail-end of your .bashrc file so the following commands work.


**Step 1:  Setup a work-area for the collection you are working with**

You need to configure some directory on a Linux system with this software installed and working.  Use the "gu-setup" command for this, feeding it the REPOX setSpec and the OAI-PMH metadataFormat used for harvesting the data from the Contributor's server.

In the following example, we create a directory to work in while analysing data, and then configure that directory to work with our REPOX dataset.  In REPOX, the example dataset would have a OAI-PMH setSpec of "my-new-dataset" and it would have an associated OAI-PMH schema of "oai_qdc":

    $ mkdir my-new-dataset
    $ cd my-new-dataset
    $ gu-setup my-new-dataset oai_qdc

All subsequent work is done in this directory.  The setup script creates a configuration file which is referenced by scripts that follow.

If something goes wrong during the "gu-setup" step, then simply re-run it to over-write the bad configuration with a new config.


**Step 2:  To retrieve the un-tranformed contributor data from REPOX, use the command "gu"**

    $ gu

This downloads the untransformed XML from REPOX and performs a few basic tests on it to assist with creating a REPOX-based XSLT transform specific for this collection.  Output files include:  2u.xml, SETSPEC-not_transformed-ORIG_PREFIX.xml, fields-with-metadata-in-raw.txt, null-elements.txt, values-with-semicolons.txt, html.txt, datevals.txt

Use the $SLODPLA_LIB/00_STARTING_POINT-COLL.xsl file as a starting point for creating a new XSLT transform for REPOX, and use the files and output generated by the "gu" script to determine which changes need to be made to that file to make the contributed metadata compatible with the rest of our data.

(Note that although I refer to this as "untransformed" XML, REPOX actually is changing it; The data is not identical to the metadata originally harvested from the participating library's server.  Although the metadata sent by the site has not been changed, REPOX has added more metadata to the "untransformed" data.  This additional, aggregator metadata is used by REPOX to keep track of when the originating server was last harvested, etc.)

You will need to test that XSL transform as you create it, and for that you will need...


**Step 3:  To retrieve the transformed contributor data from REPOX, use the command "gt"**

    $ gt

...and potentially:

    $ review-qdc-conversion.sh INPUTFILE.xml

The "gt" command runs the un-transformed XML through the XSLT you have created for the collection in REPOX, using the $SLODPLA_LIB/00_STARTING_POINT-COLL.xsl file as a starting point.  The output from this command is a standardized format; metadata sent by the Contributor has either been shoe-horned into an appropriate field in the XML, or it has been eliminated from the XML feed.

The screen output from this command will include the exact commands needed to (1) run some basic debugging against the data created by the REPOX-based XSLT (e.g. the "review-qdc-conversion.sh" command, shown above...frequently needed when you're creating the REPOX-based XSL transform), and (2) remove "deleted records" from the XML.  You will run #2 after you are satisfied that the standardized XML is working as desired.

If you have not added an XSLT transform to the set in REPOX, then the "gt" command will fail.  If you have added an XSLT transform to the set in REPOX but there's a bug in the XSLT, then this will fail.

When creating and testing an XSLT transform, you'll re-harvest and re-run the "review-qdc-conversion.sh" script frequently.  It's actually run as the last part of the "gt" command, but running it standalone allows you to avoid having to re-download data, which can be a hassle if you're working with a large dataset.

For more details on creating and debugging an  XSLT transform, see the "[Creating an XSLT transform for a new collection](#create_transform)" section of this document.

When the contributor's metadata values have been mapped to the ODN equivalents -- or discarded, or munged and mapped, or ??? --- and you are happy with the result, then the data modifications in REPOX have come to an end, and it is time to begin our post-REPOX modifications.


**Step 4:  To remove references to "deleted records" from the data-set, use the command "delete-removal.sh"**

    $ delete-removal.sh INPUTFILE.xml

OAI-PMH supports references to "deleted records"...URIs pointing at items that no longer exist, and alert the user to the fact that the link isn't simply temporarily unreachable, but permanently gone.  DPLA does not want these references, and we will therefore remove them from the data-set.  Some data-sets may not have any deleted records, while other data-sets may have tens of thousands.

This script uses Java/XSLT to remove the offending records from the output.

The screen output from this command will include the exact commands needed to (1) run some basic debugging against the data created by the REPOX-based XSLT (frequently needed when you're creating the REPOX-based XSL transform), and (2) add IIIF tags to the records.  You will run #2 after you are satisfied that the deleted record removal is working as desired.  This should be a pretty uneventful part of the process.


**Step 5:  To add dcterms:isReferencedBy tags to records, use the command "iiif-blanket-insert.sh"**

    $ iiif-blanket-insert.sh INPUTFILE.xml

This script uses Java/XSLT to add dcterms:isReferencedBy elements to each record.  Each record will be analyzed to determine whether it is eligible to "participate" based on the set containing the record and the permissions on the individual record (as listed in the record's edm:rights element).  "Ineligible" records will have an empty tag added (i.e. "&lt;dcterms:isReferencedBy/&gt;")


At various stages throughout the process, you can run a basic set of tests against your XML file by using the "review-qdc-conversion.sh" command.

This will run some very basic tests on the file, and help to debug the creation of the REPOX-based XSLT.



**Step 6:  To package the data for Penelope's review and perform a final evaluation**

    $ penelope.sh

At this point, run the "penelope.sh" script.  It will archive the appropriate files into a .zip file and dump the appropriate "pscp" command to the screen to allow you to copy it to your workstation.  It will also perform some basic tests, and spit out a few details about the data that can be included in an email to Penelope along with the .zip file.

In addition to the basic tests performed by the "penelope.sh" script, it's also a good idea to run the "review-qdc-conversion.sh" script against the final, transformed product.  The command to do so will be echoed to the screen by the "penelope.sh" script.



<a name="create_transform"/>

## Creating an XSLT transform for a new collection

After you add the set to REPOX, follow the steps in the <a href="#working_repoxized">Working with metadata after it has been harvested into REPOX</a> until you complete step 2.

A number of (very) crude operations are run against the data harvested from REPOX by the "gu" command.  The following output files are created to help with analysis of the data:

* 2u.xml:  XML, no leading spaces, good for grepping 
* SETSPEC-not_transformed-$ORIG_PREFIX.xml:  XML, formatted for easy reading 
* fields-with-metadata-in-raw.txt:  A quick listing of all XML elements sent for this collection 
* null-elements.txt:  Elements containing no value, modify XSLT to remove these 
* values-with-semicolons.txt:  Text that may be HTML, or contain delimited values 
* html.txt:  Text that might be XML 
* datevals.txt:  Date values that should be re-formatted 


Use the information from these files and the script output to create a new REPOX-based XSLT file, using the $SLODPLA_LIB/00_STARTING_POINT-COLL.xsl as a template for your new transform.  Name your copy of the XSLT file REPOX_SETSPEC.xsl, where "REPOX_SETSPEC" is the OAI-PMH setSpec you've chosen for this set in REPOX.

Open the web-based REPOX administration interface and locate your set.  Right-click on the set and select the "Edit Data Set" option.  Go to the "OAI-PMH tab in the resulting popup and click on the "Add" button in the "Transformations" section at the bottom of the window.  A list of the pre-existing transforms is displayed, but we wish to add a new transform, so click the "New" button.

New popup:
 * Identifier:  Use the REPOX setSpec
 * Description:  Use the REPOX setSpec - Source Format:  Use the OAI harvesting format specified by the organization (e.g. "oai_dc:dc", "oai__qdc:qualifieddc")
 * Destination Format:  "qdc"
 * XSL version 2?:   select this checkbox
 * Transformation File (XSL):  Browse to the XSLT file you just created from $SLODPLA_LIB/00_STARTING_POINT-COLL.xsl

Save your changes.  You'll end up back at the list of pre-existing transforms.  Your transform will now be at the end of hte list.  Navigate to it, select it, and add it to your configuration for this set.  Save the changes.

You should now be able to harvest this set from REPOX using both the "qdc" metadataPrefix and whichever metadataPrefix was used to harvest it from the originating server.

If you can harvest this set from REPOX using the "qdc" metadataPrefix, then you can begin testing and refining the collection-specific XSLT transformation.



Running the "gt" command only creates a few files:

* t2.xml:  XML, no leading spaces, good for grepping 
* SETSPEC-REPOX-TRANSFORMED-$DPLA_PREFIX.xml:  XML, formatted for easy reading 

...but, running the "gt" command also invokes the "review-qdc-conversion.sh" script, which (re-)creates additional files, based on the transformed data:

* review-qdc-conversion-output.xml:  Output file from various tests 
* null-elements.txt:  Null XML elements; should be removed via XSLT 
* values-with-semicolons.txt:  Instances of semicolons; could be HTML or subfields 
* html.txt:  Instances of encoded greater-than or less-than signs...html? 
* datevals.txt:  Date values that should be re-formatted 


    $ review-qdc-conversion.sh INPUTFILE.xml

...where INPUTFILE.xml == "your setSpec"--review-qdc-conversion-input.xml

The "review-qdc-conversion.sh" script runs a variety of simple tests against the data, including:

 * Has the collection name been changed in the REPOX XSLT?
 * Has the contributor name been changed in the REPOX XSLT?
 * Are there values in the submitted data containing semi-colons (possibly a subfield-delimiter, or HTML)?
 * Are date values using undesireable formatting?
 * Are there null-value elements?
 * Is there a discrepancy between the tallies of edm:rights and edm:isShownAt values?
 * How many records are viable IIIF records?


Potentially of use in debugging:  Open an SSH terminal to the REPOX server, sudo and run "repoxlogs", and scan the output as you reproduce errors.  The error logging frequently directs one to the line number of your XSLT script where the error occurs.





