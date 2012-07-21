<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="xsl sitemap" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output encoding="UTF-8" indent="no" media-type="application/xhtml+xml" method="xml" version="1.0"/>

  <xsl:template match="/sitemap:urlset">
    <xsl:processing-instruction name="xml-stylesheet">
      <xsl:text>href="/2012/07/mozilla-gumi.xslt"</xsl:text>
      <xsl:text> </xsl:text>
      <xsl:text>type="application/xml"</xsl:text>
    </xsl:processing-instruction>
    <html xml:lang="ja">
      <head>
	<title>sitemap.xml</title>
      </head>
      <body>
	<h1>sitemap.xml</h1>
	<ul>
	  <xsl:apply-templates select="sitemap:url"/>
	</ul>
        <aside>
          <section>
            <h1>サイト内部検索</h1>
            <form>
              <fieldset>
                <legend><label for="search-field">たてや組の文書を全文検索します。</label></legend>
                <input id="search-field" type="search"/>
                <button type="submit">検索</button>
              </fieldset>
	    </form>
          </section>
        </aside>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="sitemap:url">
    <li>
      <time>
        <xsl:value-of select="sitemap:lastmod"/>
      </time>
      <xsl:text> </xsl:text>
      <a href="{sitemap:loc}">
        <xsl:value-of select="sitemap:loc"/>
      </a>
    </li>
  </xsl:template>
</xsl:stylesheet>
