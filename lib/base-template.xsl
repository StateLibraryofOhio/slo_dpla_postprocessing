<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:oai-pmh="http://www.openarchives.org/OAI/2.0/"
  xmlns:oai_qdc="http://worldcat.org/xmlschemas/qdc-1.0/"
  xmlns:oaiProvenance="http://www.openarchives.org/OAI/2.0/provenance"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dcmitype="http://purl.org/dc/dcmitype/"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:oclcdc="http://worldcat.org/xmlschemas/oclcdc-1.0/"
  xsi:schemaLocation="http://worldcat.org/xmlschemas/qdc-1.0/        http://worldcat.org/xmlschemas/qdc/1.0/qdc-1.0.xsd
                      http://purl.org/net/oclcterms                  http://worldcat.org/xmlschemas/oclcterms/1.4/oclcterms-1.4.xsd
                      http://www.openarchives.org/OAI/2.0/provenance http://www.openarchives.org/OAI/2.0/provenance.xsd"
  exclude-result-prefixes="xs"
  version="2.0">

<xsl:output version="1.0" encoding="UTF-8"/>
  <!-- 
  The intent of this XSLT is to take "archivized" XML as input, and apply
  to it a set-specific XSLT that will map the set's metadata fields to the
  ODN equivalents.

  The output will be XML that is the equivalent of the REPOX "transformed"
  metadata.  The records will be transformed to the ODN specification, but
  the XML will still include deleted records, will not include IIIF metadata,
  and some sets will need further transformations to filter out additional
  records (e.g. OSU, Lorain's Feightner collection.)

  Example usage:

     java net.sf.saxon.Transform \
           -xsl:this.xsl \
           -s:pdk_boris-archivized.xml \
           -o:output.xml \
            setXsl='pdk_boris.xsl'

  There are undoubtedly better designs for this functionality, but this
  allowed me to reuse the XSLT files from REPOX with almost no changes.
  -->


  <!-- pull in our common template file -->
  <xsl:include href="SET_XSLT_INCLUDEFILE_REPLACEME"/>


  <!-- get the name of the element holding the records' metadata -->
  <xsl:variable name="METADATA_CHILD">
    <xsl:value-of select="name(//*:record[1]/*:metadata/*)"/>
  </xsl:variable>


  <!-- Identity Transform:  begin the copy process -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <!-- locate the metadata section and recreate with set-specific transforms -->
  <xsl:template match="*:metadata">
    <xsl:element name="metadata" namespace="http://www.openarchives.org/OAI/2.0/">
      <xsl:apply-templates select="./*[name()=$METADATA_CHILD]"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
