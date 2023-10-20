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

<xsl:output method="text" encoding="UTF-8"/>

<!-- NOTE TO SELF:  This "SETSPEC" parameter is particularly non-descriptive in this context, and the code should be cleaned up
                    to make it less awful from a readability perspective
-->

<xsl:param name="SETSPEC"/>

<!--

PrintMultipleSetNames.xsl

Input:  ListSets.xml


Receives a string parameter with one or multiple setSpecs, return the set description for each setSpec received

MySQL contains a list of harvested setSpecs and the URLs they were harvested from.  This information is in the "source" record.
This XSLT allows us to "SELECT oaiSet from source where oaiSource=...whatever the user submits.  We can pass that MySQL output to this XSLT as a parameter and easily (relatively) identify the not-yet-harvested sets on this server and display their details.


java net.sf.saxon.Transform -xsl:GetSetName.xsl -s:ListSets.xml SETSPEC='boris'
borisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisborisboris
pkukla@symfony:~/tmp4/x$

-->

  <xsl:template match="@*|text()"/>

  <xsl:template match="/*:OAI-PMH/*:ListSets">
    <xsl:for-each select="*:set">
      <xsl:sort select="*:setSpec"/>
<!-- <xsl:value-of select="*:setSpec"/><xsl:text>
</xsl:text>
-->
<!-- from https://stackoverflow.com/questions/1007018/xslt-expression-to-check-if-variable-belongs-to-set-of-elements -->
      <xsl:choose>
        <xsl:when test="contains(
                           concat(' ', $SETSPEC, ' '),
                           concat(' ', normalize-space(*:setSpec), ' ')
                         )">
 <!--     <xsl:for-each select="tokenize($SETSPEC, ' ')">
 -->

         <xsl:value-of select="concat('Item ', *:setSpec, ' IS in the list.')"/> <!-- <./*:setDescription"/> -->
<xsl:text>
</xsl:text>
     <!-- <xsl:value-of select="$SETSPEC"/><xsl:text>|||</xsl:text><xsl:value-of select="//*:set/setSpec"/>
      -->
        </xsl:when>
        <xsl:otherwise>
         <xsl:value-of select="concat('Item ', *:setSpec, ' IS NOT in the list.')"/> <!-- <./*:setDescription"/> -->
<xsl:text>
</xsl:text>

        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

<!--  <xsl:template match='*:set'>
    <xsl:if test="./*:setSpec = $SETSPEC">
      <xsl:value-of select="./*:setName"/>
    </xsl:if>
    <xsl:value-of select="$SETSPEC"/>
  </xsl:template>
-->


</xsl:stylesheet>


