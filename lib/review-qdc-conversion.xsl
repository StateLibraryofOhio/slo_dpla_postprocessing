<xsl:stylesheet
     version="2.0"
     xmlns:qdc="http://worldcat.org/xmlschemas/qdc-1.0/" 
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:oai="http://www.openarchives.org/OAI/2.0/"
     xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
     xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:dcterms="http://purl.org/dc/terms/"
     xmlns:edm="http://www.europeana.eu/schemas/edm/"
     exclude-result-prefixes="oai oai_dc edm dc dcterms">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/oai:OAI-PMH">
    <full>
        <xsl:for-each select="oai:ListRecords/oai:record[not(oai:header/@status='deleted')]">
            <record>

                <!-- Look for missing EDM:DataProvider values -->

                <xsl:choose>

                    <xsl:when test="oai:metadata/qdc:qualifieddc/edm:dataProvider[text()]">
                        <xsl:for-each select="oai:metadata/qdc:qualifieddc/edm:dataProvider">
                            <xsl:choose>
                                <xsl:when test="normalize-space(.) != ''">
                                    <dataProvider>
                                        <xsl:value-of select="." />
                                    </dataProvider>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>

                    </xsl:when>

                    <xsl:when test="oai:metadata/oai_dc:dc[not(edm.dataProvider)]">
                        <ALERT>MISSING ELEMENT:  no edm:dataProvider element in this record</ALERT>
                    </xsl:when>

                    <xsl:when test="not(oai:metadata/qdc:qualifieddc/edm:dataProvider[text()])">
                        <ALERT>MISSING VALUE:  no edm:dataProvider metadata in this record</ALERT>
                    </xsl:when>

                </xsl:choose>

                <xsl:if test="count(oai:metadata/qdc:qualifieddc/edm:dataProvider) gt 1">
                     <ALERT>MULTIPLE OCCURRENCE ERROR:  edm:dataProvider occurs more than 1 time in this record</ALERT>
                </xsl:if>

                <!-- Look for missing edm:isShownAt values -->

                <xsl:choose>

                    <xsl:when test="oai:metadata/qdc:qualifieddc/edm:isShownAt[text()]">
                        <xsl:for-each select="oai:metadata/qdc:qualifieddc/edm:isShownAt">
                            <xsl:choose>
                                <xsl:when test="normalize-space(.) != ''">
                                    <isShownAt>
                                        <xsl:value-of select="." />
                                    </isShownAt>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>

                    </xsl:when>

                    <xsl:when test="oai:metadata/oai_dc:dc[not(edm:isShownAt)]">
                        <ALERT>MISSING ELEMENT:  NO edm:isShownAt ELEMENTS</ALERT>
                    </xsl:when>

                    <xsl:when test="not(oai:metadata/qdc:qualifieddc/edm:isShownAt[text()])">
                        <ALERT>MISSING VALUE:  NO edm:isShownAt METADATA</ALERT>
                    </xsl:when>

                </xsl:choose>

                <xsl:if test="count(oai:metadata/qdc:qualifieddc/edm:isShownAt) gt 1">
                     <ALERT>MULTIPLE OCCURRENCE ERROR:  edm:isShownAt occurs more than 1 time in this record</ALERT>
                </xsl:if>


                <!-- Look for missing edm:preview values -->

                <xsl:choose>

                    <xsl:when test="oai:metadata/qdc:qualifieddc/edm:preview[text()]">
                        <xsl:for-each select="oai:metadata/qdc:qualifieddc/edm:preview">
                            <xsl:choose>
                                <xsl:when test="normalize-space(.) != ''">
                                    <preview>
                                        <xsl:value-of select="." />
                                    </preview>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>

                    </xsl:when>

                    <xsl:when test="oai:metadata/oai_dc:dc[not(edm:preview)]">
                        <ALERT>MISSING ELEMENT:  NO edm:preview ELEMENTS</ALERT>
                    </xsl:when>

                    <xsl:when test="not(oai:metadata/qdc:qualifieddc/edm:preview[text()])">
                        <ALERT>MISSING VALUE:  NO edm:preview METADATA</ALERT>
                    </xsl:when>

                </xsl:choose>

                <xsl:if test="count(oai:metadata/qdc:qualifieddc/edm:preview) gt 1">
                     <ALERT>MULTIPLE OCCURRENCE ERROR:  edm:preview occurs more than 1 time in this record</ALERT>
                </xsl:if>



                <!-- Look for missing edm:rights values -->
                <!-- Note: name collection with dc:rights -->

                <xsl:choose>

                    <xsl:when test="oai:metadata/qdc:qualifieddc/edm:rights[text()]">
                        <xsl:for-each select="oai:metadata/qdc:qualifieddc/edm:rights">
                            <xsl:choose>
                                <xsl:when test="normalize-space(.) != ''">
                                    <edm-rights>
                                        <xsl:value-of select="normalize-space(.)" />
                                    </edm-rights>
                                    <xsl:if test="not(starts-with(normalize-space(.), 'http'))">
                                        <ALERT>INCORRECT FORMAT ERROR:  edm:rights should begin with "http", but does not</ALERT>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>

                    </xsl:when>

                    <xsl:when test="oai:metadata/oai_dc:dc[not(edm:rights)]">
                        <ALERT>MISSING VALUE:  NO edm:rights ELEMENTS</ALERT>
                    </xsl:when>

                    <xsl:when test="not(oai:metadata/qdc:qualifieddc/edm:rights[text()])">
                        <ALERT>MISSING VALUE:  NO edm:rights METADATA</ALERT>
                    </xsl:when>

                </xsl:choose>

                <xsl:if test="count(oai:metadata/qdc:qualifieddc/edm:rights) gt 1">
                     <ALERT>MULTIPLE OCCURRENCE ERROR:  edm:rights occurs more than 1 time in this record</ALERT>
                </xsl:if>


                <!-- Look for missing dcterms:title values -->

                <xsl:choose>

                    <xsl:when test="oai:metadata/qdc:qualifieddc/dcterms:title[text()]">
                        <xsl:for-each select="oai:metadata/qdc:qualifieddc/dcterms:title">
                            <xsl:choose>
                                <xsl:when test="normalize-space(.) != ''">
                                    <title>
                                        <xsl:value-of select="." />
                                    </title>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>

                    </xsl:when>

                    <xsl:when test="oai:metadata/oai_dc:dc[not(dcterms:title)]">
                        <ALERT>MISSING VALUE:  NO dcterms:title ELEMENTS</ALERT>
                    </xsl:when>

                    <xsl:when test="not(oai:metadata/qdc:qualifieddc/dcterms:title[text()])">
                        <ALERT>MISSING VALUE:  NO dcterms:title METADATA</ALERT>
                    </xsl:when>

                </xsl:choose>



                <!-- Look for missing dcterms:type values -->
               
                <xsl:choose>

                    <xsl:when test="oai:metadata/qdc:qualifieddc/dcterms:type[text()]"> 
                        <xsl:for-each select="oai:metadata/qdc:qualifieddc/dcterms:type">
                            <xsl:choose>
                                <xsl:when test="normalize-space(.) != ''">
                                    <type>
                                        <xsl:value-of select="." />
                                    </type>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>

                    </xsl:when>

                    <xsl:when test="oai:metadata/oai_dc:dc[not(dcterms:type)]">
                        <ALERT>MISSING VALUE:  NO dcterms:type ELEMENTS</ALERT>
                    </xsl:when>

                    <xsl:when test="not(oai:metadata/qdc:qualifieddc/dcterms:type[text()])">
                        <ALERT>MISSING VALUE:  NO dcterms:type METADATA</ALERT>
                    </xsl:when>

                </xsl:choose>




                <!-- Look for dc:date values that are using the ISO-8601 format -->

                <xsl:choose>

                    <xsl:when test="oai:metadata/qdc:qualifieddc/dc:date[text()]">
                        <xsl:for-each select="oai:metadata/qdc:qualifieddc/dc:date">
                            <xsl:choose>
                                <xsl:when test="normalize-space(.) != ''">
                                    <date>
                                        <xsl:value-of select="." />
                                    </date>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>

                </xsl:choose>


            </record>
        </xsl:for-each>     
    </full>
</xsl:template>

</xsl:stylesheet>
