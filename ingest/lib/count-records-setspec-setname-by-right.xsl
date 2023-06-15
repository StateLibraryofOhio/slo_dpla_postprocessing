<xsl:stylesheet
  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:oai-pmh="http://www.openarchives.org/OAI/2.0/"
  xmlns:oai_qdc="http://worldcat.org/xmlschemas/qdc-1.0/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dcmitype="http://purl.org/dc/dcmitype/"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:oclcdc="http://worldcat.org/xmlschemas/oclcdc-1.0/"
  xmlns:mods="http://www.loc.gov/mods/v3"
  exclude-result-prefixes="xs"
  xpath-default-namespace="http://www.openarchives.org/OAI/2.0/"
  expand-text="yes">

<xsl:output method="text" encoding="UTF-8"/>


<!-- 
     This XSLT is intended to return a numeric value showing the
     number of OAI-PMH records in an XML harvest.
     by the gt or get-transformed.sh procedure".
-->

  <xsl:template match="@*|text()"/>
  <xsl:template match="//ListRecords">
    <xsl:for-each select="distinct-values(//edm:rights[*]/text())">
      <xsl:value-of select="count(./record)"/> | <xsl:value-of select="./record[1]/header[1]/setSpec"/> | <xsl:value-of select="./record[1]/metadata[1]/oai_qdc:qualifieddc[1]/edm:dataProvider"/> | <xsl:value-of select="./record[1]/metadata[1]/oai_qdc:qualifieddc[1]/dcterms:isPartOf"/> | <xsl:value-of select="./record[1]/metadata[1]/oai_qdc:qualifieddc[1]/edm:rights[1]"/><xsl:text>&#xa;</xsl:text>

    </xsl:for-each>
  </xsl:template>




</xsl:stylesheet>

