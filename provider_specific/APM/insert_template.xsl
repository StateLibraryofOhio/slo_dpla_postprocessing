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

  <xsl:mode on-no-match="shallow-copy"/>

  <!-- The intent of this script is to serve as a "template" which is used
       to add the edm:preview values to the XML harvested from America's 
       Packard Museum.

       This separate step is necessary due to the fact that APM is not 
       sending their edm:preview values in the OAI-PMH metadata; instead,
       they are posting the edm:preview metadata in the public-facing
       webpage for each record (i.e. the URL in edm:isShownAt).

       A copy of this file is created by the "insert-thumbs-from-summary- -apm.sh"
       script, with the copy being updated with the desired metadata values.
       This copy is deleted after use.
   -->


  <xsl:template match="oai_qdc:qualifieddc">
    <xsl:copy>
        <xsl:attribute name="xsi:schemaLocation">http://worldcat.org/xmlschemas/qdc-1.0/  http://worldcat.org/xmlschemas/qdc/1.0</xsl:attribute>

        <xsl:apply-templates/>
        <xsl:choose>
           <xsl:when test="(
                            edm:isShownAt[text()]='XYZZY_URL'
                           )">
                <xsl:element name="edm:preview" namespace="http://www.europeana.eu/schemas/edm/">XYZZY_PREVIEW</xsl:element>
           </xsl:when>
       </xsl:choose>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
