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
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Galena</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP FIELDS -->
      <xsl:apply-templates select="dc:identifier"            mode="delawaremem_galena"/>   <!-- create edm:isShownAt, edm:preview, and dcterms:identifier  -->
      <xsl:apply-templates select="dc:rights"                mode="delawaremem_galena"/>   <!-- create edm:rights    and dc:rights                         -->
      <xsl:apply-templates select="dc:title"                 mode="odn"/>                     <!-- create dcterms:title                                       -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"              mode="odn"/>                     <!-- create dcterms:language                                    -->
      <xsl:apply-templates select="dc:creator"               mode="delawaremem_galena"/>      <!-- create dcterms:creator                                     -->
      <xsl:apply-templates select="dc:date"                  mode="delawaremem_galena"/>      <!-- create dc:date                                             -->
      <xsl:apply-templates select="dc:format"                mode="odn"/>                     <!-- create dc:format                                           -->
      <xsl:copy-of         select="dcterms:spatial"          copy-namespaces="no"/>           <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dc:subject"               mode="delawaremem_galena"/>   <!-- create dcterms:subject                                     -->
      <xsl:apply-templates select="dc:type"                  mode="delawaremem_galena"/>   <!-- create dcterms:type                                        -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative"      mode="odn"/>                     <!-- create dcterms:alternative                                 -->
      <xsl:apply-templates select="dc:contributor"           mode="delawaremem_galena"/>      <!-- create dcterms:contributor                                 -->
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


  <xsl:template match="dc:date" mode="delawaremem_galena">
    <xsl:for-each select="tokenize(., '&#xA;')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:subject" mode="delawaremem_galena">
    <xsl:for-each select="tokenize(., '&#xA;')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:subject" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:creator" mode="delawaremem_galena">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:creator" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:contributor" mode="delawaremem_galena">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:contributor" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:identifier" mode="delawaremem_galena">
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


  <xsl:template match="dc:type" mode="delawaremem_galena">
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


  <xsl:template match="dc:rights" mode="delawaremem_galena">
    <xsl:for-each select="tokenize(., '&#xA;')">
        <xsl:if test="(normalize-space(.) != '') and (starts-with(normalize-space(replace(., 'URI: ', '')), 'http://') and ends-with(normalize-space(.), '/'))" >
            <xsl:choose>
              <xsl:when test="starts-with(normalize-space(replace(., 'URI: ', '')), 'http://rightsstatements.org/')">
                            <xsl:if test="index-of($rightsStatementsOrgList, normalize-space(replace(., 'URI: ', '')))">
                                <xsl:element name="edm:rights" namespace="http://www.europeana.eu/schemas/edm/">
                                    <xsl:value-of select="normalize-space(replace(., 'URI: ', ''))"/>
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
