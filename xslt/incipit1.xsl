<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon">
<xsl:output method="xml" />
<xsl:template match="/">
<CURSUS>
    <xsl:apply-templates />
</CURSUS>
</xsl:template>

<!-- match root element -->
<xsl:template match="/CURSUS|div">
    <xsl:apply-templates />
</xsl:template>

<!-- things to exclude -->
<xsl:template match="teiHeader|witList|@TEIform|vBody|note|prosula|verses|rep|dox|rubric|header|usage">
</xsl:template>

<xsl:template match="/CURSUS/text/body/witList|ant|res|prayer">
<xsl:copy><xsl:apply-templates select="node()|@*"/></xsl:copy>
</xsl:template>

<xsl:template match="node()|@*" priority="-1">
<xsl:copy><xsl:apply-templates select="node()|@*"/></xsl:copy>
</xsl:template>


<!-- Change gap to [...] -->
<xsl:template match="gap">
  <xsl:text>[...]</xsl:text>
</xsl:template>


<!-- Things where we want just the tag to disappear -->
<xsl:template match="corr|del|hi|l|ref|sic|supplied|unclear|verse|div">
<xsl:apply-templates />
</xsl:template>



</xsl:stylesheet>



