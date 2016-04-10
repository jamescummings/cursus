<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output indent="yes"/>

<xsl:strip-space elements="*" />

<xsl:param name="ref"/>

<xsl:variable name="bookName" select="/CURSUS/text/@n"/>
<xsl:variable name="vulgateID"><xsl:value-of select="concat('B.', $bookName, '.', $ref)"/></xsl:variable>
<xsl:variable name="refnode" select="//verse[@id = $vulgateID]"/>

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="$refnode">
      <xsl:copy-of select="$refnode"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="match-all"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="node()|@*" priority="-1" name="match-all">
  <xsl:copy><xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
