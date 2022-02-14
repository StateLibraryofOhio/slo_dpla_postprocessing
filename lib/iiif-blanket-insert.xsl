<xsl:stylesheet
  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
  xmlns:mods="http://www.loc.gov/mods/v3"
  exclude-result-prefixes="xs"
  xpath-default-namespace="http://www.openarchives.org/OAI/2.0/"
  expand-text="yes">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:mode on-no-match="shallow-copy"/>


  <!-- This XSLT is intended to add dcterms:isReferencedBy values to a dataset.  -->

  <!-- It currently detects whether a server is:                                 -->
  <!--    a.  running CONTENTdm, or                                              -->
  <!--    b.  is part of Kent's OAKS server.                                     -->

  <!-- The XSLT tests each record to confirm that:                               -->
  <!--    a.  the record has proper permissions for IIIF, and                    -->
  <!--    b.  the record is part of a set designated as participating in IIIF    -->

  <!-- If the record is shared, an appropriate IIIF value is generated for the   -->
  <!-- dcterms:isReferencedBy field based on whether the record is coming from   -->
  <!-- CONTENTdm or OAKS. -->

  <!-- Note that the addition of a new IIIF-participant who is not using OAKS or -->
  <!-- CONTENTdm will mandate the update of this code.                           -->

  <xsl:template match="oai_qdc:qualifieddc">
    <xsl:copy>
        <xsl:attribute name="xsi:schemaLocation">http://worldcat.org/xmlschemas/qdc-1.0/  http://worldcat.org/xmlschemas/qdc/1.0</xsl:attribute>

        <xsl:apply-templates/>
        <xsl:choose>
           <xsl:when test="(starts-with(edm:rights, 'http://rightsstatements.org/vocab/NoC-US/') or
                            starts-with(edm:rights, 'http://creativecommons.org/publicdomain/mark/') or
                            starts-with(edm:rights, 'http://creativecommons.org/publicdomain/zero/') or
                            starts-with(edm:rights, 'http://creativecommons.org/licenses/by/') or
                            starts-with(edm:rights, 'http://creativecommons.org/licenses/by-sa/')
                           ) and (
                            ../../header/setSpec[text()]='clevepl_p128201coll0' or
                            ../../header/setSpec[text()]='clevepl_p16014coll17' or
                            ../../header/setSpec[text()]='clevepl_p16014coll23' or
                            ../../header/setSpec[text()]='clevepl_p16014coll24' or
                            ../../header/setSpec[text()]='clevepl_p16014coll6' or
                            ../../header/setSpec[text()]='clevepl_p4014coll10' or
                            ../../header/setSpec[text()]='clevepl_p4014coll12' or
                            ../../header/setSpec[text()]='clevepl_p4014coll13' or
                            ../../header/setSpec[text()]='clevepl_p4014coll14' or
                            ../../header/setSpec[text()]='clevepl_p4014coll18' or
                            ../../header/setSpec[text()]='clevepl_p4014coll20' or
                            ../../header/setSpec[text()]='clevepl_p4014coll24' or
                            ../../header/setSpec[text()]='clevepl_p4014coll25' or
                            ../../header/setSpec[text()]='clevepl_p4014coll27' or
                            ../../header/setSpec[text()]='clevepl_p4014coll9' or
                            ../../header/setSpec[text()]='kent_allenevents' or
                            ../../header/setSpec[text()]='kent_allenimages' or
                            ../../header/setSpec[text()]='kent_amag' or
                            ../../header/setSpec[text()]='kent_asylum' or
                            ../../header/setSpec[text()]='kent_brainchild' or
                            ../../header/setSpec[text()]='kent_cpmyearbooks' or
                            ../../header/setSpec[text()]='kent_epar' or
                            ../../header/setSpec[text()]='kent_fashion' or
                            ../../header/setSpec[text()]='kent_fusion' or
                            ../../header/setSpec[text()]='kent_grimshaw' or
                            ../../header/setSpec[text()]='kent_icon' or
                            ../../header/setSpec[text()]='kent_ijfae' or
                            ../../header/setSpec[text()]='kent_kaleidoscope' or
                            ../../header/setSpec[text()]='kent_ksumuseum' or
                            ../../header/setSpec[text()]='kent_ksuscp' or
                            ../../header/setSpec[text()]='kent_mccurdy' or
                            ../../header/setSpec[text()]='kent_museumvideo' or
                            ../../header/setSpec[text()]='kent_ohiohistory' or
                            ../../header/setSpec[text()]='kent_platypus' or
                            ../../header/setSpec[text()]='kent_sanbornmaps' or
                            ../../header/setSpec[text()]='kent_soacatalogs' or
                            ../../header/setSpec[text()]='kent_theburr' or
                            ../../header/setSpec[text()]='kent_wcr' or
                            ../../header/setSpec[text()]='kent_winecentral' or
                            ../../header/setSpec[text()]='kent_winecompetition' or
                            ../../header/setSpec[text()]='kent_winehofphotos' or
                            ../../header/setSpec[text()]='kent_winelabels' or
                            ../../header/setSpec[text()]='kent_wineneinland' or
                            ../../header/setSpec[text()]='kent_winenw' or
                            ../../header/setSpec[text()]='kent_winenwlakeerie' or
                            ../../header/setSpec[text()]='kent_winese' or
                            ../../header/setSpec[text()]='kent_winesw' or
                            ../../header/setSpec[text()]='midpointe_p16488coll13' or
                            ../../header/setSpec[text()]='midpointe_p16488coll5' or
                            ../../header/setSpec[text()]='ohiou_p15808coll1' or
                            ../../header/setSpec[text()]='ohmem_p15005coll2' or
                            ../../header/setSpec[text()]='ohmem_p15005coll36' or
                            ../../header/setSpec[text()]='ohmem_p16007coll11' or
                            ../../header/setSpec[text()]='ohmem_p16007coll12' or
                            ../../header/setSpec[text()]='ohmem_p16007coll13' or
                            ../../header/setSpec[text()]='ohmem_p16007coll17' or
                            ../../header/setSpec[text()]='ohmem_p16007coll20' or
                            ../../header/setSpec[text()]='ohmem_p16007coll21' or
                            ../../header/setSpec[text()]='ohmem_p16007coll25' or
                            ../../header/setSpec[text()]='ohmem_p16007coll33' or
                            ../../header/setSpec[text()]='ohmem_p16007coll35' or
                            ../../header/setSpec[text()]='ohmem_p16007coll47' or
                            ../../header/setSpec[text()]='ohmem_p267401ccp2' or
                            ../../header/setSpec[text()]='ohmem_p267401cdi' or
                            ../../header/setSpec[text()]='tlcpl_p16007coll88'
                           )">

                <xsl:variable name="tokens" select="tokenize(edm:isShownAt, '/')"/>
                <xsl:choose>
                    <!-- viable CONTENTdm record -->
                    <xsl:when test="contains(edm:isShownAt, '/cdm/ref/collection/')">
                        <xsl:element name="dcterms:isReferencedBy" namespace="http://purl.org/dc/terms/">{$tokens[1]}//{$tokens[3]}/iiif/info/{$tokens[7]}/{$tokens[9]}/manifest.json</xsl:element>
                    </xsl:when>
                    <!-- viable OAKS record -->
                    <xsl:when test="contains(../../header/identifier, ':oaks.kent.edu:node-')">
                        <xsl:variable name="nodeIdString" select="tokenize(../../header/identifier, '-')"/>
                        <xsl:element name="dcterms:isReferencedBy" namespace="http://purl.org/dc/terms/">{$tokens[1]}//{$tokens[3]}/node/{$nodeIdString[last()]}/manifest</xsl:element>
                    </xsl:when>
                 </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
          <!-- not eligible...create null element -->
              <xsl:element name="dcterms:isReferencedBy" namespace="http://purl.org/dc/terms/"/>
          </xsl:otherwise>
       </xsl:choose>

    </xsl:copy>
  </xsl:template>


  <xsl:template match="/OAI-PMH/ListRecords">
    <xsl:copy>
        <xsl:attribute name="xsi:schemaLocation">http://worldcat.org/xmlschemas/qdc-1.0/ http://worldcat.org/xmlschemas/qdc/1.0/qdc-1.0.xsd http://purl.org/net/oclcterms http://worldcat.org/xmlschemas/oclcterms/1.4/oclcterms-1.4.xsd</xsl:attribute>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
