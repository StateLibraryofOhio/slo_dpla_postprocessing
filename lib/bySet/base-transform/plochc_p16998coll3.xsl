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
      <xsl:element name="edm:dataProvider" namespace="http://www.europeana.eu/schemas/edm/">Cincinnati and Hamilton County Public Library</xsl:element>     <!-- create edm:dataProvider -->
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Cincinnati and Hamilton County Public Library Yearbook Collection</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP fields -->
      <xsl:apply-templates select="dc:identifier"            mode="plochc_p16998coll3"/>      <!-- create edm:isShownAt, edm:preview, and dcterms:identifier -->
      <xsl:apply-templates select="dc:rights"                mode="odn"/>                     <!-- create edm:rights    and dc:rights   -->
      <xsl:apply-templates select="dc:title"                 mode="odn"/>                     <!-- create dcterms:title -->
      <xsl:apply-templates select="dc:type"                  mode="odn"/>                     <!-- create dcterms:type  -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"              mode="odn"/>                     <!-- create dcterms:language                   -->
      <xsl:apply-templates select="dc:creator"               mode="plochc_p16998coll3"/>      <!-- create dcterms:creator                    -->
      <xsl:apply-templates select="dc:date"                  mode="plochc_p16998coll3"/>      <!-- create dc:date                            -->
      <xsl:apply-templates select="dc:format"                mode="plochc_p16998coll3"/>      <!-- unwanted; remove                          -->
      <xsl:apply-templates select="dcterms:medium"           mode="plochc_p16998coll3"/>      <!-- create dc:format                          -->
      <xsl:apply-templates select="dcterms:spatial"          mode="plochc_p16998coll3"/>      <!-- create dcterms:spatial                    -->
      <xsl:apply-templates select="dc:subject"               mode="odn"/>                     <!-- create dcterms:subject                    -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative"      mode="plochc_p16998coll3"/>      <!-- create dcterms:alternative                -->
      <xsl:apply-templates select="dc:contributor"           mode="plochc_p16998coll3"/>      <!-- create dcterms:contributor                -->
      <xsl:apply-templates select="dc:description"           mode="odn"/>                     <!-- create dcterms:description                -->
      <xsl:apply-templates select="dcterms:extent"           mode="plochc_p16998coll3"/>      <!-- create dcterms:extent                     -->
                                                                                              <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:apply-templates select="dc:publisher"             mode="plochc_p16998coll3"/>      <!-- create dcterms:publisher                  -->
      <xsl:apply-templates select="dc:relation"              mode="plochc_p16998coll3"/>      <!-- create dc:relation                        -->
                                                                                              <!-- dc:rights is created above as part of the edm:rights transform -->
      <xsl:apply-templates select="dcterms:rightsHolder"     mode="plochc_p16998coll3"/>      <!-- create dcterms:rightsHolder               -->
      <xsl:apply-templates select="dcterms:temporal"         mode="odn"/>                     <!-- create dcterms:temporal                   -->

      <xsl:apply-templates select="dc:source"                mode="plochc_p16998coll3"/>      <!-- unwanted; remove                          -->
      <xsl:apply-templates select="dcterms:created"          mode="plochc_p16998coll3"/>      <!-- unwanted; remove                          -->
      <xsl:apply-templates select="dcterms:license"          mode="plochc_p16998coll3"/>      <!-- unwanted; remove                          -->
      <xsl:apply-templates select="dcterms:tableOfContents"  mode="plochc_p16998coll3"/>      <!-- unwanted; remove                          -->
      <xsl:apply-templates select="dcterms:replaces"         mode="plochc_p16998coll3"/>      <!-- unwanted; remove                          -->
      <xsl:apply-templates select="dcterms:isReplacedBy"     mode="plochc_p16998coll3"/>      <!-- unwanted; remove                          -->

    </oai_qdc:qualifieddc>
  </xsl:template>

  <xsl:template match="dc:format" mode="plochc_p16998coll3"/>

  <xsl:template match="dcterms:replaces" mode="plochc_p16998coll3"/>

  <xsl:template match="dcterms:isReplacedBy" mode="plochc_p16998coll3"/>

  <xsl:template match="dc:publisher" mode="plochc_p16998coll3"/>

  <xsl:template match="dc:source" mode="plochc_p16998coll3"/>

  <xsl:template match="dcterms:alternative" mode="plochc_p16998coll3"/>

  <xsl:template match="dcterms:created" mode="plochc_p16998coll3"/>

  <xsl:template match="dcterms:extent" mode="plochc_p16998coll3"/>

  <xsl:template match="dcterms:license" mode="plochc_p16998coll3"/>

  <xsl:template match="dcterms:rightsHolder" mode="plochc_p16998coll3"/>

  <xsl:template match="dcterms:tableOfContents" mode="plochc_p16998coll3"/>

  <xsl:template match="dc:creator" mode="plochc_p16998coll3">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:creator" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:contributor" mode="plochc_p16998coll3">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:contributor" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dcterms:spatial" mode="plochc_p16998coll3">
    <xsl:if test="matches(normalize-space(.), '[-]?[0-9]*.[0-9]+, [-]?[0-9]*.[0-9]+')">
      <xsl:element name="dcterms:spatial" namespace="http://purl.org/dc/terms/">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dcterms:medium" mode="plochc_p16998coll3">
    <xsl:for-each select="tokenize(normalize-space(.), ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dc:format" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- use the URL dc:identifier to both populate edm:isShownAt and use known CONTENTdm thumbnail path to construct thumbnail URL for edm:preview -->
  <xsl:template match="dc:identifier" mode="plochc_p16998coll3">
    <xsl:choose>
      <xsl:when test="starts-with(., 'http://')">
        <xsl:element name="edm:isShownAt" namespace="http://www.europeana.eu/schemas/edm/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        <xsl:element name="edm:preview" namespace="http://www.europeana.eu/schemas/edm/">
          <xsl:variable name="cdm_root" select="substring-before(., '/cdm/ref/')"/>
          <xsl:variable name="record_info" select="substring-after(., '/collection/')"/>
          <xsl:variable name="alias" select="substring-before($record_info, '/id/')"/>
          <xsl:variable name="pointer" select="substring-after($record_info, '/id/')"/>
          <xsl:value-of select="concat($cdm_root, '/utils/getthumbnail/collection/', $alias, '/id/', $pointer)"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dc:relation" mode="plochc_p16998coll3">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dc:relation" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:date" mode="plochc_p16998coll3">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
