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
      <xsl:element name="edm:dataProvider" namespace="http://www.europeana.eu/schemas/edm/">The University of Toledo</xsl:element>     <!-- create edm:dataProvider -->
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Exhibition Catalogs, 1980-Present</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP FIELDS -->
      <xsl:apply-templates select="dc:identifier"            mode="utoledo_exhibitcat"/>      <!-- create edm:isShownAt, edm:preview, and dcterms:identifier  -->
      <xsl:apply-templates select="dc:rights"                mode="odn"/>                     <!-- create edm:rights    and dc:rights                         -->
      <xsl:apply-templates select="dc:title"                 mode="odn"/>                     <!-- create dcterms:title                                       -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"              mode="odn"/>                     <!-- create dcterms:language                                    -->
      <xsl:apply-templates select="dc:creator"               mode="odn"/>                     <!-- create dcterms:creator                                     -->
      <xsl:apply-templates select="dc:date"                  mode="utoledo_exhibitcat"/>      <!-- create dc:date                                             -->
      <xsl:apply-templates select="dc:format"                mode="utoledo_exhibitcat"/>      <!-- unwanted; remove                                           -->
      <xsl:copy-of         select="dcterms:spatial"          copy-namespaces="no"/>           <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dc:subject"               mode="odn"/>                     <!-- create dcterms:subject                                     -->
      <xsl:apply-templates select="dc:type"                  mode="odn"/>                     <!-- create dcterms:type                                        -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative"      mode="odn"/>                     <!-- create dcterms:alternative                                 -->
      <xsl:apply-templates select="dc:contributor"           mode="odn"/>                     <!-- create dcterms:contributor                                 -->
      <xsl:apply-templates select="dc:description"           mode="utoledo_exhibitcat"/>      <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:extent"           mode="odn"/>                     <!-- create dcterms:extent                                      -->
                                                                                              <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:apply-templates select="dc:publisher"             mode="odn"/>                     <!-- create dcterms:publisher                                   -->
      <xsl:apply-templates select="dc:relation"              mode="utoledo_exhibitcat"/>      <!-- create dc:relation                                         -->
      <xsl:apply-templates select="dcterms:isPartOf"         mode="odn"/>                     <!-- create dc:relation                                         -->
                                                                                              <!-- dc:rights is created above as part of the edm:rights transform -->
      <xsl:copy-of         select="dcterms:rightsHolder"     copy-namespaces="no"/>           <!-- create dcterms:rightsHolder                                -->
      <xsl:apply-templates select="dcterms:temporal"         mode="odn"/>                     <!-- create dcterms:temporal                                    -->

      <xsl:apply-templates select="dc:coverage"              mode="utoledo_exhibitcat"/>      <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dc:identifier.thumbnail"  mode="utoledo_exhibitcat"/>      <!-- create edm:preview                                         -->
 
    </oai_qdc:qualifieddc>
  </xsl:template>

  <xsl:template match="dc:format" mode="utoledo_exhibitcat"/>

  <xsl:template match="dc:description" mode="utoledo_exhibitcat"/>

  <xsl:template match="dc:identifier" mode="utoledo_exhibitcat"/>

  <xsl:template match="dc:relation" mode="utoledo_exhibitcat">
    <xsl:if test="normalize-space(.) != ''">
      <xsl:element name="dc:relation" namespace="http://purl.org/dc/elements/1.1/">
        <xsl:value-of select="." />
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dc:coverage" mode="utoledo_exhibitcat">
    <xsl:if test="normalize-space(.) != ''">
      <xsl:element name="dcterms:spatial" namespace="http://purl.org/dc/terms/">
        <xsl:value-of select="." />
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dc:date" mode="utoledo_exhibitcat">
    <xsl:if test="normalize-space(.) != ''">
      <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/">
        <xsl:value-of select="." />
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dc:identifier.thumbnail" mode="utoledo_exhibitcat">
    <xsl:element name="edm:preview" namespace="http://www.europeana.eu/schemas/edm/">
      <xsl:value-of select="." />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
