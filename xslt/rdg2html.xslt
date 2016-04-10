<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
		xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="exslt" >

<xsl:output indent="yes"/>

<xsl:strip-space elements="*" />

<xsl:param name="wit"/>

<xsl:variable name="document-root">/home/richard/uea/cursus</xsl:variable>
<xsl:variable name="id"><xsl:value-of select="//ant/@id|//res/@id|//prayer/@id"/></xsl:variable>
<xsl:variable name="mss" select="document(concat($document-root, '/content/mss/mss.xml'))"/>
<xsl:variable name="msname" select="$mss//witness[@sigil=$wit]/@shortname"/>

<!-- match root element -->
<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="/ant|/res|/prayer">
  <xsl:variable name="rootname">
    <xsl:choose>
      <xsl:when test="name()='ant'"> Antiphon </xsl:when>
      <xsl:when test="name()='res'"> Respond </xsl:when>
      <xsl:when test="name()='prayer'"> Prayer </xsl:when>
      <xsl:otherwise> Item </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <html>
    <head>
      <title>Reading of <xsl:value-of select="$id"/> according to <xsl:value-of select="$msname"/></title>
      <link href="/css/cursus-ed.css" type="text/css" rel="stylesheet"> </link>
    </head>
    <body>
      <h1>Reading of <xsl:value-of select="$id"/> according to
      <xsl:value-of select="$msname"/></h1>
      <div class="readingbuttons">
	<xsl:variable name="unique-wit-list">
	  <xsl:call-template name="unique-token-list">
	    <xsl:with-param name="str">
	      <xsl:for-each select="//aBody|//rBody|//pBody">
		<xsl:text> </xsl:text> <xsl:value-of select="@wit"/><xsl:text> </xsl:text>
	      </xsl:for-each>
	    </xsl:with-param>
	  </xsl:call-template>
	</xsl:variable>
	<form action="{concat('/ind/', $id)}" >
	  See just the reading for:  
	  <select name="wit" onchange="this.form.submit()">
	    <xsl:for-each select="exslt:node-set($unique-wit-list)/*">
	      <xsl:sort select="name()"/>
	      <xsl:variable name="sigil" select="name()"/>
	      <xsl:variable name="shortname" select="$mss//witness[@sigil=$sigil]/@shortname"/>
	      <option value="{name()}"><xsl:value-of select="$shortname"/></option>
	    </xsl:for-each>
	  </select>
	  <input type="submit" value=" Change"/>
	</form>
	<!--<form action="{concat('/ed/', $id)}">
	  <input type="submit" value="Critical Edition"/>
	</form>-->
	<a href="{concat('/ed/', $id)}">Critical Edition</a>
	<span class="views">
	  <a class="source" href="/edxml/{@id}">XML source of <xsl:value-of select="$rootname"/> <xsl:value-of select="@id"/></a><br />
	  <xsl:if test="@previd">
	    <a class="left" href="/ed/{@previd}">Previous <xsl:value-of select="$rootname"/> (<xsl:value-of select="@previd"/>) </a>
	  <xsl:text> | </xsl:text></xsl:if>
	  <xsl:if test="@nextid">
	    <a class="right" href="/ed/{@nextid}">Next <xsl:value-of select="$rootname"/> (<xsl:value-of select="@nextid"/>) </a>
	  </xsl:if>
	</span>
      </div>
      <hr />
      <xsl:apply-templates/>

      <hr />
      <!--     <span class="views">
	   Orthogonal views:
	   <a href="{concat($id,'?cocoon-view=content')}">Content</a><xsl:text>  </xsl:text>
	   <a href="{concat($id,'?cocoon-view=pretty-content')}">Pretty content</a><xsl:text>  </xsl:text>
	   </span> -->
    </body>
  </html>
</xsl:template>

<xsl:template name="unique-token-list">
  <xsl:param name="str"/>
  <xsl:param name="nl"/>
  <xsl:variable name="token" 
		select="substring-before(concat(normalize-space($str), ' '), ' ')"/>
  <xsl:choose>
    <xsl:when test="string-length($token) > 0">
      <xsl:call-template name="unique-token-list">
	<xsl:with-param name="str" select="substring-after($str, $token)"/>
	<xsl:with-param name="nl">
	  <xsl:copy-of select="exslt:node-set($nl)/*"/>
	  <xsl:if test="count(exslt:node-set($nl)/*[name()=$token]) = 0">
	    <xsl:element name="{$token}"/>
	  </xsl:if>
	</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="exslt:node-set($nl)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="CURSUS">
  <xsl:apply-templates/>
</xsl:template>

<!-- things to exclude -->
<xsl:template match="teiHeader|witList|@TEIform">
</xsl:template>

