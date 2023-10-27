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
      <xsl:element name="edm:dataProvider" namespace="http://www.europeana.eu/schemas/edm/">State Library of Ohio</xsl:element>     <!-- create edm:dataProvider -->
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Cincinnati Federal Land Office Records</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP fields -->
      <xsl:apply-templates select="dc:identifier"       mode="odn"/>                               <!-- create edm:isShownAt and dcterms:identifier -->
      <xsl:apply-templates select="dc:rights"           mode="p15005coll36"/>                      <!-- create edm:rights    and dc:rights   -->
      <xsl:apply-templates select="dc:title"            mode="odn"/>                               <!-- create dcterms:title -->
      <xsl:apply-templates select="dc:type"             mode="p15005coll36"/>                      <!-- create dcterms:type  -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"         mode="odn"/>                               <!-- create dcterms:language                 -->
      <xsl:apply-templates select="dc:creator"          mode="odn"/>                               <!-- create dcterms:creator                  -->
      <xsl:copy-of         select="dc:date"             copy-namespaces="no"/>                     <!-- create dc:date                          -->
      <xsl:apply-templates select="dc:format"           mode="p15005coll36"/>                      <!-- create dc:format                        -->
      <xsl:copy-of         select="dcterms:spatial"     copy-namespaces="no"/>                     <!-- create dcterms:spatial                  -->
      <xsl:apply-templates select="dc:subject"          mode="odn"/>                               <!-- create dcterms:subject                  -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative" mode="odn"/>                               <!-- create dcterms:alternative  -->
      <xsl:apply-templates select="dc:contributor"      mode="p15005coll36"/>                      <!-- create dcterms:contributor  -->
      <xsl:apply-templates select="dc:description"      mode="odn"/>                               <!-- create dcterms:description  -->
      <xsl:apply-templates select="dcterms:extent"      mode="p15005coll36"/>                      <!-- create dcterms:extent       -->
                                                                                                   <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:apply-templates select="dc:publisher"        mode="p15005coll36"/>                      <!-- create dcterms:publisher    -->
      <xsl:apply-templates select="dc:relation"         mode="odn"/>                               <!-- create dc:relation          -->
                                                                                                   <!-- dc:rights is created above as part of the edm:rights transform -->
      <xsl:copy-of         select="dcterms:rightsHolder" copy-namespaces="no"/>                    <!-- create dcterms:rightsHolder -->
      <xsl:apply-templates select="dcterms:temporal" mode="odn"/>                                  <!-- create dcterms:temporal     -->

    </oai_qdc:qualifieddc>
  </xsl:template>

  <xsl:template match="dc:contributor" mode="p15005coll36">
    <xsl:element name="dcterms:contributor" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:publisher" mode="p15005coll36">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:publisher">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="dc:format" mode="p15005coll36">
    <xsl:element name="dc:format" namespace="http://purl.org/dc/elements/1.1/">
        <xsl:value-of select="normalize-space(substring-before(., '; '))"/>
    </xsl:element>
    <xsl:element name="dc:format" namespace="http://purl.org/dc/elements/1.1/">
        <xsl:value-of select="lower-case(substring-after(., '; '))"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:type" mode="p15005coll36">
    <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dcterms:extent" mode="p15005coll36">
    <xsl:element name="dcterms:extent" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="dc:rights" mode="p15005coll36">
    <xsl:choose>
      <xsl:when test="contains(lower-case(.), 'rightsstatements.org')">
        <xsl:choose>
          <xsl:when test="contains(., '|')">
            <xsl:element name="edm:rights">
              <xsl:value-of select="normalize-space(substring-before(., ' |'))"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="edm:rights">
              <xsl:value-of select="replace(normalize-space(.), 'http://rightsstatements.org/page/NoC-US/1.0/\?language=en', 'http://rightsstatements.org/vocab/NoC-US/1.0/')"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="contains(lower-case(normalize-space(.)), 'in copyright')"/>
          <xsl:when test="contains(lower-case(normalize-space(.)), 'no copyright')"/>
          <xsl:when test="contains(lower-case(normalize-space(.)), 'no known copyright')"/>
          <xsl:when test="contains(lower-case(normalize-space(.)), 'copyright undetermined')"/>
          <xsl:when test="contains(lower-case(normalize-space(.)), 'copyright not evaluated')"/>
          <xsl:otherwise>
            <xsl:element namespace="http://purl.org/dc/elements/1.1/" name="dc:rights">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


 
</xsl:stylesheet>
