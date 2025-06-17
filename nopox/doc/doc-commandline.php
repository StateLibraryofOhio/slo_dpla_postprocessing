
<p>Scripts have been created to handle tasks at the server command line.  These tasks center around the management of the system and things that alter data.  All write-operations are accomplished via the command line.  The web-based interface is only for reporting.</p>

<p>At this time, some manual SQL updates will still be required.</p>

<h3>Environment</h3>
<p>To successfully use the command line scripts, you must setup your environment through the configuration of various environment variables and application settings.</p>

<p>This application relies upon a number of different environment variables which refer to different areas of the filesystem.  There are about 15 such variables, and they refer to directories in 2 different locations.<br><br>  The first directory is the $SLODATA location; this is where the harvested metadata and modified versions thereof are stored.  The second directory is the $SLODPLA_ROOT directory; this is where the application lives.<br><br>The other environment variables point at specific locations underneath either of these directories.  The $SLODPLA_LIB directory, for example, is under the $SLODPLA_ROOT, and it contains the XSLT files that are used to modify the harvested metadata to harmonize it with the format we use for uploading to DPLA.  Some of these environment variables will be used by the shell scripts that comprise the application, while others are simply for making it easier to change to a given directory while navigating through the system at the OS commandline.</p>

<table border=1>
  <tr>
    <th>Environent variable</th>
    <th>Purpose</th>
  </tr>

   <tr>
     <td>$SLODPLA_ROOT</td>
     <td>Root directory containing all of the files for the application</td>
   </tr>

   <tr>
     <td>$SLODPLA_LIB</td>
     <td>The directory containing XSLT files that are "general purpose", rather than targeted to a specific set of data.</td>
   </tr>

   <tr>
     <td>$SLODPLA_STAGING</td>
     <td>deprecated and unused; might change</td>
   </tr>

   <tr>
     <td>$SLODPLA_FILTERXSLT</td>
     <td>The typical dataset processing consists of harvesting all of the records for a given contributed collection, and then uploading all of those records to DPLA.  A few datasets, however, require additional processing.  OSU, for example, has contributed a set in which a few of the records SHOULD NOT be uploaded to DPLA.  The XSLT for this OSU set responsible for eliminating the unwanted subset of records is stored in this directory.</td>
   </tr>

   <tr>
     <td>$SLODPLA_CONF</td>
     <td>Configuration files for the application are stored here.</td>
   </tr>

   <tr>
     <td>$SLODPLA_BIN</td>
     <td>Shell scripts (which make up most of the application) are stored in this directory.</td>
   </tr>

   <tr>
     <td>$SLODPLA_BASEXSLT</td>
     <td>Every collection harvested from a contributor has its own XSLT file.  This XSLT will either (a) map an incoming field (e.g. dcterms:alternative) to a corresponding field in our "Metadata Application Profile", or (b) eliminate the field from the data entirely so that it's not uploaded to DPLA.  These XSLT files are stored in this directory.</td>
   </tr>

   <tr>
     <td>$SLODATA</td>
     <td>All harvested metadata is stored under this directory.  This location should not be on the same disk/QCOW2 file as that holding the application ($SLODPLA_ROOT).  Because we are working with large amounts of metadata, it is possible to completely fill the disk with data.  In the case of a QCOW2 file, filling the disk entirely will cause the entire QCOW2 file to be corrupted.  Putting both in the same QCOW2 file would cause the MySQL database to be corrupted and would cause a catastrophic loss of data in a worst-case-scenario, but putting them in separate locations would ensure that data loss would be restricted to the harvested data and would allow for easy recovery (i.e. simple re-harvesting of all contributed collections).  Use the "virsh attach-disk" command to associate the storage QCOW2 file with the main QCOW2 file holding the operating system:<br><br>
