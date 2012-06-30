<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:m="http://www.w3.org/2005/10/markup-validator" version="1.0">
  <xsl:output method="text" encoding="UTF-8" indent="no" media-type="text/plain"/>

  <xsl:param name="filename" select="'&lt;FILENAME&gt;'"/>

  <xsl:template match="/">
    <xsl:apply-templates select="env:Envelope/env:Body/m:markupvalidationresponse"/>
  </xsl:template>

  <xsl:template match="m:markupvalidationresponse">
    <xsl:value-of select="$filename"/>
    <xsl:choose>
      <xsl:when test="m:validity = 'true'">
        <xsl:text> is valid!
</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> is invalid...</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
