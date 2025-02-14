# State Library of Ohio - ODN harvest processing and archiving

## General philosophy

The only user of this toolset (at the moment) is me, and I'm a very command-line-oriented worker.  Hence, this app's look-and-feel.

Most of the scripts (e.g. get-raw.sh a.k.a gr) are designed in such a manner that the next command to be run will be displayed at the bottom of the script output so that all the user needs to do is run a script, copy/paste from the output to run the next script, and repeat until finished.

So, if all's working well, copy/pasting those commands will handle 90% of your work.

Additional investigation will need to be made by the analyst to examine the data being retrieved for each collection and devise an appropriate XSLT transform for that data.


## General overview

The 10,000-foot overview of how data goes from contributor to DPLA, and the changes the data encounters along the way, is:

I:  Data is harvested from contributor's servier via OAI-PMH in a contributor-specified format and the raw/unchanged files are stored locally

II:  Harvested data undergoes an XSLT transformation to (a) add archival metadata containing provenance, datestamps, etc., and (b) remove "deleted" records from the harvested data.  This transformed data is stored on the local filesystem, and is generally referred to in the documentation for this project as "archivized"

III:  The archivized data undergoes another XSLT transformation in which the contributor's metadata values are mapped to their corresponding fields in the ODN standard.  Additionally, a supplemental XSLT transformation is run for a few collections in which certain records must be eliminated based on the contents of their metadata.

IV:  IIIF tags are added to all records from Stage 3 and are populated with metadata where needed

V:  Prepare data from Stage 4 for Penelope's analysis: package the contributor's unmodified XML data and the final, DPLA-ready data into a .zip file that can be emailed to her for review and approval

VI:  Prepare data for upload to DPLA on a quarterly schedule.




## Adding the newly-submitted set

When someone submits a new collection for inclusion in the Digital Public Library of America, they will provide SLO with the following information:

- The Base OAI-PMH Harvesting URL for their server
- The OAI-PMH setSpec of set/collection they wish to add to DPLA
- The OAI-PMH metadata format they wish to use (e.g. "oai_qdc", "oai_dc", "dcq")

Login to the server OS command-line.

Create a directory under $SLODATA/QA for your new collection.  This will be used for temporary files.  Change to that directory and run the command:

    addset.sh

That script will prompt you for various details about the collection.  When the script completes, the collection will be added to the system and appropriate entries will be created in the MySQL database.  An XSLT file will be created for the new set, but it MUST be edited before use!


## Harvesting a set from a contributor

Create a directory under $SLODATA/QA for your new collection, or re-use the directory that was created when you added the new set to the system.  This will be used for temporary files.

Change to that directory and run the command:

    gt-setup ODNSET

...where "ODNSET" is the set identifier that you specified when adding the new set.  This will add to the directory a config file used by subsequent scripts.

Next, harvest the data from the contributor's server using the command:

    get-raw.sh

This will harvest data from the contributor's server via OAI-PMH.  The original, unmodified files will be stored under the $SLODATA_RAW directory.  Archivized versions of these files will be stored under the $SLODATA_ARCHIVIZED directory.  The archivized data will be used for subsequent operations, and the raw data will be retained for troubleshooting / diagnostic purposes.


## Re-harvesting a set

To re-harvest a set, just run the "get-raw.sh" script again.


## Working with metadata after it has been harvested

**Step 0:  Before you do anything, configure your user account by ensuring that Java is installed, and that the Saxon XSLT libraries are installed and in your CLASSPATH**

Steps 1 and following need to be performed each time you work with a new collection.  Step 0 needs to be performed only once; the settings should persist across logins, and are collection-independent.

In the installation directory for this tool is a "conf" subdirectory, which contains a file "SLO-DPLA-environment.conf".  Add the information in that file to the tail-end of your .bashrc file so the following commands work.


**Step 1:  Setup a work-area for the collection you are working with**

You need to configure some directory on a Linux system with this software installed and working.  You probably have this directory already from when you initially added the set.  Create a directory under $SLODATA/QA for this purpose.

Use the "gu-setup" command for this, feeding it the ODN setSpec as a parameter.  e.g. gu-setup ohiou_set17

In the following example, we create a directory to work in while analysing data, and then configure that directory to work with our dataset.

    $ mkdir my-new-dataset
    $ cd my-new-dataset
    $ gu-setup my-new-dataset

All subsequent work is done in this directory.  The setup script creates a configuration file which is referenced by scripts that follow.

If something goes wrong during the "gu-setup" step, then simply re-run it to over-write the bad configuration with a new config.


