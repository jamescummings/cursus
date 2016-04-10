<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:param name="wit"/>

<xsl:output indent="yes"/>

<xsl:strip-space elements="*" />

<xsl:template match="/">
  <xsl:apply-templates >
    <xsl:with-param name="wit" select="$wit"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="aBody|rBody|pBody|vBody|rep|dox" >
  <xsl:param name="wit" />
  <xsl:if test="contains(concat(' ', @wit, ' '), concat(' ', $wit, ' '))">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*">
	<xsl:with-param name="wit" select="$wit"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="app" >
  <xsl:param name="wit" />
  <xsl:text> </xsl:text>
  <xsl:apply-templates >
    <xsl:with-param name="wit" select="$wit"/>
  </xsl:apply-templates>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="rdg" >
  <xsl:param name="wit"/>
  <xsl:if test="contains(concat(' ',@wit,' '), concat(' ',$wit, ' '))">
    <xsl:text> </xsl:text><xsl:apply-templates  /><xsl:text> </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="node()|@*" priority="-1">
  <xsl:copy><xsl:apply-templates select="node()|@*">
    <xsl:with-param name="wit" select="$wit"/>
  </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
