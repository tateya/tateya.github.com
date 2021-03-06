<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:transform [
  <!ENTITY block "xhtml5:aside|xhtml5:figure|xhtml5:figcaption|xhtml5:nav|xhtml5:section">
  <!ENTITY inline "xhtml5:mark|xhtml5:time">
]>
<xsl:transform xmlns="http://www.w3.org/1999/xhtml" xmlns:xhtml5="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xhtml5" version="1.0">
  <xsl:output cdata-section-elements="pre script style" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" encoding="UTF-8" indent="no" media-type="text/html" method="xml" omit-xml-declaration="no" standalone="no" version="1.0"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="debug" select="true()"/>
  <xsl:param name="root-language" select="/xhtml5:html/@xml:lang"/>
  <xsl:param name="site-title">
    <xsl:choose>
      <xsl:when test="$root-language = 'ja'">
        <xsl:text>たてや組</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Tateya-gumi</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="page-modified" select="false()"/>

  <xsl:template match="/">
    <html>
      <xsl:if test="$debug">
        <xsl:attribute name="id">
          <xsl:text>debug-mode</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$root-language">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="$root-language"/>
        </xsl:attribute>
        <xsl:attribute name="lang">
          <xsl:value-of select="$root-language"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </html>
  </xsl:template>

  <xsl:template match="xhtml5:html">
    <xsl:param name="page-title" select="xhtml5:head/xhtml5:title"/>
    <xsl:param name="site-home" select="$page-title = $site-title"/>
    <xsl:apply-templates select="xhtml5:head">
      <xsl:with-param name="page-title" select="$page-title"/>
      <xsl:with-param name="site-home" select="$site-home"/>
    </xsl:apply-templates>
    <body>
      <xsl:call-template name="site-header">
        <xsl:with-param name="page-title" select="$page-title"/>
      </xsl:call-template>
      <xsl:apply-templates select="xhtml5:body"/>
      <xsl:call-template name="site-footer">
        <xsl:with-param name="site-home" select="$site-home"/>
      </xsl:call-template>
    </body>
  </xsl:template>

  <xsl:template match="xhtml5:head">
    <xsl:param name="page-title"/>
    <xsl:param name="site-home" select="false()"/>
    <head>
      <xsl:call-template name="meta-elements">
        <xsl:with-param name="elements" select="xhtml5:meta"/>
      </xsl:call-template>
      <xsl:call-template name="link-elements">
        <xsl:with-param name="elements" select="xhtml5:link"/>
      </xsl:call-template>
      <title>
        <xsl:value-of select="$site-title"/>
        <xsl:if test="not($site-home)">
          <xsl:text> - </xsl:text>
          <xsl:value-of select="$page-title"/>
        </xsl:if>
      </title>
    </head>
  </xsl:template>

  <xsl:template name="meta-elements">
    <xsl:param name="elements"/>
    <xsl:param name="generator" select="system-property('xsl:vendor')"/>
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type"/>
    <meta content="text/css" http-equiv="Content-Style-Type"/>
    <meta content="application/javascript" http-equiv="Content-Script-Type"/>
    <xsl:if test="$generator">
      <meta content="{$generator}" name="generator"/>
    </xsl:if>
    <xsl:apply-templates mode="node-walker" select="$elements"/>
    <xsl:if test="$page-modified">
      <meta content="{$page-modified}" name="dcterms.modified"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="link-elements">
    <xsl:param name="elements"/>
    <link href="/info/staff" rel="author"/>
    <link href="/info" rel="help"/>
    <xsl:apply-templates mode="node-walker" select="$elements"/>
    <link href="/LICENSE" rel="license" type="text/plain"/>
    <link href="/2012/06/mozilla-gumi.css" rel="stylesheet" type="text/css"/>
  </xsl:template>

  <xsl:template match="xhtml5:body">
    <xsl:param name="level" select="2"/>
    <div class="article">
      <xsl:apply-templates mode="node-walker" select="xhtml5:nav">
        <xsl:with-param name="level" select="$level"/>
      </xsl:apply-templates>
      <div class="contents">
        <xsl:apply-templates mode="node-walker" select="*[not(local-name() = 'nav' or local-name() = 'aside')]|@*|text()|comment()">
          <xsl:with-param name="level" select="$level"/>
        </xsl:apply-templates>
      </div>
      <xsl:apply-templates mode="node-walker" select="xhtml5:aside">
        <xsl:with-param name="level" select="$level"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="xhtml5:*" mode="node-walker">
    <xsl:param name="level"/>
    <xsl:element name="{local-name()}">
      <xsl:apply-templates mode="node-walker" select="*|@*|text()|comment()">
        <xsl:with-param name="level" select="$level"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xhtml5:link|xhtml5:script|xhtml5:style" mode="node-walker">
    <xsl:param name="type">
      <xsl:choose>
        <xsl:when test="local-name() = 'script' and (not(@src) or contains(@src, '.js'))">
          <xsl:text>application/javascript</xsl:text>
        </xsl:when>
        <xsl:when test="(local-name() = 'link' and @rel = 'stylesheet') or local-name() = 'style'">
          <xsl:text>text/css</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:param>
    <xsl:element name="{local-name()}">
      <xsl:if test="not(@type) and $type">
        <xsl:attribute name="type">
          <xsl:value-of select="$type"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="node-walker" select="@*|text()|comment()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xhtml5:h1" mode="node-walker">
    <xsl:param name="level" select="2"/>
    <xsl:element name="h{$level}">
      <xsl:apply-templates mode="node-walker" select="*|@*|text()|comment()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="&block;" mode="node-walker">
    <xsl:param name="level"/>
    <xsl:param name="sectioning" select="local-name() = 'aside'or local-name() = 'nav' or local-name() = 'section'"/>
    <div class="{local-name()}">
      <xsl:apply-templates mode="node-walker" select="*|@*|text()|comment()">
        <xsl:with-param name="level">
          <xsl:choose>
            <xsl:when test="$sectioning">
              <xsl:value-of select="$level + 1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$level"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="&inline;" mode="node-walker">
    <span class="{local-name()}">
      <xsl:apply-templates mode="node-walker" select="*|@*|text()|comment()"/>
    </span>
  </xsl:template>

  <xsl:template match="@*" mode="node-walker">
    <xsl:param name="attribute-name">
      <xsl:choose>
        <xsl:when test="local-name(..) = 'time' and name() = 'datetime'">
          <xsl:text>title</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="name()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:attribute name="{$attribute-name}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="site-header">
    <xsl:param name="page-title"/>
    <div class="header">
      <div class="hgroup">
        <h1>
          <xsl:value-of select="$site-title"/>
        </h1>
        <h2>The Tateya-gumi</h2>
      </div>
      <div class="nav">
        <ul>
          <li><a href="/">ホーム</a></li>
          <li><a href="http://news.tateya.or.jp/">ニュース</a></li>
          <li><a href="/download">ダウンロード</a></li>
          <li><a href="https://github.com/tateya">プロジェクト</a></li>
          <li><a href="/document">ドキュメント</a></li>
          <li><a href="https://github.com/tateya/tateya.github.com/issues">フォーラム</a></li>
          <li><a href="https://github.com/tateya/tateya.github.com/wiki">Wiki</a></li>
        </ul>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="site-footer">
    <xsl:param name="site-home" select="false()"/>
    <div class="footer">
      <xsl:if test="$site-home">
        <p>このサーバは、<a href="https://github.com/">GitHub</a>にホスティングしていただいております。また、サーバの管理は、<a href="http://pages.github.com/">github:pages</a>のご協力を頂いております。</p>
        <p>なお、本物のアニメに関するご質問は<a href="https://github.com/tateya/tateya.github.com/issues">フォーラム</a>等をご利用ください。</p>
      </xsl:if>
      <p class="copyright">Copyright &#169; 2012 TateyaGumi, All Rights Reserved.</p>
      <div class="nav">
        <ul>
          <li><a href="/info">たてや組について</a></li>
          <li><a href="/info/sitemap" type="text/xml">サイトマップ</a></li>
          <li><a href="/info/policy">サイトのご利用にあたって</a></li>
          <li><a href="/info/contact">お問い合わせ</a></li>
        </ul>
      </div>
    </div>
  </xsl:template>
</xsl:transform>
