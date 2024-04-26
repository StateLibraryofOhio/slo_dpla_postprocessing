# slo_dpla_postprocessing
Managing the harvesting and metadata mapping of datasets


# Purpose

This is a collection of utilities intended to be used in the processing of the XML data contributed to ODN with the intent that it be loaded into the Digital Public Library of America (DPLA).

These utilities will be useful for:

* The initial evaluation of a site's XML metadata,
* Creation of an XSLT template to transform a collection's metadata to the ODN standard XML format
* Subsequent manipulation of the XML after it has reached the "standardized" phase
* Uploading the XML data to the DPLA's AWS S3 storage area

As part of the normal workflow, the "Subsequent manipulation" step includes the insertion of IIIF metadata for specific records where the record meets specific criteria.  Additional XSLT in the project's "lib" directory can be used on a one-off basis for testing and diagnostics purposes, such as running specific XML files through an XSLT to ID records without rights information, etc.



# Usage

See the information in the doc/ subdirectory for more technical details about how to make things work.

The process expects that you are logged into a Linux system with Java and the Saxon libraries installed and in your CLASSPATH.

To run an XML file through an XSLT filter on a one-off basis, try something like:

   java net.sf.saxon.Transform -s:INPUT-XML-FILE.xml -o:OUTPUT-FILE.xml -xsl:$SLODPLA_LIB/somefile.xsl


# Logic

The IIIF insertion XSLT checks the `edm:rights` metadata associated with the record AND it confirms that the OAI set has been enabled for IIIF processing.

If the `edm:rights` is compatible and the OAI set should be processed for IIIF metadata, then an appropriate `isReferencedBy` metadata value is generated and added to the XML for that record.

If the edm:rights is not compatible, OR if the `edm:rights` is compatible but the OAI set isn't scheduled to undergo IIIF processing, then an empty `isReferencedBy` XML tag is added to the record.


Deleted records are removed from the XML data by looking in each `record`'s `header` element to see if there's a `status` attribute with a value of `deleted`.  When the State Library was using REPOX, these deleted records were removed after the set-specific XSLT transforms had been run against the contributed data.  With the transition of the harvesting duties to this app, the removal of deleted records is now occurring during the initial harvest of the data from the contributor's server.  The deleted records will be visible in the "raw" versions of the downloaded XML, but expunged from all other variants of the files.





