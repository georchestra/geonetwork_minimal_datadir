<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all">

  <xsl:template mode="relation" match="metadata[simpledc]" priority="99">
    <xsl:for-each select="*/descendant::*
                        [name(.) = 'dct:references' or name(.) = 'dc:relation']
                        [starts-with(., 'http') or contains(. , 'resources.get') or contains(., 'file.disclaimer')]">
      <xsl:variable name="name" select="tokenize(., '/')[last()]"/>
      <relation type="onlinesrc">
        <id><xsl:value-of select="."/></id>
        <title>
          <xsl:value-of select="$name"/>
        </title>
        <url>
          <xsl:value-of select="."/>
        </url>
        <name>
          <xsl:value-of select="$name"/>
        </name>
        <abstract><xsl:value-of select="."/></abstract>
        <description>
          <xsl:value-of select="$name"/>
        </description>
        <xsl:choose>
          <xsl:when test="contains(. , 'resources.get') or contains(., 'file.disclaimer')">
            <protocol><xsl:value-of select="'WWW:DOWNLOAD-1.0-http--download'"/></protocol>
          </xsl:when>
          <xsl:otherwise>
            <protocol><xsl:value-of select="'WWW:LINK'"/></protocol>
          </xsl:otherwise>
        </xsl:choose>
      </relation>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>