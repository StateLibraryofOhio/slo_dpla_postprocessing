
<p>Objective of the application:    <em>"To pull metadata from ODN contributors' digital collections, standardize the metadata for each collection around the ODN specification, and upload the metadata to DPLA on a quarterly basis.  Do this for hundreds of collections, each with its own quirks."</em>

<hr>
<p>Data origin:
<ul>
<li>Many different remote data sources</li>
<li>Multiple Content Management Systems providing us data</li>
<li>Many different remote catalogers, so there are many cataloging quirks to clean up</li>
<li>Currently all using OAI-PMH for retrieval, but conceivably we could accept other formats</li>
</ul>

<p>During the journey:
<ol>
<li>Remove "deleted" records from the input - these are a "stateless data" byproduct, unwanted by DPLA</li>
<li>Add OAI-PMH Archival Metadata to the incoming data</li>
<li>Syncronize the incoming data to the standard set of XML tags used by ODN for our DPLA uploads (e.g. change "dc:title" to "dcterms:title")</li>
<li>Clean up the incoming metadata (e.g. remove HTML, break subject elements into separate XML elements where easily accomplished)</li>
<li>Selectively add IIIF information to data participating in the WikiMedia project</li>
</ol>

<p>Data's final destination:
<ul>
<li>Local Storage, for upload to DPLA's S3 bucket on a quarterly basis</li>
</ul>
<br>
<hr>


<pre>


Application Architecture Overview

  Comparison:  Admin UI vs. Commandline UI
          fewer privileges == reduced security profile
          read-only == much simpler code
          I'm the only user --&gt; bare bones UI

  Admin web interface:
      A LAMP interface composed of PHP, Apache, MySQL
      all server-side code
      read-only interface to the system

  Commandline UI:
     MySQL, Java, Saxon XSLT libraries, bash, standard unix utilities, a dash of Python
     This will be used to change things in the system
     Arcane, but flexible.  But, yeah...arcane.


Installation (current)
    * Ubuntu 22.04
    * PHP  (apt package:   php)
    * Python (apt package:  python2)
    * MySQL (apt package:  mariadb-server)
    * PHP/MySQL connector (apt package:  php-mysql)
    * Saxon for Java (download from saxonica.com)
    * Java (apt package:  openjdk-19-jdk)
    * apt package  libxml-commons-resolver1.1-java
    * apt package  libxml2-utils
    * Git &amp; utilities (apt package:  gh; Do NOT use the "snap" package!!!)
    * apt package apache2
    * apt package unzip


Configuration
    * ~/.my.cnf
    * ~/.bash*
    * Apache:  As directed in $SLOPLA_CONF/apache2
    * $SLODPLA_ROOT/nopox/login.php file:  MySQL password
    * $SLODPLA_ROOT/conf/SLO-DPLA-environment.conf 
        = various application-level settings, including $SLODATA splitting data to different storage devices


Logging
    * Apache under /var/log/apache2/*
    * Individual harvests should have corresponding entries in the slo_aggregator.oldTasks table
    * Plenty of real-time error displays in the commandline UI
  




Git repo information
  fruviad/Repox2MySQL code
    * The migration process for data from REPOX to nopox
    * Will be deprecated with the formal migration from REPOX
  slo_dpla_postprocessing
    * Started out as a modification to way to remove "deleted" records from REPOX output; evolved.







Database schema documentation
  * Note:  Transliterated from the REPOX XML config; some pieces don't do anything but seemed good to leave in, on the possibility of using them in the future
  * Note:  No special indexes / views / foreign keys / etc. in the database; it's small and simple

  To create the database:
    MariaDB [mysql]> create database slo_aggregator;
    MariaDB [mysql]> create user 'pkukla'@'localhost' identified by 'newhire';
    MariaDB [mysql]> grant all privileges on *.* to 'pkukla'@'localhost';



Overview of the "data pipeline", and the changes that are made to the data during the process
  * Adding new datasets
      - describe the process of adding/editing the base transform
      - describe the process of adding/editing the filter transform
  * Re-harvesting datasets
      - occurs on an irregular basis, with the oldest first, and on an "as we have the time to review new data" basis
  * Removal of datasets



Commandline documentation
    Some SQL updates still req'd; discuss MySQL access
    Basic scripts to handle workflow found in $SLODPLA_BIN/
        addset.sh
        get-raw.sh
        dissect-raw.sh
        base-transform.sh
        iiif-insert.sh
        review-base-transform.sh
        staging.sh
        queue4ingest.sh
        remove-set.sh


    Additional scripts for troubleshooting / reporting found in $SLODPLA_LIB/
        The "show-*.xsl" scripts


   

        


Local File Storage details
  Storage can be redirected to other physical / virtual storage devices via the application configuration settings found in $SLODPLA_CONF/SLO-DPLA-environment.conf
  Varying versions of the same data are retained for QA purposes
      * Raw - Ths is exactly what was retrived from the contributor's server
      * Archivized - The "raw" data, but altered to include archival metadata
      * Staging - metadata from raw has been synched to the ODN upload format
      * Ingest - what's going to be uploaded to DPLA during the next quarterly ingest



</pre>
