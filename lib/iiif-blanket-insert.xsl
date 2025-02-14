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


  <!-- This XSLT is intended to add dcterms:isReferencedBy values to a dataset.  -->

  <!-- It currently detects whether a server is:                                 -->
  <!--    a.  running CONTENTdm, or                                              -->
  <!--    b.  is part of Kent's OAKS server.                                     -->

  <!-- The XSLT tests each record to confirm that the record has an emd:rights   -->
  <!-- value appropriate for Wikimedia inclusion.                                -->

  <!-- If the record is shared, an appropriate IIIF value is generated for the   -->
  <!-- dcterms:isReferencedBy field based on whether the record is coming from   -->
  <!-- CONTENTdm or OAKS.                                                        -->

  <!-- Note that the addition of a new IIIF-participant who is not using OAKS or -->
  <!-- CONTENTdm will mandate the update of this code.                           -->

  <xsl:template match="oai_qdc:qualifieddc">
    <xsl:copy>
        <xsl:attribute name="xsi:schemaLocation">http://worldcat.org/xmlschemas/qdc-1.0/  http://worldcat.org/xmlschemas/qdc/1.0</xsl:attribute>

        <xsl:apply-templates/>
        <xsl:choose>
           <xsl:when test="(starts-with(edm:rights, 'http://rightsstatements.org/vocab/NoC-US/') or
                            starts-with(edm:rights, 'http://creativecommons.org/publicdomain/mark/') or
                            starts-with(edm:rights, 'http://creativecommons.org/publicdomain/zero/') or
                            starts-with(edm:rights, 'http://creativecommons.org/licenses/by/') or
                            starts-with(edm:rights, 'http://creativecommons.org/licenses/by-sa/')
                           )">

                <xsl:variable name="tokens" select="tokenize(edm:isShownAt, '/')"/>
                <xsl:choose>
                    <!-- viable CONTENTdm record -->
                    <xsl:when test="contains(edm:isShownAt, '/cdm/ref/collection/')">
                        <xsl:element name="dcterms:isReferencedBy" namespace="http://purl.org/dc/terms/">{$tokens[1]}//{$tokens[3]}/iiif/info/{$tokens[7]}/{$tokens[9]}/manifest.json</xsl:element>
                    </xsl:when>
                    <!-- viable OAKS record -->
                    <xsl:when test="contains(../../header/identifier, ':oaks.kent.edu:node-')">
                        <xsl:variable name="nodeIdString" select="tokenize(../../header/identifier, '-')"/>
                        <xsl:element name="dcterms:isReferencedBy" namespace="http://purl.org/dc/terms/">{$tokens[1]}//{$tokens[3]}/node/{$nodeIdString[last()]}/manifest</xsl:element>
                    </xsl:when>
                 </xsl:choose>
          </xsl:when>
       </xsl:choose>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="/OAI-PMH/ListRecords">
    <xsl:copy>
        <xsl:attribute name="xsi:schemaLocation">http://worldcat.org/xmlschemas/qdc-1.0/ http://worldcat.org/xmlschemas/qdc/1.0/qdc-1.0.xsd http://purl.org/net/oclcterms http://worldcat.org/xmlschemas/oclcterms/1.4/oclcterms-1.4.xsd</xsl:attribute>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
