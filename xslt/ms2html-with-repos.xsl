<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"/>

<xsl:template match="/">
  <html> 
    <head>
      <title><xsl:value-of select="CURSUS/teiHeader/fileDesc/titleStmt/title[@type='main']"/></title>
      <link rel="Stylesheet" type="text/css" href="/css/cursus-mss.css"/>     
    </head>
    <body>
      <h2><xsl:value-of select="CURSUS/teiHeader/fileDesc/titleStmt/title[@type='main']"/></h2>
      <h2><xsl:value-of select="CURSUS/teiHeader/fileDesc/titleStmt/title[@type='sub']"/></h2>
      <div class="toc" id="toc">
	<span class="bold">Table of Contents:</span>
	<xsl:apply-templates select="/CURSUS/text/body/Day|/CURSUS/text/body/Week" mode="toc"/>
      </div>
      <xsl:apply-templates/>
    </body>
  </html>
</xsl:template>

<xsl:variable name="ms" select="/CURSUS/text/@n"/>            
<xsl:variable name="feasts" select="document('../content/cantus/feast.xml')"/>
<xsl:variable name="mss" select="document('../content/mss/mss.xml')"/>
<xsl:variable name="antiphons" select="document('../content/repository/repository.xml')"/>
<xsl:variable name="responds" select="document('../content/repository/repository.xml')"/>
<xsl:variable name="prayers" select="document('../content/repository/repository.xml')"/>

<xsl:template match="CURSUS|text|body" >
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="teiHeader|@TEIform|witList" />

<xsl:template match="Day | Week" mode="toc">
  <xsl:if test="@num='1'"><br /></xsl:if>
  <xsl:variable name="daycode" select="@code" />
  <xsl:variable name="occasion" select="$feasts//feast[feastCode=$daycode]/occasion"/>
  <xsl:variable name="desc" select="$feasts//feast[feastCode=$daycode]/description"/>
  <xsl:variable name="date" select="$feasts//feast[feastCode=$daycode]/date"/>
  <a href="{concat('#', $ms, '.',@code)}" title="Jump to {$desc} ({$occasion})"><xsl:value-of select="$occasion"/></a>
  <xsl:choose>
    <xsl:when test="@num='1'"><xsl:text>: </xsl:text></xsl:when>
    <xsl:when test="following-sibling::*[1]/@num='1'"><xsl:text>. </xsl:text></xsl:when>
    <xsl:otherwise><xsl:text>, </xsl:text></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="Day | Week">
  <xsl:variable name="daycode" select="@code" />
  <xsl:variable name="occasion" select="$feasts//feast[feastCode=$daycode]/occasion"/>
  <xsl:variable name="desc" select="$feasts//feast[feastCode=$daycode]/description"/>
  <xsl:variable name="date" select="$feasts//feast[feastCode=$daycode]/date"/>
  <div class="{name()}" id="{concat($ms, '.',@code)}" title="{$desc} ({$occasion}) with Day code of {@code}">
    <div class="DayHeader" title="DayHeader">
      <span class="feast" title="feast">
	<span class="headerTitle">Occasion:  </span>  
	<xsl:value-of select="$occasion"/></span><xsl:text>  </xsl:text>
	<span class="description" title="description"><span class="headerTitle">Description: </span>  <xsl:value-of select="$desc"/></span><xsl:text>  </xsl:text>
	<span class="code" title="code"><span class="headerTitle">Day Code: </span>  <xsl:value-of select="@code"/></span><xsl:text>  </xsl:text>
	<span class="navigation">
	  <xsl:if test="preceding-sibling::*[1]/@code"><span class="prev" title="Previous Day or Week element"> <a href="{concat('#', $ms, '.', preceding-sibling::*[1]/@code)}">Prev</a> </span><xsl:text>  </xsl:text> </xsl:if>
	  <span class="gototoc" title="Table of Contents"><a href="#toc">Table of Contents</a></span> <xsl:text>  </xsl:text>
	  <xsl:if test="following-sibling::*[1]/@code"><span class="next" title="Next Day or Week  element"> <a href="{concat('#', $ms, '.', following-sibling::*[1]/@code)}">Next</a></span></xsl:if>

	</span>
    </div>
    <xsl:apply-templates />
  </div>
</xsl:template>


<xsl:template match="service">
  <div class="{name()}" id="{concat($ms, '.',ancestor::*/@code,'-',@name)}" >
    <xsl:apply-templates />
  </div>
