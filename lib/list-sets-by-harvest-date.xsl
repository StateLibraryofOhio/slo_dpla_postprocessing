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
  expand-text="yes">

<xsl:output method="text" encoding="UTF-8"/>


<!-- 
This is intended to be run against the REPOX config file "dataProviders.xml" 
in order to return a list of all sets, their last harvest dates, the owning
organizations, and the collection name.

The output will be dumped to a pipe-delimited text file which can then be
loaded into Excel for analysis as to which sets we wish to re-harvest next.
-->

  <xsl:template match="@*|text()"/>
  <xsl:template match="/data-providers">
    
    <xsl:for-each select="./provider">
      <xsl:for-each select="./source">
        <xsl:value-of select="./@lastIngest"/>|<xsl:value-of select="./description"/>|<xsl:value-of select="./@id"/>|<xsl:value-of select="../name"/> 
        <xsl:text>&#xa;</xsl:text>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>



</xsl:stylesheet>

