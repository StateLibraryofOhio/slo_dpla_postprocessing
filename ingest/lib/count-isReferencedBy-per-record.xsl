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
    This XSLT is intended to return dcterms:isReferencedBy
    values for records that have more than one such value.
    A properly-formatted record can only have one of these
    values.

    For records with more than one such value, you should
    examine the XSLT transform to ensure it's correct, and
    you should examine the provider's raw data to see whether
    the problem lies there.  (Provider-based problems are
    really only an issue for non-CONTENTdm sites.)
-->

  <xsl:template match="@*|text()"/>
  <xsl:template match="record">
    <xsl:if test="count(./metadata/oai_qdc:qualifieddc/dcterms:isReferencedBy)>1">
      <xsl:value-of select="count(./metadata/oai_qdc:qualifieddc/dcterms:isReferencedBy)"/> | <xsl:value-of select="metadata/oai_qdc:qualifieddc/edm:isShownAt"/><xsl:text>
</xsl:text>
    </xsl:if>
  </xsl:template>



</xsl:stylesheet>