</xsl:template>

<xsl:template match="note">
  <span class="note" title="NB: {.}">[NOTE]</span><xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="supp|del|expan|sic">
  <span class="{name()}">
    <xsl:if test="@*"><xsl:attribute name="title"><xsl:value-of select="name()"/>
    <xsl:for-each select="./@*">
      <xsl:if test="name() != 'TEIform'"><xsl:text> - </xsl:text>
      <xsl:value-of select="name()"/><xsl:text>:</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>  </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:attribute>
    </xsl:if>
  <xsl:apply-templates /></span>
</xsl:template>


<xsl:template match="hi">
  <span class="{@rend}" >
    <xsl:if test="@*"><xsl:attribute name="title"><xsl:value-of select="name()"/>
    <xsl:for-each select="./@*">
      <xsl:if test="name() != 'TEIform'"><xsl:text> - </xsl:text>
      <xsl:value-of select="name()"/><xsl:text>:</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>  </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:attribute>
    </xsl:if>
  <xsl:apply-templates /></span>
</xsl:template>


<xsl:template match="gap|unclear">
  <span class="{name()}">
    <xsl:if test="@*"><xsl:attribute name="title"><xsl:value-of select="name()"/>
    <xsl:for-each select="./@*">
      <xsl:if test="name() != 'TEIform'"><xsl:text> - </xsl:text>
      <xsl:value-of select="name()"/><xsl:text>:</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>  </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:attribute>
    </xsl:if>
  <xsl:text>[...]</xsl:text></span>
</xsl:template>

<xsl:template match="*" priority="-10">
  <span class="{name()}">
    <xsl:if test="@*"><xsl:attribute name="title"><xsl:value-of select="name()"/>
    <xsl:for-each select="./@*">
      <xsl:if test="name() != 'TEIform'"><xsl:text> - </xsl:text>
      <xsl:value-of select="name()"/><xsl:text>:</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>  </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates />
  </span>
</xsl:template>


<xsl:template match="antiphon|biblical|prayer|chapter|invitatory|hymn"><xsl:text>  </xsl:text>
<div class="{name()}">
  <xsl:if test="@*"><xsl:attribute name="title"><xsl:value-of select="name()"/>
  <xsl:for-each select="./@*">
    <xsl:if test="name() != 'TEIform'"><xsl:text> - </xsl:text>
    <xsl:value-of select="name()"/><xsl:text>:</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>  </xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:attribute>
  </xsl:if>
  <xsl:apply-templates />
  </div><xsl:text>  </xsl:text>
</xsl:template>

<xsl:template match="milestone[@unit='page']">
  <hr class="right-hr" /><span class="pageNumber" title="page: {@n}">[<xsl:value-of select="@n" />]</span>
</xsl:template>


<xsl:template match="respond|lection|nocturn">
  <div class="{name()}" id="{concat($ms, '.', ancestor::Day/@code, '-', name(), '_', @num)}"><xsl:apply-templates /></div>

</xsl:template>

<xsl:template match="rubric">
  <span class="{concat(name(), '-', @type)}" >
    <xsl:apply-templates /></span><xsl:text>  </xsl:text>
</xsl:template>





<xsl:template match="incipit">
  <span class="incipit">
    <xsl:if test="@*"><xsl:attribute name="title"><xsl:value-of select="name()"/>
    <xsl:for-each select="./@*">
      <xsl:if test="name() != 'TEIform'"><xsl:text> - </xsl:text>
      <xsl:value-of select="name()"/><xsl:text>:</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>  </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:attribute>
    </xsl:if>
    <xsl:variable name="letter" select="@init" />
    <xsl:choose>
      <xsl:when test="@type='antiphon'">
	<!--  <xsl:variable name="letter" select="translate(substring(normalize-space(text()[normalize-space()]),1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/> -->
	<xsl:apply-templates/>
	<xsl:if test="@init">
	  <xsl:text> </xsl:text><a class="arrowlink" title="go to list of antiphon incipits starting with {$letter}" href="/incipits/{@type}s/{$letter}.html" >
	  <span class="arrow"><img src="/images/rarrow.gif" /></span>
	</a>  
	</xsl:if>
      </xsl:when>
      <xsl:when test="@type='respond'">
	<!--  <xsl:variable name="letter" select="translate(substring(normalize-space(text()[normalize-space()]),1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/> -->
	<xsl:apply-templates/>
	<xsl:if test="@init">
	  <xsl:text> </xsl:text><a class="arrowlink" title="go to list of respond incipits starting with {$letter}" href="/incipits/{@type}s/{$letter}.html" >
	  <span class="arrow"><img src="/images/rarrow.gif" /></span>
	</a>  
	</xsl:if>
      </xsl:when>
      <xsl:when test="@type='prayer'">
	<!--  <xsl:variable name="letter" select="translate(substring(normalize-space(text()[normalize-space()]),1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/> -->
	<xsl:apply-templates/> 
	<xsl:if test="@init">
	  <xsl:text> </xsl:text><a class="arrowlink" title="go to list of prayer incipits starting with {$letter}" href="/incipits/{@type}s/{$letter}.html" >
	  <span class="arrow"><img src="/images/rarrow.gif" /></span>
	</a>  
	</xsl:if>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </span>
