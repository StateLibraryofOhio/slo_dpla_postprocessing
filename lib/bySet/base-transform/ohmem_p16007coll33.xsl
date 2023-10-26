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
      <xsl:element name="edm:dataProvider" namespace="http://www.europeana.eu/schemas/edm/">Toledo Lucas County Public Library</xsl:element>     <!-- create edm:dataProvider -->
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Toledo Lucas County Public Library</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP FIELDS -->
      <xsl:apply-templates select="dc:identifier"            mode="ohmem_p16007coll33"/>      <!-- create edm:isShownAt, edm:preview, and dcterms:identifier  -->
      <xsl:apply-templates select="dc:rights"                mode="odn"/>                     <!-- create edm:rights    and dc:rights                         -->
      <xsl:apply-templates select="dc:title"                 mode="odn"/>                     <!-- create dcterms:title                                       -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"              mode="ohmem_p16007coll33"/>      <!-- create dcterms:language                                    -->
      <xsl:apply-templates select="dc:creator"               mode="ohmem_p16007coll33"/>      <!-- create dcterms:creator                                     -->
      <xsl:apply-templates select="dc:date"                  mode="ohmem_p16007coll33"/>      <!-- create dc:date                                             -->
      <xsl:apply-templates select="dc:format"                mode="odn"/>                     <!-- create dc:format                                           -->
      <xsl:apply-templates select="dcterms:spatial"          mode="ohmem_p16007coll33"/>      <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dc:subject"               mode="odn"/>                     <!-- create dcterms:subject                                     -->
      <xsl:apply-templates select="dc:type"                  mode="odn"/>                     <!-- create dcterms:type                                        -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative"      mode="odn"/>                     <!-- create dcterms:alternative                                 -->
      <xsl:apply-templates select="dc:contributor"           mode="ohmem_p16007coll33"/>      <!-- create dcterms:contributor                                 -->
      <xsl:apply-templates select="dc:description"           mode="odn"/>                     <!-- create dcterms:description                                 -->
      <xsl:apply-templates select="dcterms:extent"           mode="odn"/>                     <!-- create dcterms:extent                                      -->
                                                                                              <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:apply-templates select="dc:publisher"             mode="ohmem_p16007coll33"/>      <!-- create dcterms:publisher                                   -->
      <xsl:apply-templates select="dc:relation"              mode="odn"/>                     <!-- create dc:relation                                         -->
      <xsl:apply-templates select="dcterms:isPartOf"         mode="odn"/>                     <!-- create dc:relation                                         -->
                                                                                              <!-- dc:rights is created above as part of the edm:rights transform -->
      <xsl:copy-of         select="dcterms:rightsHolder"     copy-namespaces="no"/>           <!-- create dcterms:rightsHolder                                -->
      <xsl:apply-templates select="dcterms:temporal"         mode="odn"/>                     <!-- create dcterms:temporal                                    -->

      <xsl:apply-templates select="dc:source"                mode="ohmem_p16007coll33"/>      <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:abstract"         mode="ohmem_p16007coll33"/>      <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:isPartOf"         mode="ohmem_p16007coll33"/>      <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dc:coverage"              mode="ohmem_p16007coll33"/>      <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:valid"            mode="ohmem_p16007coll33"/>      <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:created"          mode="ohmem_p16007coll33"/>      <!-- unwanted; remove                                           -->

    </oai_qdc:qualifieddc>
  </xsl:template>

  <xsl:template match="dc:source" mode="ohmem_p16007coll33"/>

  <xsl:template match="dcterms:abstract" mode="ohmem_p16007coll33"/>

  <xsl:template match="dcterms:isPartOf" mode="ohmem_p16007coll33"/>

  <xsl:template match="dc:coverage" mode="ohmem_p16007coll33"/>

  <xsl:template match="dcterms:valid" mode="ohmem_p16007coll33"/>

  <xsl:template match="dcterms:created" mode="ohmem_p16007coll33"/>

  <xsl:template match="dc:publisher"  mode="ohmem_p16007coll33">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:publisher" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:creator"  mode="ohmem_p16007coll33">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:creator" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="dc:contributor" mode="ohmem_p16007coll33">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:element name="dcterms:contributor" namespace="http://purl.org/dc/terms/">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:language" mode="ohmem_p16007coll33">
    <xsl:for-each select="tokenize(replace(., '\.',''), ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:language" namespace="http://purl.org/dc/terms/">
          <xsl:choose>
            <xsl:when test="matches(normalize-space(.), 'eng')">
              <xsl:value-of select="replace(normalize-space(.), 'eng', 'English')"/>
            </xsl:when>
            <xsl:when test="matches(normalize-space(.), 'pol')">
              <xsl:value-of select="replace(normalize-space(.), 'pol', 'Polish')"/>
            </xsl:when>
            <xsl:when test="matches(normalize-space(.), 'hun')">
              <xsl:value-of select="replace(normalize-space(.), 'hun', 'Hungarian')"/>
            </xsl:when>
            <xsl:when test="matches(normalize-space(.), 'ger')">
              <xsl:value-of select="replace(normalize-space(.), 'ger', 'German')"/>
            </xsl:when>
            <xsl:when test="matches(normalize-space(.), 'arc')">
              <xsl:value-of select="replace(normalize-space(.), 'arc', 'Aramaic')"/>
            </xsl:when>
          </xsl:choose>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- use the URL dc:identifier to both populate edm:isShownAt and use known CONTENTdm thumbnail path to construct thumbnail URL for edm:preview -->
  <xsl:template match="dc:identifier" mode="ohmem_p16007coll33">
    <xsl:choose>
      <xsl:when test="starts-with(., 'http://www.ohiomemory.org')">
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

  <xsl:template match="dcterms:spatial" mode="ohmem_p16007coll33">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:spatial" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:date" mode="ohmem_p16007coll33">
    <xsl:for-each select="tokenize(replace(., ',', ';'), ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
