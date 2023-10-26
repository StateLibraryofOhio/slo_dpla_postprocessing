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

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<!--
     This XSLT is intended to remove certain records from a
     "transformed" XML harvest, where "transformed" == "generated
     by the gt or get-transformed.sh procedure".

     Instructions within this file are specific to the osu_xp68kg24f
     dataset.
-->

<xsl:mode on-no-match="shallow-copy"/>

  <xsl:template match="//record[./metadata/oai_qdc:qualifieddc/dcterms:creator[text()='Michaels, Larry R.']]"/>

  <xsl:template match="//record[./metadata/oai_qdc:qualifieddc/dcterms:type[text()='Sound']]"/>

  <xsl:template match="//record[./metadata/oai_qdc:qualifieddc/dcterms:contributor[text()='Cervantes Saavedra, Miguel de, 1547-1616']]"/>

</xsl:stylesheet>
