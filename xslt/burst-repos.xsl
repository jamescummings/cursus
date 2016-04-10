<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:output indent="yes"/>
<xsl:strip-space elements="*" />

<xsl:template match="/">
<xsl:apply-templates />
</xsl:template>

<!-- things to exclude -->
<xsl:template match="teiHeader|witList|@TEIform|comment()|processing-instruction()"/>

<xsl:template match="/CURSUS|text|body">
<xsl:apply-templates />
</xsl:template>

<xsl:template match="ant|res|prayer">
<xsl:result-document href="{concat(@id,'.xml')}">
<xsl:copy> 
<xsl:if test="preceding-sibling::*[1]/@id">
<xsl:attribute name="previd"><xsl:value-of select="preceding-sibling::*[1]/@id"/></xsl:attribute>
</xsl:if>
<xsl:if test="following-sibling::*[1]/@id">
<xsl:attribute name="nextid"><xsl:value-of select="following-sibling::*[1]/@id"/></xsl:attribute>
</xsl:if>
<xsl:apply-templates select="node()|@*" />
</xsl:copy>
</xsl:result-document>
</xsl:template>

<xsl:template match="node()|@*" priority="-1">
<xsl:copy>
<xsl:apply-templates select="node()|@*"/>
</xsl:copy>
</xsl:template>

</xsl:stylesheet>
