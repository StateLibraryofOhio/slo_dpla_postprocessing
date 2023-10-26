<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
  xsi:schemaLocation="http://worldcat.org/xmlschemas/qdc-1.0/
                      http://worldcat.org/xmlschemas/qdc/1.0/qdc-1.0.xsd
                      http://purl.org/net/oclcterms
                      http://worldcat.org/xmlschemas/oclcterms/1.4/oclcterms-1.4.xsd"
  exclude-result-prefixes="xs"
  version="2.0"
  xmlns="http://www.loc.gov/mods/v3">

  <xsl:output omit-xml-declaration="yes" indent="yes"/>

  <!-- pull in our common template file -->
  <xsl:include href="odn_templates.xsl"/>

  
  <xsl:template match="text()|@*"/>
  <xsl:template match="//oai_qdc:qualifieddc">
    <oai_qdc:qualifieddc
            xmlns:oai_qdc="http://worldcat.org/xmlschemas/qdc-1.0/"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:dcterms="http://purl.org/dc/terms/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://worldcat.org/xmlschemas/qdc-1.0/
                                http://worldcat.org/xmlschemas/qdc/1.0/qdc-1.0.xsd
                                http://purl.org/net/oclcterms
                                http://worldcat.org/xmlschemas/oclcterms/1.4/oclcterms-1.4.xsd">

      <!-- STATIC VALUES FOR ODN-MAP fields -->
      <xsl:element name="edm:dataProvider" namespace="http://www.europeana.eu/schemas/edm/">Columbus Metropolitan Library</xsl:element>     <!-- create edm:dataProvider -->
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Genealogy Collection</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP FIELDS -->
      <xsl:apply-templates select="dc:identifier"            mode="odn"/>                     <!-- create edm:isShownAt, edm:preview, and dcterms:identifier  -->
      <xsl:apply-templates select="dc:rights"                mode="cml_genealogy"/>           <!-- create edm:rights    and dc:rights                         -->
      <xsl:apply-templates select="dc:title"                 mode="odn"/>                     <!-- create dcterms:title                                       -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"              mode="cml_genealogy"/>           <!-- create dcterms:language                                    -->
      <xsl:apply-templates select="dc:creator"               mode="cml_genealogy"/>           <!-- create dcterms:creator                                     -->
      <xsl:apply-templates select="dc:date"                  mode="cml_genealogy"/>           <!-- create dc:date                                             -->
      <xsl:apply-templates select="dc:format"                mode="odn"/>                     <!-- create dc:format                                           -->
      <xsl:apply-templates select="dcterms:spatial"          mode="cml_genealogy"/>           <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dc:subject"               mode="odn"/>                     <!-- create dcterms:subject                                     -->
      <xsl:apply-templates select="dc:type"                  mode="cml_genealogy"/>           <!-- create dcterms:type                                        -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative"      mode="odn"/>                     <!-- create dcterms:alternative                                 -->
      <xsl:apply-templates select="dc:contributor"           mode="cml_genealogy"/>           <!-- create dcterms:contributor                                 -->
      <xsl:apply-templates select="dc:description"           mode="odn"/>                     <!-- create dcterms:description                                 -->
      <xsl:apply-templates select="dcterms:extent"           mode="cml_genealogy"/>           <!-- create dcterms:extent                                      -->
                                                                                              <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:copy-of         select="dcterms:isReferencedBy"   copy-namespaces="no"/>           <!-- create IIIF metadata                                       -->
      <xsl:apply-templates select="dc:publisher"             mode="cml_genealogy"/>           <!-- create dcterms:publisher                                   -->
      <xsl:apply-templates select="dc:relation"              mode="odn"/>                     <!-- create dc:relation                                         -->
      <xsl:apply-templates select="dcterms:isPartOf"         mode="odn"/>                     <!-- create dc:relation                                         -->
                                                                                              <!-- dc:rights is created above as part of the edm:rights transform -->
      <xsl:copy-of         select="dcterms:rightsHolder"     copy-namespaces="no"/>           <!-- create dcterms:rightsHolder                                -->
      <xsl:apply-templates select="dcterms:temporal"         mode="cml_genealogy"/>           <!-- create dcterms:temporal                                    -->
      <xsl:apply-templates select="dcterms:accessRights"     mode="cml_genealogy"/>           <!-- create dcterms:temporal                                    -->
      <xsl:apply-templates select="dcterms:issued"           mode="cml_genealogy"/>
      <xsl:apply-templates select="dcterms:coverage"         mode="cml_genealogy"/>
      <xsl:apply-templates select="dcterms:medium"           mode="cml_genealogy"/>
      <xsl:apply-templates select="dc:source"                mode="cml_genealogy"/>
      <xsl:apply-templates select="dcterms:mediator"         mode="cml_genealogy"/>
      <xsl:apply-templates select="dc:contributor"           mode="cml_genealogy"/>
      <xsl:apply-templates select="dcterms:provenance"       mode="cml_genealogy"/>
      <xsl:apply-templates select="dcterms:isVersionOf"      mode="cml_genealogy"/>
      <xsl:apply-templates select="dcterms:references"       mode="cml_genealogy"/>

    </oai_qdc:qualifieddc>
  </xsl:template>

  <xsl:template match="dcterms:issued" mode="cml_genealogy"/>
  <xsl:template match="dcterms:temporal" mode="cml_genealogy"/>
  <xsl:template match="dcterms:medium" mode="cml_genealogy"/>
  <xsl:template match="dc:language" mode="cml_genealogy"/>
  <xsl:template match="dc:source" mode="cml_genealogy"/>
  <xsl:template match="dc:rights" mode="cml_genealogy"/>
  <xsl:template match="dcterms:mediator" mode="cml_genealogy"/>
  <xsl:template match="dc:type" mode="cml_genealogy"/>
  <xsl:template match="dcterms:extent" mode="cml_genealogy"/>
  <xsl:template match="dc:publisher" mode="cml_genealogy"/>
  <xsl:template match="dc:contributor" mode="cml_genealogy"/>
  <xsl:template match="dcterms:provenance" mode="cml_genealogy"/>
  <xsl:template match="dcterms:isVersionOf" mode="cml_genealogy"/>
  <xsl:template match="dcterms:references" mode="cml_genealogy"/>

  <xsl:template match="dcterms:spatial" mode="cml_genealogy">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="(normalize-space(.) != '')">
        <xsl:element name="dcterms:spatial" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:coverage" mode="cml_genealogy">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="(normalize-space(.) != '')">
        <xsl:element name="dcterms:spatial" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:date" mode="cml_genealogy">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="(normalize-space(.) != '')">
        <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:creator" mode="cml_genealogy">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="(normalize-space(.) != '')">
        <xsl:element name="dcterms:creator" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dcterms:accessRights" mode="cml_genealogy">
    <xsl:for-each select="tokenize(., ';')">
        <xsl:if test="(normalize-space(.) != '') and (starts-with(normalize-space(.), 'http://') and ends-with(normalize-space(.), '/'))" >
            <xsl:choose>
              <xsl:when test="starts-with(normalize-space(.), 'http://rightsstatements.org/')">
                            <xsl:if test="index-of($rightsStatementsOrgList, normalize-space(.))">
                                <xsl:element name="edm:rights" namespace="http://www.europeana.eu/schemas/edm/">
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:element>
                            </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:if test="starts-with(normalize-space(.), 'http://creativecommons.org/')">
                            <xsl:if test="index-of($creativeCommonsOrgList, normalize-space(.))">
                                <xsl:element name="edm:rights" namespace="http://www.europeana.eu/schemas/edm/">
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:element>
                            </xsl:if>
                  </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
     </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