</xsl:template>



<xsl:template match="xptr" priority="-1">
  <span class="xptr">
    <xsl:attribute name="title">An xptr of type <xsl:value-of select="@type"/> pointing to <xsl:value-of select="@from"/><xsl:if test="not(contains(@to, 'DITTO'))"> and pointing to <xsl:value-of select="@to"/></xsl:if></xsl:attribute>
    <xsl:choose>
      <xsl:when test="@type='aBody'">
	This XPTR looks in <xsl:value-of select="@href"/> for antiphon number:  
	<xsl:value-of select="substring-before(substring-after(@from, 'ID(' ), ')' )"/>
      </xsl:when>
      <xsl:when test="@type='rBody'">
	This XPTR looks in <xsl:value-of select="@href"/> for respond body number:  
	<xsl:value-of select="substring-before(substring-after(@from, 'ID(' ), ')' )"/><br/>
      </xsl:when>
      <xsl:when test="@type='rVerse'">
	This XPTR looks in <xsl:value-of select="@href"/> for respond verse number:  
	<xsl:value-of select="substring-before(substring-after(@from, 'ID(' ), ')' )"/>
      </xsl:when>
      <xsl:when test="@type='prayer'">
	This XPTR looks in <xsl:value-of select="@href"/> for prayer number:  
	<xsl:value-of select="substring-before(substring-after(@from, 'ID(' ), ')' )"/>
      </xsl:when>
      <xsl:when test="@type='bible'">
	This XPTR looks in <xsl:value-of select="@href"/> for biblical reading:  
	<xsl:if test="@from">
	  From: <xsl:value-of select="concat('B.', ../@src, '.', substring-before(substring-after(@from, 'ID('), ')'))"/>
	</xsl:if>
	<xsl:if test="contains(@from, 'PATTERN(')">
	  with a pattern of "<xsl:value-of select="substring-before(substring-after(@from, 'PATTERN('), ')')"/>".
	</xsl:if>
	<xsl:if test="not(contains(@to, 'DITTO'))"> 
	  To: <xsl:value-of select="concat('B.', ../@src, '.', substring-before(substring-after(@to, 'ID('), ')'))"/>
	</xsl:if>
	<xsl:if test="contains(@to, 'PATTERN(')">
	  with a pattern of "<xsl:value-of select="substring-before(substring-after(@to, 'PATTERN('), ')')"/>"
	</xsl:if>
      </xsl:when>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="xptr[@type='prayer']">
  <xsl:variable name="prayerid" select="substring-before(substring-after(@from, 'ID('), ')')"/>
  <span class="prayerBody" title="Prayer: {$prayerid}" >
    <xsl:apply-templates select="document(concat('../content/repository/', $prayerid, '.xml'))//pBody"/>
  </span>
  <a class="arrowlink" href="/ed/{$prayerid}" title="go to edition of this prayer"><span class="arrow"><img src="/images/rarrow.gif"/></span></a>
</xsl:template>

<xsl:template match="xptr[@type='aBody']">
  <xsl:variable name="antiphonid" select="substring-before(substring-after(@from, 'ID('), ')')"/>
  <span class="aBody" title="Antiphon: {$antiphonid}" >
    <xsl:apply-templates select="document(concat('../content/repository/', $antiphonid, '.xml'))//aBody"/>
  </span>
  <a class="arrowlink" href="/ed/{$antiphonid}" title="go to edition of this antiphon"><span class="arrow"><img src="/images/rarrow.gif"/></span></a>
