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

  <!-- 

  The intent of this XSLT transform is to add OAI-PMH archival metadata
  to newly-harvested ("raw") XML.

  The script takes the parameters:

      odnSetSpec:  Formerly known as the REPOX setSpec; typically formatted
                   as "contributor_setidentifier"

      origMetadataNamespace:  The OAI-PMH metadataNamespace URI used for
                              the harvest from the contributor's server

      oaiProvenanceBaseUrl:  The base URL used for harvesting the data


  Example usage:

     java net.sf.saxon.Transform \
           -xsl:this.xsl \
           -s:pdk_boris-raw-oai_dc.xml \
           -o:output.xml \
            odnSetSpec='pdk_boris' \
            origMetadataNamespace='http://www.openarchives.org/OAI/2.0/oai_dc/' \
            oaiProvenanceBaseUrl='https://cdm15716.contentdm.oclc.org/oai/oai.php'

  -->

  <xsl:output omit-xml-declaration="no" indent="yes"/>

  <xsl:variable name="datestamp" select="//oai-pmh:responseDate"/>

  <xsl:param name="odnSetSpec" as="xs:string"/>

  <xsl:param name="origMetadataNamespace" as="xs:string"/>

  <xsl:param name="oaiProvenanceBaseUrl" as="xs:string"/>

  <!-- <xsl:param name="input-uri" as="xs:string"/>
  <xsl:variable name="in" select="unparsed-text($input-uri, 'iso-8859-1')"/>
  -->


  <!-- pull in our common template file -->
  <xsl:include href="odn_templates.xsl"/>

  <xsl:template match="text()|@*"/>

  <xsl:template match="/" >
      <xsl:element name="OAI-PMH" xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd"><xsl:attribute name="xsi:schemaLocation">http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd</xsl:attribute>
          <xsl:element name="responseDate"><xsl:value-of select="$datestamp"/></xsl:element>
          <xsl:element name="ListRecords">
              <xsl:apply-templates select="//oai-pmh:record"/>
          </xsl:element>
      </xsl:element>
  </xsl:template>

  <xsl:template match="oai-pmh:record">
      <xsl:element name="record" xmlns="http://www.openarchives.org/OAI/2.0/">
          <xsl:element name="header" xmlns="http://www.openarchives.org/OAI/2.0/">
		  <xsl:element name="identifier" xmlns="http://www.openarchives.org/OAI/2.0/">urn:ohiodplahub.library.ohio.gov:<xsl:value-of select="$odnSetSpec"/>:<xsl:value-of select="oai-pmh:header/oai-pmh:identifier"/></xsl:element>
              <xsl:element name="datestamp"  xmlns="http://www.openarchives.org/OAI/2.0/"><xsl:value-of select="substring-before($datestamp, 'T')"/></xsl:element>
              <xsl:element name="setSpec"    xmlns="http://www.openarchives.org/OAI/2.0/"><xsl:value-of select="$odnSetSpec"/></xsl:element>
          </xsl:element>
          <xsl:element name="metadata" xmlns="http://www.openarchives.org/OAI/2.0/">
              <xsl:copy-of select="*:metadata/*"/>
              <!-- <xsl:copy select="oai-pmh:metadata/@*"/> -->
          </xsl:element>
          <xsl:element name="about">
              <xsl:element name="oaiProvenance:provenance">
                  <xsl:attribute name="xsi:schemaLocation">http://www.openarchives.org/OAI/2.0/provenance http://www.openarchives.org/OAI/2.0/provenance.xsd</xsl:attribute>
                  <xsl:element name="oaiProvenance:originDescription">
                      <xsl:attribute name="harvestDate"><xsl:value-of select="substring-before($datestamp, 'T')"/></xsl:attribute>
                      <xsl:attribute name="altered">true</xsl:attribute>
                  <xsl:element name="oaiProvenance:baseURL"><xsl:value-of select="$oaiProvenanceBaseUrl"/></xsl:element>
                  <xsl:element name="oaiProvenance:identifier"><xsl:value-of select="*:header/*:identifier"/></xsl:element>
                  <xsl:element name="oaiProvenance:datestamp"><xsl:value-of select="substring-before($datestamp, 'T')"/></xsl:element>
                  <xsl:element name="oaiProvenance:metadataNamespace"><xsl:value-of select="$origMetadataNamespace"/></xsl:element>
                  </xsl:element>
              </xsl:element>
          </xsl:element>
      </xsl:element>
  </xsl:template>

</xsl:stylesheet>