<!-- Basic Span -->
<xsl:template match="l">
  <span class="{name()}"><xsl:apply-templates /></span>
</xsl:template>

<!-- Basic Div -->
<xsl:template match="verses|verse">
  <div class="{name()}"><xsl:apply-templates /></div>
</xsl:template>

<!-- Things where we want just the tag to disappear -->
<xsl:template match="div">
  <xsl:apply-templates />
</xsl:template>

<!-- Change gap to [...] -->
<xsl:template match="gap|unclear">
  <span class="{name()}"><xsl:attribute name="title"> <xsl:value-of select="name()"/>: <xsl:if test="@reason"> <xsl:value-of select="@reason"/><xsl:text> - </xsl:text></xsl:if><xsl:if test="@extent"> <xsl:value-of select="@extent"/><xsl:text> - </xsl:text></xsl:if> <xsl:if test="@resp"> <xsl:value-of select="@resp"/></xsl:if></xsl:attribute>
  <xsl:text>[...]</xsl:text></span>
</xsl:template>

<xsl:template match="corr|sic">
  <span class="{name()}">
    <xsl:attribute name="title"><xsl:value-of select="name()"/>:  <xsl:if test="@sic"> <xsl:value-of select="@sic"/></xsl:if>
    <xsl:if test="@corr"> <xsl:value-of select="@corr"/></xsl:if> 
    <xsl:if test="@resp"> (<xsl:value-of select="@resp"/>)</xsl:if></xsl:attribute>
  <xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="del">
  <span class="del">
    <xsl:attribute name="title"><xsl:value-of select="name()"/>: <xsl:if test="@type"> <xsl:value-of select="@type"/><xsl:text>  </xsl:text></xsl:if>
    <xsl:if test="@rend"> <xsl:value-of select="@rend"/><xsl:text>  </xsl:text></xsl:if> 
    <xsl:if test="@hand"> <xsl:value-of select="@hand"/><xsl:text>  </xsl:text></xsl:if> 
    <xsl:if test="@resp">(<xsl:value-of select="@resp"/>)</xsl:if></xsl:attribute>
  <xsl:apply-templates/></span>
</xsl:template>


<xsl:template match="prosula">
  <div class="prosula"><span class="{concat(name(),'glyph')}"><xsl:value-of select="name()"/></span><span class="prosulawits">(<xsl:value-of select="$wit"/>)</span><span class="prosulaBody"><xsl:apply-templates /></span></div>
</xsl:template>

<xsl:template match="rep|dox">
  <div class="{name()}"><span class="{concat(name(),'glyph')}"><xsl:value-of select="name()"/>.</span><span class="{concat(name(), 'wits')}"><xsl:value-of select="$wit"/>:</span><xsl:apply-templates /></div>
</xsl:template>

<xsl:template match="app">
  <table class="app"><xsl:apply-templates /></table>
</xsl:template>

<xsl:template match="rdg">
  <tr class="rdg"><td class="rdgwits"><xsl:value-of select="$wit"/>:</td><td><xsl:apply-templates /></td></tr>
</xsl:template>

<xsl:template match="aBody">
  <div class="ant"><span class="antglyph">A.</span><span class="aBodywits"><xsl:value-of select="$wit"/>:</span><span class="aBody"><xsl:apply-templates /></span></div>
</xsl:template>

<xsl:template match="rBody">
  <div class="res"><span class="resglyph">R.</span><span class="rBodywits"><xsl:value-of select="$wit"/>:</span><span class="rBody"><xsl:apply-templates /></span></div>
</xsl:template>

<xsl:template match="vBody">
  <div class="verses"><span  class="verseglyph">V.</span><span class="vBodywits"><xsl:value-of select="$wit"/>:</span><span class="vBody"><xsl:apply-templates /></span></div>
</xsl:template>

<xsl:template match="pBody">
  <div class="prayer"><span class="prayerglyph">O.</span><span class="pBodywits"><xsl:value-of select="$wit"/>:</span><span class="pBody"><xsl:apply-templates /></span></div>
</xsl:template>

<xsl:template match="rubric">
  <span class="{concat('rubric-',@type)}"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="note">
  <span class="note" title="{concat('Note: ', .)}">[NOTE]</span>
</xsl:template>

<xsl:template match="hi">
  <span class="@rend"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="supplied">
  <span class="supplied"><xsl:attribute name="title"><xsl:value-of select="name()"/>: <xsl:if test="@resp">(<xsl:value-of select="@resp"/>)</xsl:if></xsl:attribute><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="ref">
  <a class="ref" href="{concat(@target, '.html')}"><xsl:apply-templates/></a>
</xsl:template>

<xsl:template match="ant|res|prayer">
  <xsl:apply-templates />
</xsl:template>

</xsl:stylesheet>
