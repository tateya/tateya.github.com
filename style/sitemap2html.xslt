<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="xsl sitemap" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:template match="/sitemap:urlset">
    <html>
      <head>
        <link href="/style/default.css" rel="stylesheet"/>
        <link href="https://github.com/tateya/tateya.github.com/commits/master.atom" rel="alternate" type="application/atom+xml"/>
        <title>sitemap</title>
      </head>
      <body>
        <header>
          <hgroup>
            <h1>たてや組</h1>
            <h2>The Tateya-gumi</h2>
          </hgroup>
          <nav>
            <ul>
              <li><a href="/">ホーム</a></li>
              <li><a href="https://github.com/tateya">ニュース</a></li>
              <li><a href="/download">ダウンロード</a></li>
              <li><a href="/document">ドキュメント</a></li>
              <li><a href="https://github.com/tateya/tateya.github.com/issues">フォーラム</a></li>
              <li><a href="https://github.com/tateya/tateya.github.com/wiki">Wiki</a></li>
            </ul>
          </nav>
        </header>
        <section>
          <h1>サイトマップ</h1>
          <ul>
            <xsl:apply-templates select="sitemap:url"/>
          </ul>
        </section>
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
        <footer>
          <address>Copyright &#169; 2012 TateyaGumi, All Rights Reserved.</address>
          <nav>
            <ul>
              <li><a href="/info">たてや組について</a></li>
              <li><a href="/sitemap.xml">サイトマップ</a></li>
              <li><a href="/info/policy">サイトのご利用にあたって</a></li>
              <li><a href="https://github.com/tateya/tateya.github.com/issues">お問い合わせ</a></li>
            </ul>
          </nav>
        </footer>
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
