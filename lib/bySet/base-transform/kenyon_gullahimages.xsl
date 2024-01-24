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
      <xsl:element name="edm:dataProvider" namespace="http://www.europeana.eu/schemas/edm/">Kenyon College</xsl:element>     <!-- create edm:dataProvider -->
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Kenyon Gullah Digital Image Archives</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP fields -->
      <xsl:apply-templates select="dc:identifier"       mode="kenyon_gullahimages"/>     <!-- create edm:isShownAt, edm:preview, and dcterms:identifier -->
      <xsl:apply-templates select="dc:rights"           mode="odn"/>                     <!-- create edm:rights    and dc:rights   -->
      <xsl:apply-templates select="dc:title"            mode="odn"/>                     <!-- create dcterms:title -->
      <xsl:apply-templates select="dc:type"             mode="odn"/>                     <!-- create dcterms:type  -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"         mode="odn"/>                         <!-- create dcterms:language                   -->
      <xsl:apply-templates select="dc:creator"          mode="odn"/>                         <!-- create dcterms:creator                    -->
      <xsl:copy-of         select="dc:date"             copy-namespaces="no"/>               <!-- create dc:date                            -->
      <xsl:apply-templates select="dc:format"           mode="odn"/>                         <!-- create dc:format                          -->
      <xsl:copy-of         select="dcterms:spatial"     copy-namespaces="no"/>               <!-- create dcterms:spatial                    -->
      <xsl:apply-templates select="dc:coverage.spatial.lat"  mode="kenyon_gullahimages"/>    <!-- create dcterms:spatial                    -->
      <xsl:apply-templates select="dc:subject"          mode="odn"/>                         <!-- create dcterms:subject                    -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative" mode="odn"/>                         <!-- create dcterms:alternative                                                 -->
      <xsl:apply-templates select="dc:contributor"      mode="odn"/>                         <!-- create dcterms:contributor                                                 -->
      <xsl:apply-templates select="dc:description"      mode="kenyon_gullahimages"/>         <!-- create dcterms:description                                                 -->
      <xsl:apply-templates select="dc:description.abstract"  mode="kenyon_gullahimages"/>    <!-- create edm:preview                                                         -->
      <xsl:apply-templates select="dcterms:extent"      mode="odn"/>                         <!-- create dcterms:extent                                                      -->
                                                                                             <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:apply-templates select="dc:publisher"        mode="odn"/>                         <!-- create dcterms:publisher                                                   -->
      <xsl:apply-templates select="dc:relation"         mode="odn"/>                         <!-- create dc:relation                                                         -->
                                                                                             <!-- dc:rights is created above as part of the edm:rights transform             -->
      <xsl:copy-of         select="dcterms:rightsHolder" copy-namespaces="no"/>              <!-- create dcterms:rightsHolder                                                -->
      <xsl:apply-templates select="dcterms:temporal" mode="odn"/>                            <!-- create dcterms:temporal                                                    -->

    </oai_qdc:qualifieddc>
  </xsl:template>
	


  <!-- contains unwanted data; don't include it in the DPLA feed. -->

  <xsl:template match="dc:description.abstract" mode="kenyon_gullahimages"/>	


  <!-- Combine the latitude & longitude values into a single field.  -->

  <xsl:template match="dc:coverage.spatial.lat" mode="kenyon_gullahimages">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:spatial">
      <xsl:value-of select="normalize-space(concat(., ', ', ../dc:coverage.spatial.long))"/>
    </xsl:element>
  </xsl:template>


  <!-- Date in this case is extended format; only grab that portion before "T" -->

  <xsl:template match="dc:date.created" mode="kenyon_gullahimages">
    <xsl:element namespace="http://purl.org/dc/elements/1.1/" name="dc:date">
      <xsl:value-of select="substring-before(normalize-space(.),'T')"/>
    </xsl:element>
  </xsl:template>


  <!-- Get the URL for the thumbnails -->

  <xsl:template match="dc:description" mode="kenyon_gullahimages">
    <xsl:element name="edm:preview" namespace="http://www.europeana.eu/schemas/edm/">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>


  <!-- use the dc:identifier to populate edm:isShownAt -->

  <xsl:template match="dc:identifier" mode="kenyon_gullahimages">
    <xsl:choose>
      <xsl:when test="starts-with(., 'http') and not(contains(., 'viewcontent'))">
        <xsl:element name="edm:isShownAt" namespace="http://www.europeana.eu/schemas/edm/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="dcterms:identifier" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
