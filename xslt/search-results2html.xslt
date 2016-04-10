<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" />

<xsl:param name="collection" />
<xsl:param name="terms" />
<xsl:param name="from" />
<xsl:param name="number" />

<xsl:variable name="first-s">
  <xsl:choose>
    <xsl:when test="number(//@hits)=0">0</xsl:when>
    <xsl:otherwise><xsl:value-of select="$from" /></xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<xsl:variable name="first" select="number($first-s)" />

<xsl:variable name="last-s">
  <xsl:choose>
    <xsl:when test="$first = 1">
      <xsl:choose>
	<xsl:when test="number($number) &gt; number(//@hits)"><xsl:value-of select="//@hits" /></xsl:when>
	<xsl:otherwise><xsl:value-of select="number($number)" /></xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
	<xsl:when test="$first + number($number) - 1 &gt; number(//@hits)"><xsl:value-of select="//@hits" /></xsl:when>
	<xsl:otherwise><xsl:value-of select="$first + number($number) - 1" /></xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<xsl:variable name="last" select="number($last-s)" />

<xsl:template match="/">

<html>
  <head>
    <title>Search Results for "<xsl:value-of select="//@query" />"</title>
  </head>
  <body>
    <h1>Cursus Search Page</h1>
    <h3>Search Results:</h3>
    <p>Search query "<xsl:value-of select="//@query" />" returned <xsl:value-of select="//@hits" /> results.</p>
    <xsl:if test="number(//@hits) &gt; 0">
    <p>
      Showing results: <xsl:value-of select="$first" /> to <xsl:value-of select="$last" />
    </p>
    <xsl:call-template name="back-next-buttons" />
    <hr />
    <ol start="{$from}">
      <xsl:apply-templates select="//result[position() &gt;= $first and position() &lt;= $last]" />
    </ol>
    <hr />
    <xsl:call-template name="back-next-buttons" />
    </xsl:if>
  </body>
</html>

</xsl:template>

<xsl:template match="result">
  <li>
    <a href="{swishdocpath}">
      <xsl:value-of select="swishtitle" />
    </a>
  </li>
</xsl:template>

<xsl:template name="back-next-buttons">
  <div class="back-next">
    <xsl:choose>
      <xsl:when test="$first &lt;= 1">Back</xsl:when>
      <xsl:when test="$first &gt; 1">
	<form style="display:inline;margin:0px;padding:0px" name="go-back" action="/search" method="get"
	      onsubmit="forms['go-back'].terms.value=decodeURI(forms['go-back'].terms.value)">
	  <input type="hidden" name="collection" value="{$collection}" />
	  <input type="hidden" name="terms" value="{translate($terms, '+', ' ')}" />
	  <input type="hidden" name="from" value="{$first - number($number)}" />
	  <input type="hidden" name="number" value="{$number}" />
	  <input type="submit" name="submit" value="Back" />
	</form>
      </xsl:when>
    </xsl:choose>
    <xsl:text> -- </xsl:text>
    <xsl:choose>
      <xsl:when test="$last &gt;= number(//@hits)">Next</xsl:when>
      <xsl:when test="$last &lt; number(//@hits)">
	<form style="display:inline;margin:0px;padding:0px" name="go-next" action="/search" method="get"
	      onsubmit="forms['go-next'].terms.value=decodeURI(forms['go-next'].terms.value)">
	  <input type="hidden" name="collection" value="{$collection}" />
	  <input type="hidden" name="terms" value="{translate($terms, '+', ' ')}" />
	  <input type="hidden" name="from" value="{$last + 1}" />
	  <input type="hidden" name="number" value="{$number}" />
	  <input type="submit" name="submit" value="Next" />
	</form>
      </xsl:when>
    </xsl:choose>
  </div>
</xsl:template>

</xsl:stylesheet>
