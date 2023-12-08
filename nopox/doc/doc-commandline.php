
<p>Scripts have been created to handle tasks at the server command line.  These tasks center around the management of the system and things that alter data.  All write-operations are accomplished via the command line.  The web-based interface is only for reporting.</p>

<p>At this time, some SQL updates will still required.</p>

<h3>Environment</h3>
<p>To successfully use the command line scripts, you must setup your environment; This allows easy access to MySQL, and defines where various application directories are located.  That means ensuring that you have a .my.cnf file in your home directory, and ensuring that you load the appropriate environment variables via ". /usr/local/SLO-DPLA/conf/SLO-DPLA-environment.conf".</p>


<p>These scripts would all be found in $SLODPLA_BIN.  They make copious use of XSLT scripts that are found in/under $SLODPLA_LIB.</p>



<h3>Shell Scripts for normal workflow</h3>
<p>The normal workflow would have you run the scripts in this order:</p>
<table border=1>
<tr>
  <td>addset.sh</td><td>Use this to define the new set in the system.  You will specify the set to harvest, the OAI-PMH base URL, the metadata format, etc.  A new provider will be created, if necessary.  The underlying MySQL database will be updated, but nothing will be harvested.</td>
</tr>
<tr>
  <td>get-raw.sh</td><td>Use this to retrieve data from the provider's remote OAI-PMH server.  This script will (a) remove "deleted" records from the harvested data, and (b) add OAI-PMH aggregator metadata to the records (which I refer to as making them "archivized".)  The data will be stored in two different forms:  The unmodified, raw data, and the modified, archivized data.  The files will be stored in the location $SLODATA_RAW and $SLODATA_ARCHIVIZED.</td>
</tr>
<tr>
  <td>dissect-raw.sh</td><td>This script examines newly-harvested data and generates a bunch of output that will prove helpful in customizing the base XSLT transform for this dataset.  This script WILL create output files in your working directory for use in customizing the set's XSLT, and you should run the script in a "scratch" directory so that these files don't end up intermingled with important stuff.</td>
</tr>
<tr>
  <td><em>(create a subsection on creating and debugging an XSLT transform)</em></td><td><a href="?action=doc-xslt">Find out more about creating an XSLT file</a></td>
</tr>
<tr>
  <td>base-transform.sh</td><td>Use this to apply the dataset's XSLT files against the harvested XML.  The resulting XML should conform to the ODN Metadata Application Profile (a.k.a. "MAP"; see:  https://ohiodigitalnetwork.org/contributors/getting-started/map/).  Note that it is possible for this script to run TWO different XSLT files against the dataset; All datasets need to be harmonized with the ODN MAP, but a few have additional filtering options that must be performed, and this script will also run those additional filtering operations, where applicable.  The output from this set is NOT dumped to the $SLODATA directory structure, but instead is left in the current working directory to be further manipulated by the IIIF modification.</td>
</tr>
<tr>
  <td>iiif-insert.sh</td><td>This script will add IIIF/WikiMedia information to records based on whether (a) the record's edm:rights value is compatible, and (b) the set owning the record is listed as a participant in the WikiMedia project.  Running the script against a dataset that is NOT participating in the WikiMedia project will not affect the data, and you should make a habit of running this script against every dataset.  The output from this script is dumped to the current working directory, and will be copied to the $SLODATA_STAGING directory later when you run the "staging.sh" script.</td>
</tr>
<tr>
  <td>review-base-transform.sh</td><td>This script will review the XSLT tranformations implemented by the "base-transform.sh" and the "iiif-insert.sh" scripts.  It's a quick overview of data that will allow you to catch obvious errors.  A positive result from this script should be obtained before sending the metadata to Penelope for a final review.</td>
</tr>
<tr>
  <td>staging.sh</td><td>Use this to copy the reviewed data to the $SLODATA_STAGING directory.  It's now ready to be reviewed by Penelope for any problems.</td>
</tr>
<tr>
  <td>queue4ingest.sh</td><td>This script will copy the XML data from the $SLODATA_STAGING directory to the $SLODATA_INGEST directory, where it will be ready to be pushed to DPLA for the quarterly ingest.</td>
</tr>
</table>

<p>You might also need to remove a set after creating it.  This might be necessary if a provider decides to stop sharing a collection, or if their server is migrated to another system.  There's a script that will accomplish that:</p>
<ul>
<li>remove-set.sh</li>
</ul>


<p>These scripts intentionally spew a lot of output to the screen.  When you're new to the application, this flood of information will probably be overwhelming, but that output can be helpful when trying to debug a problem with the metadata transformation process.</p>


<h3>XSLT scripts for additional reporting and tasks</h3>
<p>Additional scripts for troubleshooting / reporting found in $SLODPLA_LIB/.  These XSLT files would be applied to a given "input.xml" file using Java and the Saxon XSLT libraries.  For example:<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;$ java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/somefile.xsl -s:input.xml
<br>
<br>
Note, in particular, the "$SLODPLA_LIB/show-*.xsl" scripts (and similar constructs) can be quite useful in certain conditions.</p>






