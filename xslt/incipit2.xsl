<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" />
<xsl:template match="/">
<CURSUS>
    <xsl:apply-templates />
</CURSUS>
</xsl:template>

<!-- create key 'k' -->
<xsl:key name="k" match="aBody|pBody|rBody" use="."/>

<!-- match root element -->
<xsl:template match="/CURSUS">
    <xsl:apply-templates />
</xsl:template>

<!-- things to exclude -->
<xsl:template match="teiHeader|witList|vBody|verse|verses|rep">
</xsl:template>


<xsl:template match="res|ant|prayer">
<xsl:element name="{name()}"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute><xsl:apply-templates /></xsl:element>
</xsl:template>


<!-- create the wits variable -->
<xsl:variable name="wits">
<xsl:for-each select="/CURSUS/text/body/witList/witness">
<x><xsl:value-of select="@sigil"/></x>
</xsl:for-each>
</xsl:variable>

<xsl:template match="div">  
<div class="{@n}">
<xsl:apply-templates />
</div>
</xsl:template>

<!-- match 'aBody' and select each reading -->
<xsl:template match="aBody">
<xsl:variable name="a" select="."/>
<xsl:variable name="one">
    <xsl:for-each select="$wits/*">
        <aBody wit="{.}">
        <xsl:variable name="x">
            <xsl:apply-templates mode="wit" select="$a">
            <xsl:with-param name="wit" select="."/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:value-of select="normalize-space($x)"/>
        </aBody>
    </xsl:for-each>
</xsl:variable>
<xsl:for-each select="$one/*">
<!-- <xsl:if test="generate-id(.)=generate-id(key('k',.))"> -->
<!-- <xsl:if test="generate-id(key('k',.)[1])"> -->
<xsl:if test=". is key('k', .)[1]">

<aBody>
        <!-- create wit attribute with spaces -->
            <xsl:attribute name="wit">
            <xsl:for-each select="key('k',.)">
            <xsl:value-of select="@wit"/>
            <xsl:if test="position()&lt;last()"><xsl:text> </xsl:text></xsl:if>
            </xsl:for-each>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </aBody>
    </xsl:if>
</xsl:for-each>
</xsl:template>


<!-- match 'pBody' and select each reading -->
<xsl:template match="pBody">
<xsl:variable name="a" select="."/>
<xsl:variable name="one">
    <xsl:for-each select="$wits/*">
        <pBody wit="{.}">
        <xsl:variable name="x">
            <xsl:apply-templates mode="wit" select="$a">
            <xsl:with-param name="wit" select="."/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:value-of select="normalize-space($x)"/>
        </pBody>
    </xsl:for-each>
</xsl:variable>
<xsl:for-each select="$one/*">
<xsl:if test=". is key('k', .)[1]">
        <pBody>
        <!-- create wit attribute with spaces -->
            <xsl:attribute name="wit">
            <xsl:for-each select="key('k',.)">
            <xsl:value-of select="@wit"/>
            <xsl:if test="position()&lt;last()"><xsl:text> </xsl:text></xsl:if>
            </xsl:for-each>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </pBody>
    </xsl:if>
</xsl:for-each>
</xsl:template>

<xsl:template match="rBody">
<xsl:variable name="a" select="."/>
<xsl:variable name="one">
    <xsl:for-each select="$wits/*">
        <rBody wit="{.}">
        <xsl:variable name="x">
            <xsl:apply-templates mode="wit" select="$a">
            <xsl:with-param name="wit" select="."/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:value-of select="normalize-space($x)"/>
        </rBody>
    </xsl:for-each>
</xsl:variable>
<xsl:for-each select="$one/*">
<xsl:if test=". is key('k', .)[1]">
        <rBody>
        <!-- create wit attribute with spaces -->
            <xsl:attribute name="wit">
            <xsl:for-each select="key('k',.)">
            <xsl:value-of select="@wit"/>
            <xsl:if test="position()&lt;last()"><xsl:text> </xsl:text></xsl:if>
            </xsl:for-each>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </rBody>
    </xsl:if>
</xsl:for-each>
</xsl:template>


<!-- template called above which tests wits -->
<xsl:template mode="wit" match="*">
    <xsl:param name="wit"/>
    <xsl:if test="not(@wit) or 
(@wit and contains(concat(' ',@wit,' '), concat(' ',$wit,' ')))">
        <xsl:apply-templates mode="wit">
            <xsl:with-param name="wit" select="$wit"/>
        </xsl:apply-templates>
    </xsl:if>
</xsl:template>


</xsl:stylesheet>
