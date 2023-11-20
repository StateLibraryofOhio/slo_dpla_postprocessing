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
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Ohio Winery Collection</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP FIELDS -->
      <xsl:apply-templates select="dc:identifier"            mode="kent_wine"/>               <!-- create edm:isShownAt, edm:preview, and dcterms:identifier  -->
      <xsl:apply-templates select="dc:rights"                mode="odn"/>                     <!-- create edm:rights    and dc:rights                         -->
      <xsl:apply-templates select="dc:title"                 mode="odn"/>                     <!-- create dcterms:title                                       -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"              mode="odn"/>                     <!-- create dcterms:language                                    -->
      <xsl:apply-templates select="dc:creator"               mode="odn"/>                     <!-- create dcterms:creator                                     -->
      <xsl:copy-of         select="dc:date"                  copy-namespaces="no"/>           <!-- create dc:date                                             -->
      <xsl:apply-templates select="dc:format"                mode="odn"/>                     <!-- create dc:format                                           -->
      <xsl:copy-of         select="dcterms:spatial"          copy-namespaces="no"/>           <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dc:subject"               mode="odn"/>                     <!-- create dcterms:subject                                     -->
      <xsl:apply-templates select="dc:type"                  mode="odn"/>                     <!-- create dcterms:type                                        -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative"      mode="odn"/>                     <!-- create dcterms:alternative                                 -->
      <xsl:apply-templates select="dc:contributor"           mode="odn"/>                     <!-- create dcterms:contributor                                 -->
      <xsl:apply-templates select="dc:description"           mode="kent_wine"/>               <!-- create dcterms:description                                 -->
      <xsl:apply-templates select="dcterms:extent"           mode="odn"/>                     <!-- create dcterms:extent                                      -->
                                                                                              <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:apply-templates select="dc:publisher"             mode="odn"/>                     <!-- create dcterms:publisher                                   -->
      <xsl:apply-templates select="dc:relation"              mode="odn"/>                     <!-- create dc:relation                                         -->
      <xsl:apply-templates select="dcterms:isPartOf"         mode="odn"/>                     <!-- create dc:relation                                         -->
                                                                                              <!-- dc:rights is created above as part of the edm:rights transform -->
      <xsl:copy-of         select="dcterms:rightsHolder"     copy-namespaces="no"/>           <!-- create dcterms:rightsHolder                                -->
      <xsl:apply-templates select="dcterms:temporal"         mode="odn"/>                     <!-- create dcterms:temporal                                    -->

      <xsl:apply-templates select="dc:source"                mode="kent_wine"/>               <!-- don't know what to do with this.  Penelope???              -->

    </oai_qdc:qualifieddc>
  </xsl:template>


  <xsl:template match="dc:source" mode="kent_wine">
    <xsl:element name="dc:relation" namespace="http://purl.org/dc/elements/1.1/">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:identifier" mode="kent_wine">
    <xsl:choose>
      <xsl:when test="starts-with(., 'https://oaks')">
        <xsl:element name="edm:isShownAt" namespace="http://www.europeana.eu/schemas/edm/">
           <xsl:value-of select="."/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="dc:description" mode="kent_wine">
    <xsl:choose>
      <xsl:when test="ends-with(., 'thumbnail.jpg')">
        <xsl:element name="edm:preview" namespace="http://www.europeana.eu/schemas/edm/">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="not(normalize-space(.)='')">
          <xsl:element name="dcterms:description" namespace="http://purl.org/dc/terms/">
            <xsl:value-of select="normalize-space(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(., '&lt;a href=&quot;https://digitalcommons.kent.edu/wineryne/9/&quot; &gt;', ''), '&lt;a href=&quot;http://www.barnquiltsashtabulacounty.com/gallery/no-41-old-firehouse-winery/&quot; &gt;', ''), '&lt;p id=&quot;x-x-x-docs-internal-guid-2dc01c7a-74eb-bbea-3714-9d4caaf6e37c&quot;&gt;', ''), '&lt;a href=&quot;https://digitalcommons.kent.edu/wineryneinland/16/&quot; &gt;', ''), '&lt;a href=&quot;http://digitalcommons.kent.edu/winehalloffame/16/&quot; &gt;', ''), '&lt;a href=&quot;http://ohiowines.org/12_hall_of_fame.shtml&quot; &gt;', ''), '&lt;/*sup&gt;', ''), '&lt;a href=&quot;http://digitalcommons.kent.edu/markko_documents/12/&quot; &gt;', ''), '&lt;a href=&quot;http://digitalcommons.kent.edu/winehalloffame/8/&quot; &gt;', ''), '&lt;a href=&quot;http://digitalcommons.kent.edu/wineryne/9/&quot; &gt;', ''), '&lt;a href=&quot;http://digitalcommons.kent.edu/winehalloffame/13/&quot; &gt;', ''), '&lt;a href=&quot;http://www.americanwinesociety.org/page/aboutus&quot; &gt;', ''), '&lt;a href=&quot;http://digitalcommons.kent.edu/wineryne/19/&quot; target=&quot;_blank&quot; title=&quot;Old Firehouse Winery, 1991&quot; &gt;', ''), '&lt;a href=&quot;http://journals.ametsoc.org/doi/pdf/10.1175/1520-0442\(1993\)006', ''), '&lt;br&gt;', ''), '&lt;/*strong&gt;', ''), '&lt;a href=&quot;http://digitalcommons.kent.edu/debonne_images/13/&quot; &gt;', ''), '&lt;a href=&quot;http://digitalcommons.kent.edu/debonne_images/23/&quot; &gt;', ''), '&lt;/a&gt;', ''), '&lt;/*em&gt;', ''), '&lt;/*p&gt;', '')) "/>
          </xsl:element>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



</xsl:stylesheet>