</xsl:template>

<xsl:template match="xptr[@type='rBody']">
  <xsl:variable name="rBodyid" select="substring-before(substring-after(@from, 'ID('), ')')"/>
  <span class="rBody" title="Respond Body: {$rBodyid}" >
    <xsl:apply-templates select="document(concat('../content/repository/', $rBodyid, '.xml'))//rBody"/>
  </span>
  <a class="arrowlink" href="/ed/{$rBodyid}" title="go to edition of this respond"><span class="arrow"><img src="/images/rarrow.gif"/></span></a>
  <br />
</xsl:template>

<xsl:template match="xptr[@type='rVerse']">
  <xsl:variable name="rVerseid" select="substring-before(substring-after(@from, 'ID('), ')')"/>

  <span class="rVerse" title="Respond Verse: {$rVerseid}" >
    <xsl:apply-templates select="document(concat('../content/repository/', $rVerseid, '.xml'))//verses"/>
    <!-- OLD WAY WAS:  <xsl:apply-templates select="$responds//res[@id=$rVerseid]/verses"/> -->
  </span>
</xsl:template>



<!-- BIBLE -->

<xsl:template match="xptr[@type='bible']">
  <div class="bible">
    <xsl:variable name="biblefile">
      <xsl:choose>
	<xsl:when test="contains(unparsed-entity-uri(@href), 'dtd/')">
	  <xsl:value-of select="substring-after(unparsed-entity-uri(@href), 'dtd/')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="unparsed-entity-uri(@href)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="uri">
      <xsl:value-of select="concat('../content/vulgate/', $biblefile)"/>
    </xsl:variable>
    <xsl:variable name="doc">
      <xsl:value-of select="$uri"/>
    </xsl:variable>
    <xsl:variable name="bookname">
      <xsl:value-of select="substring-before($biblefile, '.')"/>
    </xsl:variable>

    <xsl:variable name="fromID">
      <xsl:value-of select="concat('B.', $bookname, '.', substring-before(substring-after(@from, 'ID('), ')'))"/>
    </xsl:variable>

    <xsl:variable name="toID">
      <xsl:choose>
	<xsl:when test="@to = 'DITTO'">
	  <xsl:value-of select="$fromID"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat('B.', $bookname, '.', substring-before(substring-after(@to, 'ID('), ')'))"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="fromPATT">
      <xsl:if test="contains(@from, 'PATTERN(')">
	<xsl:value-of select="substring-before(substring-after(@from, 'PATTERN('), ')')"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="toPATT">
      <xsl:if test="contains(@to, 'PATTERN(')">
	<xsl:value-of select="substring-before(substring-after(@to, 'PATTERN('), ')')"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="reference">
      <xsl:value-of select="$bookname"/><xsl:text>, </xsl:text>
      <a href="/vulgate/{$bookname}#{$fromID}"><xsl:value-of select="document($doc)//verse[@id=$fromID]/reference/verseNum"/></a>
      <xsl:if test="contains(@to, 'ID')">
	<xsl:text> - </xsl:text>
	<a href="/vulgate/{$bookname}#{$toID}"><xsl:value-of select="document($doc)//verse[@id=$toID]/reference/verseNum"/></a>
      </xsl:if>
    </xsl:variable>

    <span class="bibleref"><xsl:text> [</xsl:text>
    <xsl:value-of select="$bookname"/><xsl:text>, </xsl:text>
    <a href="/vulgate/{$bookname}#{$fromID}"><xsl:value-of select="document($doc)//verse[@id=$fromID]/reference/verseNum"/></a>
    <xsl:if test="contains(@to, 'ID')">
      <xsl:text> - </xsl:text>
      <a href="/vulgate/{$bookname}#{$toID}"><xsl:value-of select="document($doc)//verse[@id=$toID]/reference/verseNum"/></a>
    </xsl:if>
    <xsl:text>] </xsl:text></span>
    <xsl:choose>

      <xsl:when test="not(@to) and contains(@from, 'PATTERN(')">
	<xsl:for-each select="document($doc)">
	  <xsl:for-each select="//verse[@id=$fromID]">
	    <xsl:value-of select="$fromPATT"/>
	    <xsl:text> </xsl:text>
	    <xsl:value-of select="substring-after(./l, $fromPATT)"/>
	  </xsl:for-each>
	</xsl:for-each>
      </xsl:when>

      <xsl:when test="not(@to) and not(contains(@from, 'PATTERN('))">
	<xsl:for-each select="document($doc)">
	  <xsl:for-each select="//verse[@id=$fromID]">
	    <xsl:value-of select="l"/>
	    <xsl:text> </xsl:text>
	  </xsl:for-each>
	</xsl:for-each>
      </xsl:when>


      <xsl:when test="not(contains(@to, 'PATTERN(') or contains(@from, 'PATTERN('))">
	<xsl:for-each select="document($doc)">
	  <xsl:for-each select="//verse[@id=$fromID or (preceding::verse[@id=$fromID] and following::verse[@id=$toID]) or @id=$toID]">
	    <xsl:value-of select="l"/>
	    <xsl:text> </xsl:text>
	  </xsl:for-each>
	</xsl:for-each>
      </xsl:when>

      <xsl:when test="contains(@to, 'PATTERN(') and contains(@from, 'PATTERN(')">
	<xsl:for-each select="document($doc)">
	  <xsl:for-each select="//verse[@id=$fromID]">
	    <xsl:value-of select="$fromPATT"/>
	    <xsl:text> </xsl:text>
	    <xsl:value-of select="substring-after(./l, $fromPATT)"/>
	  </xsl:for-each>
	  <xsl:for-each select="//verse[(preceding::verse[@id=$fromID] and following::verse[@id=$toID])]">
	    <xsl:value-of select="l"/>
	    <xsl:text> </xsl:text>
	  </xsl:for-each>
	  <xsl:for-each select="//verse[@id=$toID]">
	    <xsl:value-of select="substring-before(./l, $toPATT)"/>
	    <xsl:text> </xsl:text>
	    <xsl:value-of select="$toPATT"/>
	  </xsl:for-each>

	</xsl:for-each>
      </xsl:when>

      <xsl:when test="contains(@to, 'PATTERN(') and not(contains(@from, 'PATTERN('))">
	<xsl:for-each select="document($doc)">
	  <xsl:for-each select="//verse[@id=$fromID or (preceding::verse[@id=$fromID] and following::verse[@id=$toID])]">
	    <xsl:value-of select="l"/>
	    <xsl:text> </xsl:text>
	  </xsl:for-each>
	  <xsl:for-each select="//verse[@id=$toID]"> <xsl:value-of select="substring-before(./l, $toPATT)"/>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="$toPATT"/></xsl:for-each>
	</xsl:for-each>
      </xsl:when>

      <xsl:when test="not(contains(@to, 'PATTERN(')) and contains(@from, 'PATTERN(')">
	<xsl:for-each select="document($doc)">
	  <xsl:for-each select="//verse[@id=$fromID]">
	    <xsl:value-of select="$fromPATT"/>
	    <xsl:value-of select="substring-after(./l, $fromPATT)"/>
	  </xsl:for-each>
	  <xsl:text> </xsl:text>
	  <xsl:for-each select="//verse[(preceding::verse[@id=$fromID] and following::verse[@id=$toID]) or @id=$toID]">
	    <xsl:value-of select="l"/>
	    <xsl:text> </xsl:text>
	  </xsl:for-each>
	</xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </div>

</xsl:template>



<xsl:template match="aBody|rBody|pBody|vBody|rep|dox" >
  <xsl:if test="contains(concat(' ', @wit, ' '), concat(' ', $ms, ' '))">
    <span class="{name()}">
      <xsl:apply-templates />
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="app" >
  <xsl:text> </xsl:text>
  <xsl:apply-templates/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="rdg" >
  <xsl:if test="contains(concat(' ',@wit,' '), concat(' ',$ms, ' '))">
    <xsl:text> </xsl:text><xsl:apply-templates  /><xsl:text> </xsl:text>
  </xsl:if>
</xsl:template>


<xsl:template match="verses" >
  <xsl:apply-templates  />
</xsl:template>



<xsl:template match="anchor[@corresp]">
  <span class="anchor">
    <xsl:copy-of select="@*[not(name()='corresp')]"/>
    <xsl:apply-templates select="id(@corresp)" mode="link" />
    <xsl:apply-templates />
  </span>
</xsl:template>

<xsl:template match="anchor" mode="link">
  <a href="#{@id}" title="[xref to {@id}]"><span class="msxref">[xref]</span></a>
</xsl:template>

</xsl:stylesheet>
