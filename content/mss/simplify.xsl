<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output indent="yes"/>
<xsl:strip-space elements="*" />

<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>

<!-- things to exclude -->
<xsl:template match="@TEIform|comment()|processing-instruction()">
</xsl:template>


<xsl:template match="node()|@*" priority="-1">
<xsl:copy><xsl:apply-templates select="node()|@*"/></xsl:copy>
</xsl:template>

</xsl:stylesheet>
