<xsl:stylesheet
  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:qdc="http://worldcat.org/xmlschemas/qdc-1.0/"
  xmlns:slo_diag="http://library.ohio.gov/xmlschemas/slo_diag-1.0/"
  exclude-result-prefixes="xs"
  xpath-default-namespace="http://library.ohio.gov/xmlschemas/slo_diag-1.0/"
  expand-text="yes">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>



<!--
     This XSLT is intended to parse through the "review-qdc-conversion-output.xml"
     generated by the "review-qdc-conversion.sh" script.

     The XSLT creates output that lists problems found by my basic QA testing of
     the data (e.g. "missing rights info")

     It should be improved to deal with multiple problems ("ALERT"s) occurring for
     a single record.   
-->


  <xsl:template match="text()|@*"/>


  <xsl:template match="/">
    <xsl:element name="ODN_report">
      <xsl:apply-templates select="//*:record"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="//*:record[./*:ALERT]">
    <!-- <xsl:copy-of select="." copy-namespaces='false' /> -->
    <xsl:element name="record">
      <xsl:apply-templates select="*:ALERT"/>
      <xsl:copy-of copy-namespaces="false" select="*:isShownAt"/>
      <xsl:element name="thumbnail"><xsl:value-of select="*:preview"/></xsl:element>
      <xsl:copy-of copy-namespaces="false" select="*:edm-rights"/>
      <xsl:copy-of copy-namespaces="false" select="*:title"/>
      <xsl:copy-of copy-namespaces="false" select="*:type"/>
      <xsl:element name="provider"><xsl:value-of select="*:dataProvider"/></xsl:element>

    </xsl:element>
  </xsl:template>


  <xsl:template match="*:ALERT">
    <xsl:for-each select="tokenize(., ';')">
      <xsl:if test="normalize-space(.) != ''">
        <xsl:element name="DataProblem">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>



</xsl:stylesheet>

