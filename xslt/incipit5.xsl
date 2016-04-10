<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon">
<xsl:output method="xml" />
    <xsl:template match="/">
            <html>
            <head>
            <title>Cursus Incipit List</title>
            <link rel="Stylesheet" type="text/css" href="/css/incipitlist.css" ><xsl:text>  </xsl:text></link>
            </head>
            <body>
              <h1>Cursus Incipit List</h1>
              <h4> Antiphons:</h4>              
            <!-- antiphon files -->
            <xsl:for-each-group select="//incipit[@type='a']" group-by="translate(substring(.,1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')">
              <xsl:sort />
       <xsl:variable name="letter">
         <xsl:choose>
           <xsl:when test="substring(.,1,1)='['">Lacuna</xsl:when>
           <xsl:otherwise><xsl:value-of select="translate(substring(.,1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></xsl:otherwise>
         </xsl:choose>
       </xsl:variable>
       <xsl:variable name="file" select="concat('antiphons/', $letter, '.html')"/>
              <xsl:text>  
	      </xsl:text>
	      <a href="/incipits/{$file}"><xsl:value-of select="$letter"/></a><xsl:text>   
	      </xsl:text>
                <xsl:result-document href="{$file}">
                  <html>
                    <head>
            <link rel="Stylesheet" type="text/css" href="/styles/incipitlist.css" ><xsl:text>  </xsl:text></link>
                    <title>Antiphons Incipits Beginning With: <xsl:value-of select="$letter"/> </title>
                    </head>
                    <body>
                    <h1>Antiphons Incipits Beginning With: <xsl:value-of select="$letter"/> </h1>
		    <hr />
                      <ul>
                        <xsl:for-each select="current-group()">
			<xsl:sort />
			<li><a title="{@wit}"><xsl:attribute name="href">
<xsl:value-of select="concat('/ed/',@num )"/></xsl:attribute>
                        <xsl:value-of select="."/></a></li></xsl:for-each>
                  </ul>
                  </body></html>
                </xsl:result-document>
              </xsl:for-each-group>

              <h4>Responds:</h4>
            <!-- respond files -->
            <xsl:for-each-group select="//incipit[@type='r']" group-by="translate(substring(.,1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')">
              <xsl:sort/>

       <xsl:variable name="letter">
         <xsl:choose>
           <xsl:when test="substring(.,1,1)='['">Lacuna</xsl:when>
           <xsl:otherwise><xsl:value-of select="translate(substring(.,1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></xsl:otherwise>
         </xsl:choose>
       </xsl:variable>
              <xsl:variable name="file" select="concat('responds/', $letter, '.html')"/>
              <xsl:text>  
	      </xsl:text>
              <a href="/incipits/{$file}"><xsl:value-of select="$letter"/></a><xsl:text>   </xsl:text>
              <xsl:text>  
	      </xsl:text>
                <xsl:result-document href="{$file}">
                  <html> 
                    <head>
		   <link rel="Stylesheet" type="text/css" href="/styles/incipitlist.css" ><xsl:text>  </xsl:text></link> 
                    <title>Respond Incipits Beginning With: <xsl:value-of select="$letter"/> </title>
                    </head>
                    <body>
                    <h1>Respond Incipits Beginning With: <xsl:value-of select="$letter"/> </h1>
<hr />
                      <ul>
                        <xsl:for-each select="current-group()">
			<xsl:sort />
			<li><a title="{@wit}"><xsl:attribute name="href">
<xsl:value-of select="concat('/ed/',@num )"/></xsl:attribute>
                        <xsl:value-of select="."/></a></li></xsl:for-each>
                  </ul>
<div class="footer">
<hr />
<a href="/">Cursus Project</a><xsl:text> -- </xsl:text> <a href="/incipits/">Incipit List</a>
</div>
                  </body></html>
                </xsl:result-document>
              </xsl:for-each-group>

              <h4>Prayers:</h4>
            <!-- prayer files -->
            <xsl:for-each-group select="//incipit[@type='p']" group-by="translate(substring(.,1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')">
              <xsl:sort/>
       <xsl:variable name="letter">
         <xsl:choose>
           <xsl:when test="substring(.,1,1)='['">Lacuna</xsl:when>
           <xsl:otherwise><xsl:value-of select="translate(substring(.,1,1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></xsl:otherwise>
         </xsl:choose>
       </xsl:variable>
              <xsl:variable name="file" select="concat('prayers/', $letter, '.html')"/>
              <xsl:text>  
	      </xsl:text>
              <a href="/incipits/{$file}"><xsl:value-of select="$letter"/></a><xsl:text>   </xsl:text>
              <xsl:text>  
	      </xsl:text>
                <xsl:result-document href="{$file}">
                  <html> 
                    <head>
		    <link rel="Stylesheet" type="text/css" href="/styles/incipitlist.css" ><xsl:text>  </xsl:text></link>
                    <title>Prayer Incipits Beginning With: <xsl:value-of select="$letter"/> </title>
                    </head>
                    <body>
                    <h1>Prayer Incipits Beginning With: <xsl:value-of select="$letter"/> </h1>
<hr />
                      <ul>
                        <xsl:for-each select="current-group()">
		<xsl:sort />	
			<li><a title="{@wit}"><xsl:attribute name="href">
<xsl:value-of select="concat('/ed/',@num )"/></xsl:attribute>
                        <xsl:value-of select="."/></a></li></xsl:for-each>
                  </ul>
                  </body></html>
                </xsl:result-document>
              </xsl:for-each-group>
            </body>
            </html>
</xsl:template>

<xsl:template match="incipit">
  </xsl:template>

<!-- match root element -->
<xsl:template match="/CURSUS">
</xsl:template>

</xsl:stylesheet>
