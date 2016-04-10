<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon">
<xsl:output method="xml" />
<xsl:template match="/">
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="CURSUS">
<CURSUS>
  <!-- for each incipit that matches same text diff number, diff number same text, or diff number diff text, then create new incipit. -->
<xsl:for-each select="incipit[.=preceding-sibling::incipit][not(@num=preceding-sibling::incipit/@num)]|
incipit[not(.=preceding-sibling::incipit)][@num=preceding-sibling::incipit/@num]|
incipit[not(.=preceding-sibling::incipit)][not(@num=preceding-sibling::incipit/@num)]">
  <incipit num="{@num}" type="{@type}"><xsl:value-of select="."/></incipit>
</xsl:for-each>
</CURSUS>
</xsl:template>
</xsl:stylesheet>
