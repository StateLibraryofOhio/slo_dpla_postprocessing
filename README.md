# slo_dpla_postprocessing
XSLT to run against data exported from REPOX before upload to DPLA


# Purpose

This is a collection of utilities intended to be used in the processing of the XML for DPLA.

These utilities will be useful for:

* The initial evaluation of a site's XML metadata,
* Creation of an XSLT template to transform a collection's metadata to a standardized XML format
* Subsequent manipulation of the XML after it has reached the "standardized" phase

As part of the normal workflow, the "Subsequent manipulation" step includes the removal of deleted records and insertion of IIIF metadata to specific records where the records meet specific criteria.  Additional XSLT in the project's "lib" directory can be used on a one-off basis against specific XML files to ID records without rights information, etc.



# Usage

See the information in the doc/ subdirectory for more technical details about how to make things work.

The process expects that you are logged into a Linux system with Java and the Saxon libraries installed and in your CLASSPATH.

To run an XML file through an XSLT filter on a one-off basis, try something like:

   java net.sf.saxon.Transform -s:INPUT-XML-FILE.xml -o:OUTPUT-FILE.xml -xsl:remove-deletes--add-IIIF.xsl


# Logic

The IIIF insertion XSLT checks the `edm:rights` metadata associated with the record AND it confirms that the OAI set has been enabled for IIIF processing.

If the `edm:rights` is compatible and the OAI set should be processed for IIIF metadata, then an appropriate `isReferencedBy` metadata value is generated and added to the XML for that record.

If the edm:rights is not compatible, OR if the `edm:rights` is compatible but the OAI set isn't scheduled to undergo IIIF processing, then an empty `isReferencedBy` XML tag is added to the record.


Deleted records are removed from the XML data by looking in each `record`'s `header` element to see if there's a `status` attribute with a value of `deleted`.
