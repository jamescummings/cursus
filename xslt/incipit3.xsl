<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" />
<xsl:template match="/">
<CURSUS>
    <xsl:apply-templates />
</CURSUS>
</xsl:template>
<!-- match root element -->
<xsl:template match="/CURSUS">
    <xsl:apply-templates />
</xsl:template>

<!-- tokenize -->
<xsl:template match="ant/aBody[node()]">
  <incipit type="a" wit="{@wit}" num="{../@id}">   
 <xsl:for-each select="tokenize(., ' ')[position() &lt;=10]">
       <xsl:value-of select="." /><xsl:text> </xsl:text> 
    </xsl:for-each>
    <xsl:text>...</xsl:text>
</incipit>
</xsl:template>

<xsl:template match="res/rBody[node()]">
      <incipit type="r"  wit="{@wit}" num="{../@id}"> 
 <xsl:for-each select="tokenize(., ' ')[position() &lt;=10]">
<xsl:value-of select="." /><xsl:text> </xsl:text> 
    </xsl:for-each>
    <xsl:text>...</xsl:text>
</incipit>
</xsl:template>

<xsl:template match="prayer/pBody[node()]">
      <incipit type="p"  wit="{@wit}" num="{../@id}">
 <xsl:for-each select="tokenize(., ' ')[position() &lt;=10]">
 <xsl:value-of select="." /><xsl:text> </xsl:text> 
    </xsl:for-each>
    <xsl:text>...</xsl:text>
</incipit>
</xsl:template>

</xsl:stylesheet>
