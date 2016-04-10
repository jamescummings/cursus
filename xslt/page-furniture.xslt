<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:variable name="document-root">/home/richard/uea/cursus</xsl:variable>

<xsl:variable name="css">
  <xsl:choose>
    <xsl:when test="/html/head/link[@type='text/css']">
      <xsl:value-of select="/html/head/link[@type='text/css']/@href"/>
    </xsl:when>
    <xsl:otherwise>/css/cursus.css</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="title">
  <xsl:choose>
    <xsl:when test="/html/head/title">
      CURSUS Project: <xsl:value-of select="/html/head/title"/>
    </xsl:when>
    <xsl:otherwise>CURSUS Project</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="html">
  <html>
    <head>
      <link rel="Stylesheet" type="text/css" href="{$css}" />
      <title><xsl:value-of select="$title"/></title>
    </head>
    <xsl:apply-templates select="body" />
  </html>
</xsl:template>

<xsl:template match="body">
  <body>
    <xsl:copy-of select="document(concat($document-root, '/content/header.xml'))"/>
    <xsl:copy-of select="document(concat($document-root, '/content/sidebar.xml'))"/>
    <div class="main">
      <xsl:apply-templates/>
      <xsl:copy-of select="document(concat($document-root, '/content/footer.xml'))"/>
    </div>
  </body>
</xsl:template>

<xsl:template match="html/head">
</xsl:template>


<xsl:template match="node()|@*|text()" priority="-1">
  <xsl:copy><xsl:apply-templates select="node()|@*|text()"/></xsl:copy>
</xsl:template>

</xsl:stylesheet>
