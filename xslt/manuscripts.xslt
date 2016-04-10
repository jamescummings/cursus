<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" />

<xsl:variable name="document-root">/home/richard/uea/cursus</xsl:variable>

<xsl:template match="/">
  <html>
    <head>
      <title>CURSUS: Manuscript Information</title>
      <link rel="Stylesheet" type="text/css" href="/css/cursus-ed.css"/>
    </head>
    <body>
      <h1>Manuscript Information</h1>
      <xsl:apply-templates/>
    </body>
  </html>
</xsl:template>

<xsl:variable name="feasts" select="document(concat($document-root, '/content/cantus/feast.xml'))"/>

<xsl:template match="witList" >
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="witness">
  <h3><xsl:value-of select="@shortname"/></h3>
  <ul>
    <li><span class="heading">Manuscript Sigil:</span><xsl:text> </xsl:text> <xsl:value-of select="@sigil"/></li>
    <li><span class="heading">Manuscript Short Name:</span><xsl:text> </xsl:text>  <xsl:value-of select="@shortname"/></li>
    <li><span class="heading">Manuscript Filename:</span><xsl:text> </xsl:text>  <xsl:value-of select="@filename"/></li>
    <xsl:if test="@filename != 'none'">
      <li><span class="heading">Manuscript URL:</span> <xsl:text> </xsl:text>  
      <a href="/ms/{substring-before(@filename, '.')}">/ms/<xsl:value-of select="substring-before(@filename, '.')"/></a>
      </li>
      <li><span class="heading">Range of Manuscript Edited:</span><xsl:text>  </xsl:text> 
      <xsl:variable name="firstcode" select="document(concat($document-root, '/content/mss/', @filename))//*[@code][1]/@code"/>
      <xsl:variable name="lastcode" select="document(concat($document-root, '/content/mss/', @filename))//*[@code][position()=last()]/@code"/>
      <xsl:value-of select="$feasts//feast[feastCode=$firstcode]/occasion"/> until 
      <xsl:value-of select="$feasts//feast[feastCode=$lastcode]/occasion"/> 
      </li>
    </xsl:if>
    <li><span class="heading">Manuscript Details: </span> <xsl:text> </xsl:text> 
    <p class="msdetails"><xsl:apply-templates /></p>
    </li>
  </ul>
</xsl:template>

<xsl:template match="div">
  <h2><xsl:value-of select="@desc"/></h2>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="*" priority="-1">
  <span class="{name()}"><xsl:apply-templates/></span>
</xsl:template>

</xsl:stylesheet>