virsh attach-disk nopox /var/lib/libvirt/images/PRODUCTION/nopox/nopox_external.qcow2 vdb --subdriver qcow2 --persistent<br><br>
Note that if you are migrating the VM from one VM host to another, then it would probably be a good idea to edit the /etc/fstab file and comment out the line mounting that external QCOW2 before moving the VM, and then restoring the value after the VM has been setup on the new VM host and the external QCOW2 has been associated with the VM in the new location.  If the VM boots and it has problems mounting the external storage, the OS will be very unhappy.
</td>
   </tr>

   <tr>
     <td>$SLODATA_ARCHIVIZED</td>
     <td>Data that is harvested from remote OAI-PMH servers needs to have archival metadata added to it, as per the documentation here:<br>
         &nbsp;&nbsp;&nbsp;&nbsp; <a href="https://www.openarchives.org/OAI/2.0/guidelines-provenance.htm">https://www.openarchives.org/OAI/2.0/guidelines-provenance.htm</a><br>
         After we harvest data from the contributors' servers, we add that metadata and store the modified, "archivized" version of the data in this directory.  Subsequent steps will further modify this data.
     </td>
   </tr>

   <tr>
     <td>$SLODATA_INGEST</td>
     <td>Each quarterly upload to DPLA is processed in a subdirectory of this location.  The subdirectory would be named "YYYY-MM" (YYYY=the current year; MM=the current month).  To create the appropriate subdirectory, copy the entire $SLODPLA_INGEST to an appropriate name (e.g. "cp -pr $SLODPLA_ROOT/ingest $SLODATA_INGEST/2025-03).</td>
   </tr>

   <tr>
     <td>$SLODATA_RAW</td>
     <td>This is the XML data that has been harvested from the contributors' servers before we have made any changes to it.  Upon harvesting the data to this location, we immediately "archivize" the data in this directory and store the modified data in $SLODATA_ARCHIVIZED.  Nothing more is done with this "raw" data, but we retain it for debugging purposes.</td>
   </tr>

   <tr>
     <td>$SLODATA_ROOT</td>
     <td>Same as $SLODATA.</td>
   </tr>

   <tr>
     <td>$SLODATA_STAGING</td>
     <td>This is where data is stored after it has undergone all of our transformations and is ready for upload to DPLA.</td>
   </tr>

   <tr>
     <td>$SLODATA_WORKING</td>
     <td>This is the parent directory for locations in which one downloads data from a contributor, runs the data through the various XSLT manipulations, and generally prepares it for upload to DPLA.</td>
   </tr>

</table>



<h3>Files used for configuring the application</h3>
<table border=1>
  <tr>
    <th>Config file</th>
    <th>Setting(s)</th>
  </tr>

  <tr>
    <td>~/.bashrc</td>
    <td># easily jump to the $SLODPLA_ROOT directory<br>
        alias go="cd $SLODPLA_ROOT"<br>
        <br>
        # disable annoying change in bash<br>
        bind "set enable-bracketed-paste off"<br>
        <br>
        # disable annoying change in bash<br>
        shopt -s direxpand<br>
        <br>
        # point at the Saxon Java libraries<br>
        export CLASSPATH=$CLASSPATH:/usr/local/lib/Saxon/*<br>
        <br>
        # load the appropriate environment vars from the app config file
        . /usr/local/SLO-DPLA/conf/SLO-DPLA-environment.conf<br>
    </td>
  </tr>
  <tr>
    <td>~/.my.cnf</td>
    <td>[client]<br>
        user=pkukla<br>
        host=localhost<br>
        password=your_mariadb_password<br>
        database=slo_aggregator
    </td>
  </tr>
  <tr>
    <td>Git editor
    </td>
    <td>git config --global core.editor vim
    </td>
  </tr>

  <tr>
    <td>$SLODPLA_CONF/SLO-DPLA-environment.conf</td>
    <td>Various environment variables that point to locations on disk where the app stores:<br>
         * data<br>
         * executables and scripts<br>
         * config files<br>
         * XSLT files</td>
  </tr>

</table>



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
  <td>queue4ingest.sh</td><td>This script isn't used at the moment.</td>
</tr>
</table>

<p>You might also need to remove a set after creating it.  This might be necessary if a provider decides to stop sharing a collection, or if their server is migrated to another system.  There's a script that will accomplish that:</p>
<ul>
<li>remove-set.sh</li>
</ul>
<p>Note that the "remove-set.sh" script is not currently removing the set-specific XSLT files associated with the set, and that should be done manually.</p>

<p>These scripts intentionally spew a lot of output to the screen.  When you're new to the application, this flood of information will probably be overwhelming, but that output can be helpful when trying to debug a problem with the metadata transformation process.</p>


<h3>XSLT scripts for additional reporting and tasks</h3>
<p>Additional scripts for troubleshooting / reporting found in $SLODPLA_LIB/.  These XSLT files would be applied to a given "input.xml" file using Java and the Saxon XSLT libraries.  For example:<br>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;$ java net.sf.saxon.Transform -xsl:$SLODPLA_LIB/somefile.xsl -s:input.xml
<br>
<br>
Note, in particular, the "$SLODPLA_LIB/show-*.xsl" scripts (and similar constructs) can be quite useful.  When you have a dataset that has problems with the data, you can use these scripts to determine the URLs for the individual records affected by the problem(s).  These URLs can then be sent back to the contributing institution, making it easier to find and fix the metadata problems.</p>