**Step 2:  Run some initial diagnostics against the data that has been downloaded**

In the work-area you have configured for this set, run the following command:

    $ dissect-raw.sh

This performs a few basic tests on the metadata that has been harvested from the contributor's server.  The information revealed by this step will assist with creating a set-specific XSLT transform for this collection.

Output files created by this script include:   $SETSPEC-not_transformed-$ORIG_PREFIX.xml, fields-with-metadata-in-raw.txt, null-elements.txt, values-with-semicolons.txt, html.txt, datevals.txt.  These files, and the output sent to the screen by the script, will help in understanding the data being sent by the contributor.


**Step 3:  Create a set-specific XSLT transformation for this set**

The $SLODPLA_LIB/00_STARTING_POINT-COLL.xsl file is used to create a new set-specific XSLT transform.  This file will be located at $SLODPLA_LIB/bySet/base-transform/ and will be named $SETSPEC.xsl where "$SETSPEC" is the ODN setSpec/ID for the set.

This XSLT file must be edited to update the name the provider (e.g. "Ohio University Libraries") and the name of the collection (e.g. "Famous People of Ohio University").  It will probably need to be updated to eliminate incoming metadata values (e.g. "We don't want to include the dcterms:spatial data in our DPLA records.") or map the incoming fields to their ODN-standard equivalents.

A few sites have contributed datasets that include records that shouldn't be uploaded to DPLA.  In these cases, a second XSLT file needs to be manually created and added to the $SLODPLA_LIB/bySet/filter-transform/ directory.  This is unusual, however, and generally isn't something you need to worry about.  A filter-transform, if present, will automatically be applied to the data during normal processing.

Run the "base-transform.sh" script to apply the set-specific XSLTs against the contributed data.  This will run the archivized metadata through the set-specific XSLT transformations, dumping the output into the current, temporary working directory.  If you see errors from the XSLT compiler while running this, then you need to evaluate the set-specific XSLT files for problems.

Output from the "base-transform.sh" script is limited to the local, temporary work area.  It does not affect the data that's held for upload to DPLA, but further manipulations to it will result in data that is uploaded to DPLA.

Once the base-transform.sh script has been run, you can run an additional script to check the output for common problems.  Simply specify the output filename from the "base-transform.sh" script when running this diagnostic utility.  If your "base-transform.sh" script created a file called "bgsu_10-odn-transformed-qdc.xml", then you'd run:

    $ review-base-transform.sh  bgsu_10-odn-transformed-qdc.xml

Output from the script will help you determine whether there are errors in the XSLT you're writing, and whether the XSLT needs to be modified beyond the basics (e.g. "map our field X to ODN field Y") to include additional code to further clean up the data by tokenizing it on semicolons, removing HTML tags from metadata, etc.)

This same script can be run against XML files created further downstream of the "base-transform.sh" script.  For example, you run base-transform.sh to create file XYZZY.xml; you then run that XYZZY.xml file through the WikiMedia step (covered later in these directions.)  The XML output from that subsequent stage can also be evaluated by the "review-base-transform.sh" script.

Output from the "review-base-transform.sh" script is limited to the local, temporary work area.  It does not affect the data that's held for upload to DPLA, but further manipulations to it will result in data that is uploaded to DPLA.



**Step 4:  Add WikiMedia / IIIF metadata to the records**

Records uploaded to DPLA can, optionally, be flagged for inclusion in the WikiMedia project.  For a set to be enabled with WikiMedia processing, the following must currently occur:

  A.  The "source" record in MYSQL corresponding to this set must have the "iiifParticipant" value set to "y"

  B.  The ODN setSpec needs to be included in the $SLODPLA_LIB/iiif-blanket-insert.xsl file

Currently, both of these changes need to be made manually.  (NOTE TO SELF:  The code needs to be updated to eliminate one of these requirements; probably the XSLT update, since that would be best from a CPU-usage perspective.  Doubtless I'll forget to update this document when that's done.  If it's ever done.  Be aware that the need to update the XSLT may go away.)

Possibly another step will be required:

  C.  Add more processing to $SLODPLA_LIB/iiif-blanket-insert.xml in the case of a new OAI-PMH server

Our contributors are overwhelmingly using CONTENTdm, and it has IIIF capabilities enabled by default; For CONTENTdm users, no additional changes are necessary.  For sites hosting their collections with other applications (e.g. Omeka, Drupal) the IIIF functionality is probably not built-in by default, but rather is enabled via the installation of a plugin/module.  In the case of Kent State, I've created a separate xsl:when stanza to create an appropriate IIIF value for a record because Drupal's functionality differs from CONTENTdm's and requires a differently-styled URL to get that data.  Other non-CONTENTdm systems contributing IIIF data will also need xsl:when statements to generate the appropriate IIIF metadata.

When the set is processed, the edm:rights value for each record that's part of the set is examined by the XSLT processor.  If the edm:rights value is compatible with the WikiMedia project (i.e. the item's not under a restrctive copyright), then a metadata value is copied (or generated from existing metadata associated with the item) and enclosed in <dcterms:isReferencedBy> tags.

