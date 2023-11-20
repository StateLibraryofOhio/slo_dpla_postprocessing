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
     This XSLT is intended to be run against OAI-PMH ListSets
     output and will return the setName and setSpec for each
     set, separated by three hyphens for end-user readability.
-->

  <xsl:template match="@*|text()"/>
  <xsl:template match="//*:ListSets">
    <xsl:for-each select="./*:set">
      <xsl:sort select="*:setName"/>
        <xsl:value-of select="*:setName"/> --- <xsl:value-of select="*:setSpec"/>
        <xsl:text>&#10;</xsl:text> <!-- newline -->
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>


