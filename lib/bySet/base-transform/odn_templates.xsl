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
  xmlns:functx="http://www.functx.com"
  xsi:schemaLocation="http://worldcat.org/xmlschemas/qdc-1.0/
                      http://worldcat.org/xmlschemas/qdc/1.0/qdc-1.0.xsd
                      http://purl.org/net/oclcterms
                      http://worldcat.org/xmlschemas/oclcterms/1.4/oclcterms-1.4.xsd"
  exclude-result-prefixes="xs" version="2.0" xmlns="http://worldcat.org/xmlschemas/qdc-1.0/">

<!-- NOTE:  Changes to this file may not be immediately detected when it is pulled in by another XSL file!
            Edit the collection-specific XSL file to force REPOX to re-read this file.                        -->

  <!-- change history

        2017-08-21:  Added stanzas for dcterms:identifier and dcterms:temporal
        2017-12-06:  Reordered stanzas in mostly-alpha order
        2017-12-13:  Altered dc:type stanza to enforce adherence to the controlled vocabulary
        2017-12-21:  Altered dc:type stanza to tokenize values by semicolon during processing
        2017-12-21:  Altered dc:description stanza to remove HTML tags:  p, em, br
        2018-01-08:  Changed dc:relation to go to dc:relation instead of dcterms:isPartOf
        2018-01-08:  Removed "Collection" from list of acceptable values for dc:type
        2018-01-09:  Added default handler for dcterms:isPartOf, sending values to dc:relation
        2021-06-04:  Changed dc:identifier to accept http:// or https://
  -->


  <!-- This stylesheet processes standard qualified Dublin Core fields from standard oai_qdc OAI feeds. -->
  
  <xsl:output omit-xml-declaration="yes" indent="yes"/>


  <xsl:template match="dcterms:alternative" mode="odn">
    <xsl:element name="dcterms:alternative" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:contributor" mode="odn">
    <xsl:element name="dcterms:contributor" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:creator" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:creator">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:description" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:description">
      <xsl:value-of select="replace(replace(replace(normalize-space(.), '&lt;[/]*em&gt;', ''), '&lt;[/]*p&gt;', ''), '&lt;br&gt;', ' ')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dcterms:extent" mode="odn">
    <xsl:element name="dcterms:extent" namespace="http://purl.org/dc/terms/">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

 
  <!-- use the URL dc:identifier to both populate edm:isShownAt and use known CONTENTdm thumbnail path to construct thumbnail URL for edm:preview -->
  <xsl:template match="dc:identifier" mode="odn">
    <xsl:choose>
      <xsl:when test="starts-with(., 'http://') or starts-with(., 'https://')">
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
      <xsl:otherwise>
        <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:identifier">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dcterms:identifier" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:identifier">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dcterms:isPartOf" mode="odn">
    <xsl:element name="dc:relation" namespace="http://purl.org/dc/elements/1.1/">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:language" mode="odn">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:choose>
        <xsl:when test="normalize-space(lower-case(.)) = 'akk'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Akkadian</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'ara'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Arabic</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'arc'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Aramaic, Imperial (700-300 BCE)</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'cat'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Catalan</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'ces'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Czech</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'nld'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Dutch</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'eng'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">English</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'fra'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">French</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'deu'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">German</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'heb'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Hebrew</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'hun'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Hungarian</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'ita'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Italian</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'jpn'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Japanese</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'lat'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Latin</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'pol'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Polish</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'sco'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Scots</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'sin'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Sinhalese</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'spa'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Spanish</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'swe'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Swedish</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'ota'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Turkish, Ottoman (1500-1928)</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'yid'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">Yiddish</xsl:element>
        </xsl:when>
        <xsl:when test="normalize-space(lower-case(.)) = 'zxx'">
          <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">not applicable</xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="normalize-space(.) != ''">
            <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:language">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:element>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:publisher" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:publisher">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:relation" mode="odn">
    <xsl:element namespace="http://purl.org/dc/elements/1.1/" name="dc:relation">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:rights" mode="odn">
    <xsl:for-each select="tokenize(., ';')">
        <xsl:if test="(normalize-space(.) != '') and (starts-with(normalize-space(.), 'http://') and ends-with(normalize-space(.), '/'))" >
            <xsl:choose>
              <xsl:when test="starts-with(normalize-space(.), 'http://rightsstatements.org/')">
                            <xsl:if test="index-of($rightsStatementsOrgList, normalize-space(.))">
                                <xsl:element name="edm:rights" namespace="http://www.europeana.eu/schemas/edm/">
                                    <xsl:value-of select="normalize-space(.)"/>
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

  <xsl:template match="dc:source" mode="odn"/>

  <xsl:template match="dc:subject" mode="odn">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="dcterms:subject" namespace="http://purl.org/dc/terms/">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dcterms:temporal" mode="odn">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:temporal">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="dc:title" mode="odn">
    <xsl:element namespace="http://purl.org/dc/terms/" name="dcterms:title">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="dc:type" mode="odn">
    <xsl:for-each select=".">
      <xsl:for-each select="tokenize(., ';')">
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
    </xsl:for-each>
  </xsl:template>


  <!-- This stanza should be updated when we encounter new mimetypes.  The 'name="fr"' variable contains
       values that will be searched in the dc:format field, and the 'name="to"' variable contains the
       values that will replace the corresponding "fr" values.  The search is case-insensitive, so the
       "fr" entry reading "image/tiff" will catch "image/tiff", "image/TIFF", "Image/TifF", etc. -->

  <xsl:template match="dc:format" mode="odn">
    <xsl:variable name="fr" select="('audio/mpeg', 'video/jpeg', 'video/jpeg2000', 'video/mpeg', 'image/tiff', 'image/jpeg', 'image/png', 'application/pdf')"/>
    <xsl:variable name="to" select="('audio/mpeg', 'video/jpeg', 'video/jpeg2000', 'video/mpeg', 'image/tiff', 'image/jpeg', 'image/png', 'application/pdf')"/>
    <xsl:element name="dc:format" namespace="http://purl.org/dc/elements/1.1/">
        <xsl:value-of select="normalize-space(functx:replace-multi(., $fr, $to))"/>
    </xsl:element>
  </xsl:template>


  <!-- The following function (functx:replace-multi) is used to perform multiple replacements upon a string.
       It's being used for dc:format, to ensure that all mime-type values (e.g. "text/html") included in the
       dc:format metadata are in lowercase text.  The lowercasing of these values isn't required, but it's
       the convention and will result in more consistent metadata. 
       This function was taken from here:  http://www.xqueryfunctions.com/xq/functx_replace-multi.html -->

  <xsl:function name="functx:replace-multi" as="xs:string?" xmlns:functx="http://www.functx.com">
    <xsl:param name="arg" as="xs:string?"/>
    <xsl:param name="changeFrom" as="xs:string*"/>
    <xsl:param name="changeTo" as="xs:string*"/>

    <xsl:sequence select="
     if (count($changeFrom) > 0)
     then functx:replace-multi(
            replace($arg, $changeFrom[1], functx:if-absent($changeTo[1],''), 'i'),
            $changeFrom[position() > 1],
            $changeTo[position() > 1])
     else $arg
    "/>
  </xsl:function>


  <!-- The following function (functx:if-absent) is used by the "functx:replace-multi" function, and is
       included here for that reason. -->

  <xsl:function name="functx:if-absent" as="item()*" xmlns:functx="http://www.functx.com">
    <xsl:param name="arg" as="item()*"/>
    <xsl:param name="value" as="item()*"/>

    <xsl:sequence select="
      if (exists($arg))
      then $arg
      else $value
    "/>
  </xsl:function>

  <xsl:param name="rightsStatementsOrgList" 
           select="(
                     'http://rightsstatements.org/vocab/CNE/1.0/',
                     'http://rightsstatements.org/vocab/InC-EDU/1.0/',
                     'http://rightsstatements.org/vocab/InC-NC/1.0/',
                     'http://rightsstatements.org/vocab/InC-OW-EU/1.0/',
                     'http://rightsstatements.org/vocab/InC-RUU/1.0/',
                     'http://rightsstatements.org/vocab/InC/1.0/',
                     'http://rightsstatements.org/vocab/NKC/1.0/',
                     'http://rightsstatements.org/vocab/NoC-CR/1.0/',
                     'http://rightsstatements.org/vocab/NoC-NC/1.0/',
                     'http://rightsstatements.org/vocab/NoC-OKLR/1.0/',
                     'http://rightsstatements.org/vocab/NoC-US/1.0/',
                     'http://rightsstatements.org/vocab/UND/1.0/'
                  )" 
  />
  <xsl:param name="creativeCommonsOrgList" 
           select="(
                     'http://creativecommons.org/licenses/BSD/',
                     'http://creativecommons.org/licenses/by-nc-nd/1.0/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/at/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/au/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/be/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/br/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/ca/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/cl/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/de/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/es/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/fr/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/hr/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/it/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/jp/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/kr/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/nl/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/pl/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/tw/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/uk/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.0/za/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/ar/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/au/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/bg/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/br/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/ca/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/ch/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/cn/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/co/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/dk/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/es/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/hr/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/hu/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/il/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/in/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/it/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/mk/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/mt/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/mx/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/my/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/nl/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/pe/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/pl/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/pt/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/scotland/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/se/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/si/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/tw/',
                     'http://creativecommons.org/licenses/by-nc-nd/2.5/za/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/at/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/au/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/br/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/ch/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/cl/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/cn/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/cr/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/cz/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/de/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/ec/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/ee/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/eg/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/es/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/fr/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/gr/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/gt/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/hk/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/hr/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/ie/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/igo/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/it/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/lu/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/nl/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/no/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/nz/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/ph/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/pl/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/pr/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/pt/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/ro/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/rs/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/sg/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/th/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/tw/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/ug/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/us/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/ve/',
                     'http://creativecommons.org/licenses/by-nc-nd/3.0/vn/',
                     'http://creativecommons.org/licenses/by-nc-nd/4.0/',
                     'http://creativecommons.org/licenses/by-nc-sa/1.0/',
                     'http://creativecommons.org/licenses/by-nc-sa/1.0/fi/',
                     'http://creativecommons.org/licenses/by-nc-sa/1.0/il/',
                     'http://creativecommons.org/licenses/by-nc-sa/1.0/nl/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/at/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/au/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/be/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/br/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/ca/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/cl/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/de/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/es/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/fr/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/hr/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/it/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/jp/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/kr/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/nl/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/pl/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/tw/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/uk/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.0/za/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/ar/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/au/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/bg/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/br/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/ca/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/ch/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/cn/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/co/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/dk/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/es/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/hr/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/hu/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/il/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/in/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/it/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/mk/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/mt/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/mx/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/my/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/nl/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/pe/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/pl/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/pt/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/scotland/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/se/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/si/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/tw/',
                     'http://creativecommons.org/licenses/by-nc-sa/2.5/za/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/at/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/au/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/br/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/ch/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/cl/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/cn/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/cr/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/cz/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/de/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/ec/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/ee/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/eg/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/es/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/fr/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/gr/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/gt/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/hk/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/hr/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/ie/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/igo/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/it/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/lu/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/nl/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/no/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/nz/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/ph/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/pl/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/pr/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/pt/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/ro/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/rs/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/sg/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/th/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/tw/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/ug/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/us/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/ve/',
                     'http://creativecommons.org/licenses/by-nc-sa/3.0/vn/',
                     'http://creativecommons.org/licenses/by-nc-sa/4.0/',
                     'http://creativecommons.org/licenses/by-nc/1.0/',
                     'http://creativecommons.org/licenses/by-nc/1.0/fi/',
                     'http://creativecommons.org/licenses/by-nc/1.0/il/',
                     'http://creativecommons.org/licenses/by-nc/1.0/nl/',
                     'http://creativecommons.org/licenses/by-nc/2.0/',
                     'http://creativecommons.org/licenses/by-nc/2.0/at/',
                     'http://creativecommons.org/licenses/by-nc/2.0/au/',
                     'http://creativecommons.org/licenses/by-nc/2.0/be/',
                     'http://creativecommons.org/licenses/by-nc/2.0/br/',
                     'http://creativecommons.org/licenses/by-nc/2.0/ca/',
                     'http://creativecommons.org/licenses/by-nc/2.0/cl/',
                     'http://creativecommons.org/licenses/by-nc/2.0/de/',
                     'http://creativecommons.org/licenses/by-nc/2.0/es/',
                     'http://creativecommons.org/licenses/by-nc/2.0/fr/',
                     'http://creativecommons.org/licenses/by-nc/2.0/hr/',
                     'http://creativecommons.org/licenses/by-nc/2.0/it/',
                     'http://creativecommons.org/licenses/by-nc/2.0/jp/',
                     'http://creativecommons.org/licenses/by-nc/2.0/kr/',
                     'http://creativecommons.org/licenses/by-nc/2.0/nl/',
                     'http://creativecommons.org/licenses/by-nc/2.0/pl/',
                     'http://creativecommons.org/licenses/by-nc/2.0/tw/',
                     'http://creativecommons.org/licenses/by-nc/2.0/uk/',
                     'http://creativecommons.org/licenses/by-nc/2.0/za/',
                     'http://creativecommons.org/licenses/by-nc/2.5/',
                     'http://creativecommons.org/licenses/by-nc/2.5/ar/',
                     'http://creativecommons.org/licenses/by-nc/2.5/au/',
                     'http://creativecommons.org/licenses/by-nc/2.5/bg/',
                     'http://creativecommons.org/licenses/by-nc/2.5/br/',
                     'http://creativecommons.org/licenses/by-nc/2.5/ca/',
                     'http://creativecommons.org/licenses/by-nc/2.5/ch/',
                     'http://creativecommons.org/licenses/by-nc/2.5/cn/',
                     'http://creativecommons.org/licenses/by-nc/2.5/co/',
                     'http://creativecommons.org/licenses/by-nc/2.5/dk/',
                     'http://creativecommons.org/licenses/by-nc/2.5/es/',
                     'http://creativecommons.org/licenses/by-nc/2.5/hr/',
                     'http://creativecommons.org/licenses/by-nc/2.5/hu/',
                     'http://creativecommons.org/licenses/by-nc/2.5/il/',
                     'http://creativecommons.org/licenses/by-nc/2.5/in/',
                     'http://creativecommons.org/licenses/by-nc/2.5/it/',
                     'http://creativecommons.org/licenses/by-nc/2.5/mk/',
                     'http://creativecommons.org/licenses/by-nc/2.5/mt/',
                     'http://creativecommons.org/licenses/by-nc/2.5/mx/',
                     'http://creativecommons.org/licenses/by-nc/2.5/my/',
                     'http://creativecommons.org/licenses/by-nc/2.5/nl/',
                     'http://creativecommons.org/licenses/by-nc/2.5/pe/',
                     'http://creativecommons.org/licenses/by-nc/2.5/pl/',
                     'http://creativecommons.org/licenses/by-nc/2.5/pt/',
                     'http://creativecommons.org/licenses/by-nc/2.5/scotland/',
                     'http://creativecommons.org/licenses/by-nc/2.5/se/',
                     'http://creativecommons.org/licenses/by-nc/2.5/si/',
                     'http://creativecommons.org/licenses/by-nc/2.5/tw/',
                     'http://creativecommons.org/licenses/by-nc/2.5/za/',
                     'http://creativecommons.org/licenses/by-nc/3.0/',
                     'http://creativecommons.org/licenses/by-nc/3.0/at/',
                     'http://creativecommons.org/licenses/by-nc/3.0/au/',
                     'http://creativecommons.org/licenses/by-nc/3.0/br/',
                     'http://creativecommons.org/licenses/by-nc/3.0/ch/',
                     'http://creativecommons.org/licenses/by-nc/3.0/cl/',
                     'http://creativecommons.org/licenses/by-nc/3.0/cn/',
                     'http://creativecommons.org/licenses/by-nc/3.0/cr/',
                     'http://creativecommons.org/licenses/by-nc/3.0/cz/',
                     'http://creativecommons.org/licenses/by-nc/3.0/de/',
                     'http://creativecommons.org/licenses/by-nc/3.0/ec/',
                     'http://creativecommons.org/licenses/by-nc/3.0/ee/',
                     'http://creativecommons.org/licenses/by-nc/3.0/eg/',
                     'http://creativecommons.org/licenses/by-nc/3.0/es/',
                     'http://creativecommons.org/licenses/by-nc/3.0/fr/',
                     'http://creativecommons.org/licenses/by-nc/3.0/gr/',
                     'http://creativecommons.org/licenses/by-nc/3.0/gt/',
                     'http://creativecommons.org/licenses/by-nc/3.0/hk/',
                     'http://creativecommons.org/licenses/by-nc/3.0/hr/',
                     'http://creativecommons.org/licenses/by-nc/3.0/ie/',
                     'http://creativecommons.org/licenses/by-nc/3.0/igo/',
                     'http://creativecommons.org/licenses/by-nc/3.0/it/',
                     'http://creativecommons.org/licenses/by-nc/3.0/lu/',
                     'http://creativecommons.org/licenses/by-nc/3.0/nl/',
                     'http://creativecommons.org/licenses/by-nc/3.0/no/',
                     'http://creativecommons.org/licenses/by-nc/3.0/nz/',
                     'http://creativecommons.org/licenses/by-nc/3.0/ph/',
                     'http://creativecommons.org/licenses/by-nc/3.0/pl/',
                     'http://creativecommons.org/licenses/by-nc/3.0/pr/',
                     'http://creativecommons.org/licenses/by-nc/3.0/pt/',
                     'http://creativecommons.org/licenses/by-nc/3.0/ro/',
                     'http://creativecommons.org/licenses/by-nc/3.0/rs/',
                     'http://creativecommons.org/licenses/by-nc/3.0/sg/',
                     'http://creativecommons.org/licenses/by-nc/3.0/th/',
                     'http://creativecommons.org/licenses/by-nc/3.0/tw/',
                     'http://creativecommons.org/licenses/by-nc/3.0/ug/',
                     'http://creativecommons.org/licenses/by-nc/3.0/us/',
                     'http://creativecommons.org/licenses/by-nc/3.0/ve/',
                     'http://creativecommons.org/licenses/by-nc/3.0/vn/',
                     'http://creativecommons.org/licenses/by-nc/4.0/',
                     'http://creativecommons.org/licenses/by-nd-nc/1.0/',
                     'http://creativecommons.org/licenses/by-nd-nc/1.0/fi/',
                     'http://creativecommons.org/licenses/by-nd-nc/1.0/il/',
                     'http://creativecommons.org/licenses/by-nd-nc/1.0/nl/',
                     'http://creativecommons.org/licenses/by-nd-nc/2.0/jp/',
                     'http://creativecommons.org/licenses/by-nd/1.0/',
                     'http://creativecommons.org/licenses/by-nd/1.0/fi/',
                     'http://creativecommons.org/licenses/by-nd/1.0/il/',
                     'http://creativecommons.org/licenses/by-nd/1.0/nl/',
                     'http://creativecommons.org/licenses/by-nd/2.0/',
                     'http://creativecommons.org/licenses/by-nd/2.0/at/',
                     'http://creativecommons.org/licenses/by-nd/2.0/au/',
                     'http://creativecommons.org/licenses/by-nd/2.0/be/',
                     'http://creativecommons.org/licenses/by-nd/2.0/br/',
                     'http://creativecommons.org/licenses/by-nd/2.0/ca/',
                     'http://creativecommons.org/licenses/by-nd/2.0/cl/',
                     'http://creativecommons.org/licenses/by-nd/2.0/de/',
                     'http://creativecommons.org/licenses/by-nd/2.0/es/',
                     'http://creativecommons.org/licenses/by-nd/2.0/fr/',
                     'http://creativecommons.org/licenses/by-nd/2.0/hr/',
                     'http://creativecommons.org/licenses/by-nd/2.0/it/',
                     'http://creativecommons.org/licenses/by-nd/2.0/jp/',
                     'http://creativecommons.org/licenses/by-nd/2.0/kr/',
                     'http://creativecommons.org/licenses/by-nd/2.0/nl/',
                     'http://creativecommons.org/licenses/by-nd/2.0/pl/',
                     'http://creativecommons.org/licenses/by-nd/2.0/tw/',
                     'http://creativecommons.org/licenses/by-nd/2.0/uk/',
                     'http://creativecommons.org/licenses/by-nd/2.0/za/',
                     'http://creativecommons.org/licenses/by-nd/2.5/',
                     'http://creativecommons.org/licenses/by-nd/2.5/ar/',
                     'http://creativecommons.org/licenses/by-nd/2.5/au/',
                     'http://creativecommons.org/licenses/by-nd/2.5/bg/',
                     'http://creativecommons.org/licenses/by-nd/2.5/br/',
                     'http://creativecommons.org/licenses/by-nd/2.5/ca/',
                     'http://creativecommons.org/licenses/by-nd/2.5/ch/',
                     'http://creativecommons.org/licenses/by-nd/2.5/cn/',
                     'http://creativecommons.org/licenses/by-nd/2.5/co/',
                     'http://creativecommons.org/licenses/by-nd/2.5/dk/',
                     'http://creativecommons.org/licenses/by-nd/2.5/es/',
                     'http://creativecommons.org/licenses/by-nd/2.5/hr/',
                     'http://creativecommons.org/licenses/by-nd/2.5/hu/',
                     'http://creativecommons.org/licenses/by-nd/2.5/il/',
                     'http://creativecommons.org/licenses/by-nd/2.5/in/',
                     'http://creativecommons.org/licenses/by-nd/2.5/it/',
                     'http://creativecommons.org/licenses/by-nd/2.5/mk/',
                     'http://creativecommons.org/licenses/by-nd/2.5/mt/',
                     'http://creativecommons.org/licenses/by-nd/2.5/mx/',
                     'http://creativecommons.org/licenses/by-nd/2.5/my/',
                     'http://creativecommons.org/licenses/by-nd/2.5/nl/',
                     'http://creativecommons.org/licenses/by-nd/2.5/pe/',
                     'http://creativecommons.org/licenses/by-nd/2.5/pl/',
                     'http://creativecommons.org/licenses/by-nd/2.5/pt/',
                     'http://creativecommons.org/licenses/by-nd/2.5/scotland/',
                     'http://creativecommons.org/licenses/by-nd/2.5/se/',
                     'http://creativecommons.org/licenses/by-nd/2.5/si/',
                     'http://creativecommons.org/licenses/by-nd/2.5/tw/',
                     'http://creativecommons.org/licenses/by-nd/2.5/za/',
                     'http://creativecommons.org/licenses/by-nd/3.0/',
                     'http://creativecommons.org/licenses/by-nd/3.0/at/',
                     'http://creativecommons.org/licenses/by-nd/3.0/au/',
                     'http://creativecommons.org/licenses/by-nd/3.0/br/',
                     'http://creativecommons.org/licenses/by-nd/3.0/ch/',
                     'http://creativecommons.org/licenses/by-nd/3.0/cl/',
                     'http://creativecommons.org/licenses/by-nd/3.0/cn/',
                     'http://creativecommons.org/licenses/by-nd/3.0/cr/',
                     'http://creativecommons.org/licenses/by-nd/3.0/cz/',
                     'http://creativecommons.org/licenses/by-nd/3.0/de/',
                     'http://creativecommons.org/licenses/by-nd/3.0/ec/',
                     'http://creativecommons.org/licenses/by-nd/3.0/ee/',
                     'http://creativecommons.org/licenses/by-nd/3.0/eg/',
                     'http://creativecommons.org/licenses/by-nd/3.0/es/',
                     'http://creativecommons.org/licenses/by-nd/3.0/fr/',
                     'http://creativecommons.org/licenses/by-nd/3.0/gr/',
                     'http://creativecommons.org/licenses/by-nd/3.0/gt/',
                     'http://creativecommons.org/licenses/by-nd/3.0/hk/',
                     'http://creativecommons.org/licenses/by-nd/3.0/hr/',
                     'http://creativecommons.org/licenses/by-nd/3.0/ie/',
                     'http://creativecommons.org/licenses/by-nd/3.0/igo/',
                     'http://creativecommons.org/licenses/by-nd/3.0/it/',
                     'http://creativecommons.org/licenses/by-nd/3.0/lu/',
                     'http://creativecommons.org/licenses/by-nd/3.0/nl/',
                     'http://creativecommons.org/licenses/by-nd/3.0/no/',
                     'http://creativecommons.org/licenses/by-nd/3.0/nz/',
                     'http://creativecommons.org/licenses/by-nd/3.0/ph/',
                     'http://creativecommons.org/licenses/by-nd/3.0/pl/',
                     'http://creativecommons.org/licenses/by-nd/3.0/pr/',
                     'http://creativecommons.org/licenses/by-nd/3.0/pt/',
                     'http://creativecommons.org/licenses/by-nd/3.0/ro/',
                     'http://creativecommons.org/licenses/by-nd/3.0/rs/',
                     'http://creativecommons.org/licenses/by-nd/3.0/sg/',
                     'http://creativecommons.org/licenses/by-nd/3.0/th/',
                     'http://creativecommons.org/licenses/by-nd/3.0/tw/',
                     'http://creativecommons.org/licenses/by-nd/3.0/ug/',
                     'http://creativecommons.org/licenses/by-nd/3.0/us/',
                     'http://creativecommons.org/licenses/by-nd/3.0/ve/',
                     'http://creativecommons.org/licenses/by-nd/3.0/vn/',
                     'http://creativecommons.org/licenses/by-nd/4.0/',
                     'http://creativecommons.org/licenses/by-sa/1.0/',
                     'http://creativecommons.org/licenses/by-sa/1.0/fi/',
                     'http://creativecommons.org/licenses/by-sa/1.0/il/',
                     'http://creativecommons.org/licenses/by-sa/1.0/nl/',
                     'http://creativecommons.org/licenses/by-sa/2.0/',
                     'http://creativecommons.org/licenses/by-sa/2.0/at/',
                     'http://creativecommons.org/licenses/by-sa/2.0/au/',
                     'http://creativecommons.org/licenses/by-sa/2.0/be/',
                     'http://creativecommons.org/licenses/by-sa/2.0/br/',
                     'http://creativecommons.org/licenses/by-sa/2.0/ca/',
                     'http://creativecommons.org/licenses/by-sa/2.0/cl/',
                     'http://creativecommons.org/licenses/by-sa/2.0/de/',
                     'http://creativecommons.org/licenses/by-sa/2.0/es/',
                     'http://creativecommons.org/licenses/by-sa/2.0/fr/',
                     'http://creativecommons.org/licenses/by-sa/2.0/hr/',
                     'http://creativecommons.org/licenses/by-sa/2.0/it/',
                     'http://creativecommons.org/licenses/by-sa/2.0/jp/',
                     'http://creativecommons.org/licenses/by-sa/2.0/kr/',
                     'http://creativecommons.org/licenses/by-sa/2.0/nl/',
                     'http://creativecommons.org/licenses/by-sa/2.0/pl/',
                     'http://creativecommons.org/licenses/by-sa/2.0/tw/',
                     'http://creativecommons.org/licenses/by-sa/2.0/uk/',
                     'http://creativecommons.org/licenses/by-sa/2.0/za/',
                     'http://creativecommons.org/licenses/by-sa/2.5/',
                     'http://creativecommons.org/licenses/by-sa/2.5/ar/',
                     'http://creativecommons.org/licenses/by-sa/2.5/au/',
                     'http://creativecommons.org/licenses/by-sa/2.5/bg/',
                     'http://creativecommons.org/licenses/by-sa/2.5/br/',
                     'http://creativecommons.org/licenses/by-sa/2.5/ca/',
                     'http://creativecommons.org/licenses/by-sa/2.5/ch/',
                     'http://creativecommons.org/licenses/by-sa/2.5/cn/',
                     'http://creativecommons.org/licenses/by-sa/2.5/co/',
                     'http://creativecommons.org/licenses/by-sa/2.5/dk/',
                     'http://creativecommons.org/licenses/by-sa/2.5/es/',
                     'http://creativecommons.org/licenses/by-sa/2.5/hr/',
                     'http://creativecommons.org/licenses/by-sa/2.5/hu/',
                     'http://creativecommons.org/licenses/by-sa/2.5/il/',
                     'http://creativecommons.org/licenses/by-sa/2.5/in/',
                     'http://creativecommons.org/licenses/by-sa/2.5/it/',
                     'http://creativecommons.org/licenses/by-sa/2.5/mk/',
                     'http://creativecommons.org/licenses/by-sa/2.5/mt/',
                     'http://creativecommons.org/licenses/by-sa/2.5/mx/',
                     'http://creativecommons.org/licenses/by-sa/2.5/my/',
                     'http://creativecommons.org/licenses/by-sa/2.5/nl/',
                     'http://creativecommons.org/licenses/by-sa/2.5/pe/',
                     'http://creativecommons.org/licenses/by-sa/2.5/pl/',
                     'http://creativecommons.org/licenses/by-sa/2.5/pt/',
                     'http://creativecommons.org/licenses/by-sa/2.5/scotland/',
                     'http://creativecommons.org/licenses/by-sa/2.5/se/',
                     'http://creativecommons.org/licenses/by-sa/2.5/si/',
                     'http://creativecommons.org/licenses/by-sa/2.5/tw/',
                     'http://creativecommons.org/licenses/by-sa/2.5/za/',
                     'http://creativecommons.org/licenses/by-sa/3.0/',
                     'http://creativecommons.org/licenses/by-sa/3.0/at/',
                     'http://creativecommons.org/licenses/by-sa/3.0/au/',
                     'http://creativecommons.org/licenses/by-sa/3.0/br/',
                     'http://creativecommons.org/licenses/by-sa/3.0/ch/',
                     'http://creativecommons.org/licenses/by-sa/3.0/cl/',
                     'http://creativecommons.org/licenses/by-sa/3.0/cn/',
                     'http://creativecommons.org/licenses/by-sa/3.0/cr/',
                     'http://creativecommons.org/licenses/by-sa/3.0/cz/',
                     'http://creativecommons.org/licenses/by-sa/3.0/de/',
                     'http://creativecommons.org/licenses/by-sa/3.0/ec/',
                     'http://creativecommons.org/licenses/by-sa/3.0/ee/',
                     'http://creativecommons.org/licenses/by-sa/3.0/eg/',
                     'http://creativecommons.org/licenses/by-sa/3.0/es/',
                     'http://creativecommons.org/licenses/by-sa/3.0/fr/',
                     'http://creativecommons.org/licenses/by-sa/3.0/gr/',
                     'http://creativecommons.org/licenses/by-sa/3.0/gt/',
                     'http://creativecommons.org/licenses/by-sa/3.0/hk/',
                     'http://creativecommons.org/licenses/by-sa/3.0/hr/',
                     'http://creativecommons.org/licenses/by-sa/3.0/ie/',
                     'http://creativecommons.org/licenses/by-sa/3.0/igo/',
                     'http://creativecommons.org/licenses/by-sa/3.0/it/',
                     'http://creativecommons.org/licenses/by-sa/3.0/lu/',
                     'http://creativecommons.org/licenses/by-sa/3.0/nl/',
                     'http://creativecommons.org/licenses/by-sa/3.0/no/',
                     'http://creativecommons.org/licenses/by-sa/3.0/nz/',
                     'http://creativecommons.org/licenses/by-sa/3.0/ph/',
                     'http://creativecommons.org/licenses/by-sa/3.0/pl/',
                     'http://creativecommons.org/licenses/by-sa/3.0/pr/',
                     'http://creativecommons.org/licenses/by-sa/3.0/pt/',
                     'http://creativecommons.org/licenses/by-sa/3.0/ro/',
                     'http://creativecommons.org/licenses/by-sa/3.0/rs/',
                     'http://creativecommons.org/licenses/by-sa/3.0/sg/',
                     'http://creativecommons.org/licenses/by-sa/3.0/th/',
                     'http://creativecommons.org/licenses/by-sa/3.0/tw/',
                     'http://creativecommons.org/licenses/by-sa/3.0/ug/',
                     'http://creativecommons.org/licenses/by-sa/3.0/us/',
                     'http://creativecommons.org/licenses/by-sa/3.0/ve/',
                     'http://creativecommons.org/licenses/by-sa/3.0/vn/',
                     'http://creativecommons.org/licenses/by-sa/4.0/',
                     'http://creativecommons.org/licenses/by/1.0/',
                     'http://creativecommons.org/licenses/by/1.0/fi/',
                     'http://creativecommons.org/licenses/by/1.0/il/',
                     'http://creativecommons.org/licenses/by/1.0/nl/',
                     'http://creativecommons.org/licenses/by/2.0/',
                     'http://creativecommons.org/licenses/by/2.0/at/',
                     'http://creativecommons.org/licenses/by/2.0/au/',
                     'http://creativecommons.org/licenses/by/2.0/be/',
                     'http://creativecommons.org/licenses/by/2.0/br/',
                     'http://creativecommons.org/licenses/by/2.0/ca/',
                     'http://creativecommons.org/licenses/by/2.0/cl/',
                     'http://creativecommons.org/licenses/by/2.0/de/',
                     'http://creativecommons.org/licenses/by/2.0/es/',
                     'http://creativecommons.org/licenses/by/2.0/fr/',
                     'http://creativecommons.org/licenses/by/2.0/hr/',
                     'http://creativecommons.org/licenses/by/2.0/it/',
                     'http://creativecommons.org/licenses/by/2.0/jp/',
                     'http://creativecommons.org/licenses/by/2.0/kr/',
                     'http://creativecommons.org/licenses/by/2.0/nl/',
                     'http://creativecommons.org/licenses/by/2.0/pl/',
                     'http://creativecommons.org/licenses/by/2.0/tw/',
                     'http://creativecommons.org/licenses/by/2.0/uk/',
                     'http://creativecommons.org/licenses/by/2.0/za/',
                     'http://creativecommons.org/licenses/by/2.5/',
                     'http://creativecommons.org/licenses/by/2.5/ar/',
                     'http://creativecommons.org/licenses/by/2.5/au/',
                     'http://creativecommons.org/licenses/by/2.5/bg/',
                     'http://creativecommons.org/licenses/by/2.5/br/',
                     'http://creativecommons.org/licenses/by/2.5/ca/',
                     'http://creativecommons.org/licenses/by/2.5/ch/',
                     'http://creativecommons.org/licenses/by/2.5/cn/',
                     'http://creativecommons.org/licenses/by/2.5/co/',
                     'http://creativecommons.org/licenses/by/2.5/dk/',
                     'http://creativecommons.org/licenses/by/2.5/es/',
                     'http://creativecommons.org/licenses/by/2.5/hr/',
                     'http://creativecommons.org/licenses/by/2.5/hu/',
                     'http://creativecommons.org/licenses/by/2.5/il/',
                     'http://creativecommons.org/licenses/by/2.5/in/',
                     'http://creativecommons.org/licenses/by/2.5/it/',
                     'http://creativecommons.org/licenses/by/2.5/mk/',
                     'http://creativecommons.org/licenses/by/2.5/mt/',
                     'http://creativecommons.org/licenses/by/2.5/mx/',
                     'http://creativecommons.org/licenses/by/2.5/my/',
                     'http://creativecommons.org/licenses/by/2.5/nl/',
                     'http://creativecommons.org/licenses/by/2.5/pe/',
                     'http://creativecommons.org/licenses/by/2.5/pl/',
                     'http://creativecommons.org/licenses/by/2.5/pt/',
                     'http://creativecommons.org/licenses/by/2.5/scotland/',
                     'http://creativecommons.org/licenses/by/2.5/se/',
                     'http://creativecommons.org/licenses/by/2.5/si/',
                     'http://creativecommons.org/licenses/by/2.5/tw/',
                     'http://creativecommons.org/licenses/by/2.5/za/',
                     'http://creativecommons.org/licenses/by/3.0/',
                     'http://creativecommons.org/licenses/by/3.0/at/',
                     'http://creativecommons.org/licenses/by/3.0/au/',
                     'http://creativecommons.org/licenses/by/3.0/br/',
                     'http://creativecommons.org/licenses/by/3.0/ch/',
                     'http://creativecommons.org/licenses/by/3.0/cl/',
                     'http://creativecommons.org/licenses/by/3.0/cn/',
                     'http://creativecommons.org/licenses/by/3.0/cr/',
                     'http://creativecommons.org/licenses/by/3.0/cz/',
                     'http://creativecommons.org/licenses/by/3.0/de/',
                     'http://creativecommons.org/licenses/by/3.0/ec/',
                     'http://creativecommons.org/licenses/by/3.0/ee/',
                     'http://creativecommons.org/licenses/by/3.0/eg/',
                     'http://creativecommons.org/licenses/by/3.0/es/',
                     'http://creativecommons.org/licenses/by/3.0/fr/',
                     'http://creativecommons.org/licenses/by/3.0/gr/',
                     'http://creativecommons.org/licenses/by/3.0/gt/',
                     'http://creativecommons.org/licenses/by/3.0/hk/',
                     'http://creativecommons.org/licenses/by/3.0/hr/',
                     'http://creativecommons.org/licenses/by/3.0/ie/',
                     'http://creativecommons.org/licenses/by/3.0/igo/',
                     'http://creativecommons.org/licenses/by/3.0/it/',
                     'http://creativecommons.org/licenses/by/3.0/lu/',
                     'http://creativecommons.org/licenses/by/3.0/nl/',
                     'http://creativecommons.org/licenses/by/3.0/no/',
                     'http://creativecommons.org/licenses/by/3.0/nz/',
                     'http://creativecommons.org/licenses/by/3.0/ph/',
                     'http://creativecommons.org/licenses/by/3.0/pl/',
                     'http://creativecommons.org/licenses/by/3.0/pr/',
                     'http://creativecommons.org/licenses/by/3.0/pt/',
                     'http://creativecommons.org/licenses/by/3.0/ro/',
                     'http://creativecommons.org/licenses/by/3.0/rs/',
                     'http://creativecommons.org/licenses/by/3.0/sg/',
                     'http://creativecommons.org/licenses/by/3.0/th/',
                     'http://creativecommons.org/licenses/by/3.0/tw/',
                     'http://creativecommons.org/licenses/by/3.0/ug/',
                     'http://creativecommons.org/licenses/by/3.0/us/',
                     'http://creativecommons.org/licenses/by/3.0/ve/',
                     'http://creativecommons.org/licenses/by/3.0/vn/',
                     'http://creativecommons.org/licenses/by/4.0/',
                     'http://creativecommons.org/licenses/GPL/2.0/',
                     'http://creativecommons.org/licenses/LGPL/2.1/',
                     'http://creativecommons.org/licenses/MIT/',
                     'http://creativecommons.org/licenses/nc-sa/1.0/',
                     'http://creativecommons.org/licenses/nc-sa/1.0/fi/',
                     'http://creativecommons.org/licenses/nc-sa/1.0/nl/',
                     'http://creativecommons.org/licenses/nc-sa/2.0/jp/',
                     'http://creativecommons.org/licenses/nc/1.0/',
                     'http://creativecommons.org/licenses/nc/1.0/fi/',
                     'http://creativecommons.org/licenses/nc/1.0/nl/',
                     'http://creativecommons.org/licenses/nc/2.0/jp/',
                     'http://creativecommons.org/licenses/nd/1.0/',
                     'http://creativecommons.org/licenses/nd/1.0/fi/',
                     'http://creativecommons.org/licenses/nd/1.0/nl/',
                     'http://creativecommons.org/licenses/nd/2.0/jp/',
                     'http://creativecommons.org/licenses/publicdomain/',
                     'http://creativecommons.org/licenses/sa/1.0/',
                     'http://creativecommons.org/licenses/sa/1.0/fi/',
                     'http://creativecommons.org/licenses/sa/1.0/nl/',
                     'http://creativecommons.org/licenses/sa/2.0/jp/',
                     'http://creativecommons.org/licenses/sampling/1.0/',
                     'http://creativecommons.org/licenses/sampling/1.0/br/',
                     'http://creativecommons.org/licenses/sampling/1.0/tw/',
                     'http://creativecommons.org/publicdomain/mark/1.0/',
                     'http://creativecommons.org/publicdomain/zero/1.0/'
                  )" 
  />
</xsl:stylesheet>