Input for this step is data which was generated by the base-transform.sh script.  Specify the filename generated by the base-transform.sh script as the option to this script.  For example, if the base-transform.sh script creates an output file named "ohiou_set12-odn-transformed-qdc.xml", then use that file when creating the data with IIIF/WikiMedia metadata:

    $ iiif-insert.sh  bgsu_10-odn-transformed-qdc.xml

You can use the review-base-transform.sh script to evaluate the output file generated by the "iiif-insert.sh" script.

Output from the "iiif-insert.sh" script is limited to the local, temporary work area.  It does not affect the data that's held for upload to DPLA, but further manipulations to it will result in data that is uploaded to DPLA.


**Step 5:  Stage the data for upload to DPLA**

When the data generated by the iiif-insert.sh script seems OK to you, then it's ready to be copied to the staging area to await the next DPLA ingest.

The staging area exists at $SLODATA_STAGING.  Each set's data is stored there in a separate file, with the filename pattern of ODN_SETSPEC.xml, where "ODN_SETSPEC" is the setSpec/ID we use to track the set.

To copy the file to the appropriate location using the appropriate naming scheme, run the "staging.sh" command, specifying the filename of the file you wish to queue for upload to DPLA.  For example, if file you wish to upload is named "bgsu_10-odn-transformed-qdc_iiif-added.xml", then run the command:

    $ staging.sh bgsu_10-odn-transformed-qdc_iiif-added.xml

Once staged, the data will remain there until the next upload to DPLA.  During the upload, you will copy the staged data elsewhere, run a few tests on it, and upload it to DPLA.


**Step 6:  Package the data for Penelope's review**

After you've staged the data, you need to send it to Penelope so she can examine it.  The same thing needs to be done frequently, so this script will spit out the subject line for an email, a few basic details about the data that can be copied into the email, and the command to copy the data from the Linux system to the Windows workstation using Putty's SCP.

In the temporary work area where you've run base-transform.sh / iiif-insert.sh / staging.sh, run the following command:

    $ qa.sh

The appropriate information will be dumped to the screen for copy/pasting into an email.

File output from the "iiif-insert.sh" script is limited to the local, temporary work area.  It does not affect the data that's held for upload to DPLA.



<a name="create_transform"/>

## Creating an XSLT transform for a new collection

The dissect-raw.sh script creates several files that can prove useful in analyzing the data.

* 2u.xml:  archivized XML, no leading spaces, good for grepping 
* SETSPEC-not_transformed-$ORIG_PREFIX.xml:  XML, formatted for easy reading 
* fields-with-metadata-in-raw.txt:  A quick listing of all XML elements sent for this collection 
* null-elements.txt:  Elements containing no value, modify XSLT to remove these 
* values-with-semicolons.txt:  Text that may be HTML, or contain delimited values 
* html.txt:  Text that might be XML 
* datevals.txt:  Date values that should be re-formatted 


Use the information from these files and the script output to modify a new set-specific XSLT file.  Newly-created XSLT files (added when you create a new collection) are found at $SLODPLA_LIB/bySet/base-transform/SETSPEC.xsl, where "SETSPEC" is the setSpec / ID you've chosen for this set.



The "review-qdc-conversion.sh" script runs a variety of simple tests against the data, including:

 * Has the collection name been changed in the REPOX XSLT?
 * Has the contributor name been changed in the REPOX XSLT?
 * Are there values in the submitted data containing semi-colons (possibly a subfield-delimiter, or HTML)?
 * Are date values using undesireable formatting?
 * Are there null-value elements?
 * Is there a discrepancy between the tallies of edm:rights and edm:isShownAt values?
 * How many records are viable IIIF records?



## Uploading data to DPLA

The ingest process is handled via the scripts and files found under $SLODPLA_ROOT/ingest.  Within that directory is a readme file that contains additional details about exactly what needs to be done, but the process boils down to reading the files under $SLODATA_STAGING and running through a set of scripts.  Some of the scripts will prepare the data for upload and others are reports that will provide a final check prior to uploading the data to DPLA.








