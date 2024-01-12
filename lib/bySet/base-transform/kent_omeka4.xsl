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
      <xsl:element name="edm:dataProvider" namespace="http://www.europeana.eu/schemas/edm/">Kent State University</xsl:element>     <!-- create edm:dataProvider -->
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Kent State Shootings: Digital Archive</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP fields -->
      <xsl:apply-templates select="dc:identifier"            mode="kent_omeka4"/>             <!-- create edm:isShownAt, edm:preview, and dcterms:identifier  -->
      <xsl:apply-templates select="dc:rights"                mode="kent_omeka4"/>             <!-- create edm:rights    and dc:rights                         -->
      <xsl:apply-templates select="dc:title"                 mode="odn"/>                     <!-- create dcterms:title                                       -->
      <xsl:apply-templates select="dc:type"                  mode="odn"/>                     <!-- create dcterms:type                                        -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"              mode="odn"/>                     <!-- create dcterms:language                                    -->
      <xsl:apply-templates select="dc:creator"               mode="odn"/>                     <!-- create dcterms:creator                                     -->
      <xsl:apply-templates select="dc:contributor.author"    mode="kent_omeka4"/>             <!-- create dcterms:creator                                     -->
      <xsl:apply-templates select="dc:contributor.illustrator"    mode="kent_omeka4"/>             <!-- create dcterms:creator                                     -->
      <xsl:apply-templates select="dc:date"                  mode="kent_omeka4"/>             <!-- create dc:date                                             -->
      <xsl:apply-templates select="dc:format"                mode="odn"/>                     <!-- create dc:format                                           -->
      <xsl:apply-templates select="dc:coverage.spatial"      mode="kent_omeka4"/>             <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dcterms:spatial"          mode="kent_omeka4"/>             <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dc:subject"               mode="odn"/>                     <!-- create dcterms:subject                                     -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative"      mode="odn"/>                     <!-- create dcterms:alternative                                 -->
      <xsl:apply-templates select="dc:contributor"           mode="odn"/>                     <!-- create dcterms:contributor                                 -->
      <xsl:apply-templates select="dc:description"           mode="kent_omeka4"/>             <!-- create dcterms:description                                 -->
      <xsl:apply-templates select="dcterms:extent"           mode="kent_omeka4"/>             <!-- create dcterms:extent                                      -->
      <xsl:apply-templates select="dc:duration"              mode="kent_omeka4"/>             <!-- create dcterms:extent                                      -->
      <xsl:apply-templates select="dc:extent"                mode="kent_omeka4"/>             <!-- create dcterms:extent                                      -->
                                                                                              <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:apply-templates select="dc:publisher"             mode="kent_omeka4"/>             <!-- create dcterms:publisher                                   -->
      <xsl:apply-templates select="dc:relation"              mode="odn"/>                     <!-- create dc:relation                                         -->
      <xsl:apply-templates select="dc:relation.ispartof"     mode="kent_omeka4"/>             <!-- create dc:relation                                         -->
      <xsl:apply-templates select="dc:repository"            mode="kent_omeka4"/>             <!-- create dc:relation                                         -->
                                                                                              <!-- dc:rights is created above as part of the edm:rights transform -->
      <xsl:copy-of         select="dcterms:rightsHolder"     copy-namespaces="no"/>           <!-- create dcterms:rightsHolder                                -->
      <xsl:apply-templates select="dcterms:temporal"         mode="odn"/>                     <!-- create dcterms:temporal                                    -->

      <xsl:apply-templates select="dc:rights.uri"            mode="kent_omeka4"/>             <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dc:isreferencedby"        mode="kent_omeka4"/>             <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dc:date.copyright"        mode="kent_omeka4"/>             <!-- unwanted; remove                                           -->



    </oai_qdc:qualifieddc>
  </xsl:template>

  <xsl:template match="dc:identifier" mode="kent_omeka4">
    <xsl:choose>
      <xsl:when test="contains(., 'files/thumbnails') and starts-with(., 'http')">
        <xsl:element name="edm:preview" namespace="http://www.europeana.eu/schemas/edm/">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="not(contains(., 'files/thumbnails')) and starts-with(., 'http')">
        <xsl:element name="edm:isShownAt" namespace="http://www.europeana.eu/schemas/edm/">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dc:rights.uri" mode="kent_omeka4"/>

  <xsl:template match="dc:isreferencedby" mode="kent_omeka4"/>

  <xsl:template match="dc:date.copyright" mode="kent_omeka4"/>

  <xsl:template match="dc:contributor.author" mode="kent_omeka4">
    <xsl:element name="dcterms:creator" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:contributor.illustrator" mode="kent_omeka4">
    <xsl:element name="dcterms:creator" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:coverage.spatial" mode="kent_omeka4"/>

  <xsl:template match="dcterms:spatial" mode="kent_omeka4"/>

  <xsl:template match="dc:duration" mode="kent_omeka4">
    <xsl:element name="dcterms:extent" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:extent" mode="kent_omeka4">
    <xsl:element name="dcterms:extent" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:relation.ispartof" mode="kent_omeka4"/>

  <xsl:template match="dc:repository" mode="kent_omeka4">
    <xsl:element name="dc:relation" namespace="http://purl.org/dc/elements/1.1/">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:description" mode="kent_omeka4">
    <xsl:element name="dcterms:description" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="normalize-space(replace(replace(., '&lt;/?(b.*?|p.*?|span.*?|strong.*?|i.*?|div.*?|p.*?|a.*?|em.*?|br.*?)&gt;', ''), '&amp;nbsp;', ''))"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:rights" mode="kent_omeka4">
    <xsl:choose>
      <xsl:when test="contains(lower-case(.), 'rightsstatements.org')">
        <xsl:element name="edm:rights">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dc:date" mode="kent_omeka4">
    <xsl:for-each select="tokenize(normalize-space(.), ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:publisher" mode="kent_omeka4">
    <xsl:for-each select="tokenize(normalize-space(.), ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:publisher" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
