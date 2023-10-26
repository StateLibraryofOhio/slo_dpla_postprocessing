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
      <xsl:element name="edm:dataProvider" namespace="http://www.europeana.eu/schemas/edm/">State Library of Ohio</xsl:element>     <!-- create edm:dataProvider -->
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">State Library of Ohio Historical Documents</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP fields -->
      <xsl:apply-templates select="dc:identifier"            mode="ohmem_p15005coll2"/>       <!-- create edm:isShownAt, edm:preview, and dcterms:identifier  -->
      <xsl:apply-templates select="dc:rights"                mode="odn"/>                     <!-- create edm:rights    and dc:rights                         -->
      <xsl:apply-templates select="dc:title"                 mode="odn"/>                     <!-- create dcterms:title                                       -->
      <xsl:apply-templates select="dc:type"                  mode="odn"/>                     <!-- create dcterms:type                                        -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"              mode="odn"/>                     <!-- create dcterms:language                                    -->
      <xsl:apply-templates select="dc:creator"               mode="odn"/>                     <!-- create dcterms:creator                                     -->
      <xsl:copy-of         select="dc:date"                  copy-namespaces="no"/>           <!-- create dc:date                                             -->
      <xsl:apply-templates select="dc:format"                mode="odn"/>                     <!-- create dc:format                                           -->
      <xsl:apply-templates select="dcterms:spatial"          mode="ohmem_p15005coll2"/>       <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dc:subject"               mode="odn"/>                     <!-- create dcterms:subject                                     -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative"      mode="odn"/>                     <!-- create dcterms:alternative                                 -->
      <xsl:apply-templates select="dc:contributor"           mode="ohmem_p15005coll2"/>       <!-- create dcterms:contributor                                 -->
      <xsl:apply-templates select="dc:description"           mode="odn"/>                     <!-- create dcterms:description                                 -->
      <xsl:apply-templates select="dcterms:extent"           mode="ohmem_p15005coll2"/>       <!-- create dcterms:extent                                      -->
                                                                                              <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:apply-templates select="dc:publisher"             mode="ohmem_p15005coll2"/>       <!-- create dcterms:publisher                                   -->
      <xsl:apply-templates select="dc:relation"              mode="ohmem_p15005coll2"/>       <!-- create dc:relation                                         -->
                                                                                              <!-- dc:rights is created above as part of the edm:rights transform -->
      <xsl:copy-of         select="dcterms:rightsHolder"     copy-namespaces="no"/>           <!-- create dcterms:rightsHolder                                -->
      <xsl:apply-templates select="dcterms:temporal"         mode="ohmem_p15005coll2"/>       <!-- create dcterms:temporal                                    -->

      <xsl:apply-templates select="dcterms:abstract"         mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:alternative"      mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:created"          mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:isPartOf"         mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:isReferencedBy"   mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:isReplacedBy"     mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:issued"           mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:mediator"         mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:medium"           mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:replaces"         mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:requires"         mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->
      <xsl:apply-templates select="dcterms:tableOfContents"  mode="ohmem_p15005coll2"/>       <!-- unwanted; remove                                           -->

    </oai_qdc:qualifieddc>
  </xsl:template>

  <xsl:template match="dcterms:spatial" mode="ohmem_p15005coll2">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:spatial" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dcterms:extent" mode="ohmem_p15005coll2">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:extent" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dcterms:temporal" mode="ohmem_p15005coll2">
    <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:publisher" mode="ohmem_p15005coll2">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:choose>
          <xsl:when test="contains(., 'For sale by the Clearinghouse for Federal Scientific and Technical Information, Springfield, Virginia')">
            <xsl:element name="dcterms:publisher" namespace="http://purl.org/dc/terms/">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="dcterms:publisher" namespace="http://purl.org/dc/terms/">
              <xsl:value-of select="normalize-space(replace(replace(replace(replace(., '\[distributor\]', ''), '\[etc.\]', ''), '\[', ''), '\]', ''))"/>
            </xsl:element>   
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dcterms:tableOfContents" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:requires" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:replaces" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:medium" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:mediator" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:issued" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:isReplacedBy" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:isReferencedBy" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:isPartOf" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:created" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:alternative" mode="ohmem_p15005coll2"/>

  <xsl:template match="dcterms:abstract" mode="ohmem_p15005coll2"/>

  <xsl:template match="dc:relation" mode="ohmem_p15005coll2"/>


  <!-- use the URL dc:identifier to both populate edm:isShownAt and use known CONTENTdm thumbnail path to construct thumbnail URL for edm:preview -->
  <xsl:template match="dc:identifier" mode="ohmem_p15005coll2">
    <xsl:choose>
      <xsl:when test="starts-with(., 'http://') and contains(., 'ohiomemory.org')">
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

  <xsl:template match="dc:contributor" mode="ohmem_p15005coll2">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:contributor">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
