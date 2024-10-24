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
  
  <!-- This is the template that SLO is using to create a new, collection-specific transform for REPOX for each collection. -->

  <!-- Each collection-specific XSLT file should be added to REPOX as a new "Transform"  -->

  <!-- Naming convention for the updated XSLT file is:         SITE_COLLECTION.xsl       -->
  <!-- where                                                                             -->
  <!--    "SITE"       == the contributing organization, and                             -->
  <!--    "COLLECTION" == a unique ID for this dataset (typically the OAI-PMH setSpec)   -->

  <!-- AT A MINIMUM, change the "THIS_PROVIDER_NAME" and "THIS_COLLECTION_NAME" values in the "STATIC VALUES" section! -->


  <!-- pull in our common template file -->
  <xsl:include href="odn_templates.xsl"/>

  
  <!-- The following match="xxxx" statement will work with CONTENTdm-based collections, but likely will need to be adjusted for other systems -->
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
      <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/">Cincinnati Enquirer Photo Archive</xsl:element>              <!-- create dcterms:isPartOf -->

      <!-- REQUIRED ODN-MAP FIELDS -->
      <xsl:apply-templates select="dc:identifier"            mode="odn"/>                     <!-- create edm:isShownAt, edm:preview, and dcterms:identifier  -->
      <xsl:apply-templates select="dc:rights"                mode="plochc_p16998coll65"/>     <!-- create edm:rights    and dc:rights                         -->
      <xsl:apply-templates select="dc:title"                 mode="odn"/>                     <!-- create dcterms:title                                       -->

      <!-- RECOMMENDED ODN-MAP fields -->
      <xsl:apply-templates select="dc:language"              mode="odn"/>                     <!-- create dcterms:language                                    -->
      <xsl:apply-templates select="dc:creator"               mode="plochc_p16998coll65"/>     <!-- create dcterms:creator                                     -->
      <xsl:apply-templates select="dc:date"                  mode="plochc_p16998coll65"/>     <!-- create dc:date                                             -->
      <xsl:apply-templates select="dc:format"                mode="plochc_p16998coll65"/>     <!-- create dc:format                                           -->
      <xsl:apply-templates select="dcterms:spatial"          mode="plochc_p16998coll65"/>     <!-- create dcterms:spatial                                     -->
      <xsl:apply-templates select="dc:subject"               mode="odn"/>                     <!-- create dcterms:subject                                     -->
      <xsl:apply-templates select="dc:type"                  mode="odn"/>                     <!-- create dcterms:type                                        -->

      <!-- OPTIONAL ODN-MAP fields -->
      <xsl:apply-templates select="dcterms:alternative"      mode="plochc_p16998coll65"/>     <!-- create dcterms:alternative                                 -->
      <xsl:apply-templates select="dc:contributor"           mode="plochc_p16998coll65"/>     <!-- create dcterms:contributor                                 -->
      <xsl:apply-templates select="dc:description"           mode="plochc_p16998coll65"/>     <!-- create dcterms:description                                 -->
      <xsl:apply-templates select="dcterms:extent"           mode="plochc_p16998coll65"/>     <!-- create dcterms:extent                                      -->
                                                                                              <!-- dcterms:identifier is created above as part of the edm:isShownAt transform -->
      <xsl:apply-templates select="dcterms:isReferencedBy"   mode="plochc_p16998coll65"/>     <!-- create IIIF metadata                                       -->
      <xsl:apply-templates select="dc:publisher"             mode="plochc_p16998coll65"/>     <!-- create dcterms:publisher                                   -->
      <xsl:apply-templates select="dc:relation"              mode="plochc_p16998coll65"/>     <!-- create dc:relation                                         -->
      <xsl:apply-templates select="dcterms:isPartOf"         mode="odn"/>                     <!-- create dc:relation                                         -->
                                                                                              <!-- dc:rights is created above as part of the edm:rights transform -->
      <xsl:copy-of         select="dcterms:rightsHolder"     copy-namespaces="no"/>           <!-- create dcterms:rightsHolder                                -->
      <xsl:apply-templates select="dcterms:temporal"         mode="odn"/>                     <!-- create dcterms:temporal                                    -->
      
      <xsl:apply-templates select="dc:source"                mode="odn"/>                     <!-- frequently unused; remove by default                       -->

      <xsl:apply-templates select="dcterms:dateSubmitted"    mode="plochc_p16998coll65"/>
      <xsl:apply-templates select="dcterms:medium"           mode="plochc_p16998coll65"/>
      <xsl:apply-templates select="dcterms:license"          mode="plochc_p16998coll65"/>

    </oai_qdc:qualifieddc>
  </xsl:template>

  <xsl:template match="dc:publisher" mode="plochc_p16998coll65"/>
  <xsl:template match="dc:relation" mode="plochc_p16998coll65"/>
  <xsl:template match="dc:format" mode="plochc_p16998coll65"/>
  <xsl:template match="dcterms:extent" mode="plochc_p16998coll65"/>
  <xsl:template match="dcterms:license" mode="plochc_p16998coll65"/>
  <xsl:template match="dcterms:isReferencedBy" mode="plochc_p16998coll65"/>

  <xsl:template match="dc:description" mode="plochc_p16998coll65">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:description">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:contributor" mode="plochc_p16998coll65">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:contributor">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:creator" mode="plochc_p16998coll65">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:creator">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dcterms:medium" mode="plochc_p16998coll65">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dc:format" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dcterms:dateSubmitted" mode="plochc_p16998coll65">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:date" mode="plochc_p16998coll65">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="dcterms:spatial" mode="plochc_p16998coll65">
    <xsl:choose>
      <xsl:when test="not(starts-with(., '39'))">
        <xsl:for-each select="tokenize(., ';')">
          <xsl:if test="normalize-space(.) != ''">
            <xsl:element name="dcterms:spatial" namespace="http://purl.org/dc/terms/">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="dcterms:spatial" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dcterms:alternative" mode="plochc_p16998coll65">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:alternative" namespace="http://purl.org/dc/elements/1.1/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- This collection has a few rights URLs that start "Http" instead of "http".
       That's distinctly non-standard, and doesn't work with some stuff.  I'm
       updating these values to be consistent with the other values being sent.
       An additional "list" (of one item) is being created for this custom
       xsl:template, but the template still refers to the standard lists, also.
   -->

  <xsl:template match="dc:rights" mode="plochc_p16998coll65">
    <xsl:for-each select="tokenize(., ';')">
        <xsl:if test="(normalize-space(.) != '') and (starts-with(normalize-space(replace(., 'Http', 'http')), 'http://') and ends-with(normalize-space(.), '/'))" >
            <xsl:choose>
              <xsl:when test="starts-with(normalize-space(.), 'http://rightsstatements.org/')">
                            <xsl:if test="index-of($rightsStatementsOrgList, normalize-space(.))">
                                <xsl:element name="edm:rights" namespace="http://www.europeana.eu/schemas/edm/">
                                    <xsl:value-of select="normalize-space(.)"/>
                                </xsl:element>
                            </xsl:if>
              </xsl:when>
              <xsl:when test="starts-with(normalize-space(.), 'Http://rightsstatements.org/')">
                            <xsl:if test="index-of($rightsStatementsOrgList_p16998coll65, normalize-space(.))">
                                <xsl:element name="edm:rights" namespace="http://www.europeana.eu/schemas/edm/">
                                    <xsl:value-of select="normalize-space(replace(., 'Http', 'http'))"/>
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

  <xsl:param name="rightsStatementsOrgList_p16998coll65"
           select="(
                     'Http://rightsstatements.org/vocab/InC/1.0/'
                  )"
  />

</xsl:stylesheet>
