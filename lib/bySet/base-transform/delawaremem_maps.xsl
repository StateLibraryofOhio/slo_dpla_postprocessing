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

  <!-- Change the "THIS_PROVIDER_NAME" and "THIS_COLLECTION_NAME" values in the "STATIC VALUES" section! -->

  <!-- pull in our common template file -->
  <xsl:include href="odn_templates.xsl"/>


  <xsl:template match="text()|@*"/>
  <xsl:template match="//oai_dc:dc">
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
      <xsl:element name="edm:dataProvider" namespace="http://www.europeana.eu/schemas/edm/">Delaware County Memory</xsl:element>     <!-- create edm:dataProvider -->
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Delaware County Maps</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP FIELDS -->
      <xsl:apply-templates select="dc:identifier"            mode="delawaremem_maps"/>   <!-- create edm:isShownAt, edm:preview, and dcterms:identifier  -->
      <xsl:apply-templates select="dc:rights"                mode="delawaremem_maps"/>   <!-- create edm:rights    and dc:rights                         -->
      <xsl:apply-templates select="dc:title"                 mode="odn"/>                     <!-- create dcterms:title                                       -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"              mode="odn"/>                     <!-- create dcterms:language                                    -->
      <xsl:apply-templates select="dc:creator"               mode="odn"/>                     <!-- create dcterms:creator                                     -->
      <xsl:copy-of         select="dc:date"                  copy-namespaces="no"/>           <!-- create dc:date                                             -->
      <xsl:apply-templates select="dc:format"                mode="odn"/>                     <!-- create dc:format                                           -->
      <xsl:copy-of         select="dcterms:spatial"          copy-namespaces="no"/>           <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dc:subject"               mode="delawaremem_maps"/>   <!-- create dcterms:subject                                     -->
      <xsl:apply-templates select="dc:type"                  mode="delawaremem_maps"/>   <!-- create dcterms:type                                        -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative"      mode="odn"/>                     <!-- create dcterms:alternative                                 -->
      <xsl:apply-templates select="dc:contributor"           mode="odn"/>                     <!-- create dcterms:contributor                                 -->
      <xsl:apply-templates select="dc:description"           mode="odn"/>                     <!-- create dcterms:description                                 -->
      <xsl:apply-templates select="dcterms:extent"           mode="odn"/>                     <!-- create dcterms:extent                                      -->
                                                                                              <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:apply-templates select="dc:publisher"             mode="odn"/>                     <!-- create dcterms:publisher                                   -->
      <xsl:apply-templates select="dc:relation"              mode="odn"/>                     <!-- create dc:relation                                         -->
      <xsl:apply-templates select="dcterms:isPartOf"         mode="odn"/>                     <!-- create dc:relation                                         -->
                                                                                              <!-- dc:rights is created above as part of the edm:rights transform -->
      <xsl:copy-of         select="dcterms:rightsHolder"     copy-namespaces="no"/>           <!-- create dcterms:rightsHolder                                -->
      <xsl:apply-templates select="dcterms:temporal"         mode="odn"/>                     <!-- create dcterms:temporal                                    -->

    </oai_qdc:qualifieddc>
  </xsl:template>


  <xsl:template match="dc:subject" mode="delawaremem_maps">
    <xsl:for-each select="tokenize(., '&#xA;')">
      <xsl:element name="dcterms:subject" namespace="http://purl.org/dc/terms/">
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="dc:identifier" mode="delawaremem_maps">
    <xsl:choose>
      <xsl:when test="contains(normalize-space(.), '/items/show/')">
        <xsl:element name="edm:isShownAt" namespace="http://www.europeana.eu/schemas/edm/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="contains(normalize-space(.), 'thumbnails')">
          <xsl:element name="edm:preview" namespace="http://www.europeana.eu/schemas/edm/">
              <xsl:value-of select="normalize-space(.)"/>
          </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="dc:type" mode="delawaremem_maps">
    <xsl:for-each select="tokenize(., '&#xA;')">
        <xsl:choose>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^class$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">Class</xsl:element>
          </xsl:when>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^event$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">Event</xsl:element>
          </xsl:when>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^image$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">Image</xsl:element>
          </xsl:when>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^interactive.?resource$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">InteractiveResource</xsl:element>
          </xsl:when>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^moving.?image$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">MovingImage</xsl:element>
          </xsl:when>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^physical.?object$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">PhysicalObject</xsl:element>
          </xsl:when>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^service$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">Service</xsl:element>
          </xsl:when>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^software$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">Software</xsl:element>
          </xsl:when>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^sound$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">Sound</xsl:element>
          </xsl:when>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^still.?image$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">StillImage</xsl:element>
          </xsl:when>
          <xsl:when test="matches(lower-case(normalize-space(.)), '^text$')">
            <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">Text</xsl:element>
          </xsl:when>
        </xsl:choose>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="dc:rights" mode="delawaremem_maps">
    <xsl:for-each select="tokenize(., '&#xA;')">
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
