<?xml version="1.0" encoding="UTF-8"?>
<!--
  Renders /index.xml as a readable page when a human opens it in a browser,
  via the xml-stylesheet PI emitted by layouts/rss.xml. Feed readers parse
  the RSS directly and never apply this: it has no effect on how the feed
  looks in a newsreader, only on what a person sees if they click the link.

  Only XSLT 1.0 is supported by browsers' built in processors (Chrome,
  Firefox, Safari), so no XPath 2.0+ functions.

  Colors are copied from themes/PaperMod/assets/css/core/theme-vars.css (base
  palette) and data/postthemes.yaml (category accents). This file can't read
  either at build time: it's a static asset transformed client side, so if
  either changes, update the values below to match.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"
              doctype-system="about:legacy-compat"/>

  <xsl:template name="month-name">
    <xsl:param name="abbr"/>
    <xsl:choose>
      <xsl:when test="$abbr = 'Jan'">January</xsl:when>
      <xsl:when test="$abbr = 'Feb'">February</xsl:when>
      <xsl:when test="$abbr = 'Mar'">March</xsl:when>
      <xsl:when test="$abbr = 'Apr'">April</xsl:when>
      <xsl:when test="$abbr = 'May'">May</xsl:when>
      <xsl:when test="$abbr = 'Jun'">June</xsl:when>
      <xsl:when test="$abbr = 'Jul'">July</xsl:when>
      <xsl:when test="$abbr = 'Aug'">August</xsl:when>
      <xsl:when test="$abbr = 'Sep'">September</xsl:when>
      <xsl:when test="$abbr = 'Oct'">October</xsl:when>
      <xsl:when test="$abbr = 'Nov'">November</xsl:when>
      <xsl:when test="$abbr = 'Dec'">December</xsl:when>
      <xsl:otherwise><xsl:value-of select="$abbr"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- pubDate is always "Mon, 02 Jan 2006 15:04:05 -0700" (fixed-width, from
       layouts/rss.xml's Format call), so the date parts sit at fixed offsets. -->
  <xsl:template name="pretty-date">
    <xsl:param name="raw"/>
    <xsl:variable name="day" select="number(substring($raw, 6, 2))"/>
    <xsl:variable name="mon" select="substring($raw, 9, 3)"/>
    <xsl:variable name="yr" select="substring($raw, 13, 4)"/>
    <xsl:call-template name="month-name"><xsl:with-param name="abbr" select="$mon"/></xsl:call-template>
    <xsl:text> </xsl:text><xsl:value-of select="$day"/><xsl:text>, </xsl:text><xsl:value-of select="$yr"/>
  </xsl:template>

  <xsl:template name="category-class">
    <xsl:param name="name"/>
    <xsl:choose>
      <xsl:when test="$name = 'Cyber'">badge-cyber</xsl:when>
      <xsl:when test="$name = 'Technology'">badge-technology</xsl:when>
      <xsl:when test="$name = 'Reflection'">badge-reflection</xsl:when>
      <xsl:when test="$name = 'Career'">badge-career</xsl:when>
      <xsl:otherwise>badge-other</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/rss/channel">
    <html lang="en-us">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="title"/></title>
        <link rel="icon" href="/images/icons/favicon.ico"/>
        <style>
          :root {
            --theme: #fff; --entry: #fff; --primary: #1e1e1e; --secondary: #6c6c6c;
            --tertiary: #d6d6d6; --content: #1f1f1f; --border: #eee;
            --badge-cyber: #5b4bcf; --badge-technology: #0f766e;
            --badge-reflection: #8a6a12; --badge-career: #a03d5f; --badge-other: #4a6076;
            color-scheme: light dark;
          }
          @media (prefers-color-scheme: dark) {
            :root {
              --theme: #1d1e20; --entry: #2e2e33; --primary: #dadadb; --secondary: #9b9c9d;
              --tertiary: #414244; --content: #c4c4c5; --border: #333;
              --badge-cyber: #a99bff; --badge-technology: #5eead4;
              --badge-reflection: #e0b64a; --badge-career: #f0a0bd; --badge-other: #9db8cf;
            }
          }
          * { box-sizing: border-box; }
          body {
            margin: 0; background: var(--theme); color: var(--content);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen,
              Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
            line-height: 1.6;
          }
          main { max-width: 720px; margin: 0 auto; padding: 40px 20px 80px; }
          header { text-align: center; margin-bottom: 40px; }
          header img { width: 64px; height: 64px; border-radius: 50%; }
          header h1 { margin: 16px 0 4px; font-size: 1.6rem; }
          header h1 a { color: var(--primary); text-decoration: none; }
          header p { color: var(--secondary); margin: 0 0 20px; }
          .notice {
            font-size: 0.9rem; color: var(--secondary); background: var(--entry);
            border: 1px solid var(--border); border-radius: 8px; padding: 12px 16px;
          }
          .notice code { background: var(--tertiary); padding: 1px 5px; border-radius: 4px; }
          ul.items { list-style: none; margin: 32px 0 0; padding: 0; }
          .items li {
            background: var(--entry); border: 1px solid var(--border); border-radius: 8px;
            padding: 20px; margin-bottom: 16px;
          }
          .items h2 { margin: 0 0 8px; font-size: 1.15rem; }
          .items h2 a { color: var(--primary); text-decoration: none; }
          .items h2 a:hover { text-decoration: underline; }
          .meta { font-size: 0.85rem; color: var(--secondary); margin-bottom: 10px; }
          .badge {
            display: inline-block; font-size: 0.75rem; font-weight: 600;
            border: 1px solid currentColor; border-radius: 999px; padding: 1px 9px;
            margin-right: 8px;
          }
          .badge-cyber { color: var(--badge-cyber); }
          .badge-technology { color: var(--badge-technology); }
          .badge-reflection { color: var(--badge-reflection); }
          .badge-career { color: var(--badge-career); }
          .badge-other { color: var(--badge-other); }
          .items p { margin: 0; color: var(--content); }
          footer { text-align: center; margin-top: 40px; font-size: 0.85rem; color: var(--secondary); }
          footer a { color: var(--secondary); }
        </style>
      </head>
      <body>
        <main>
          <header>
            <xsl:if test="image/url">
              <img src="{image/url}" alt=""/>
            </xsl:if>
            <h1><a href="{link}"><xsl:value-of select="title"/></a></h1>
            <p><xsl:value-of select="description"/></p>
            <p class="notice">
              This is an RSS feed. Paste this page's URL into a feed reader
              (e.g. NetNewsWire, Feedbin, Reeder) to subscribe -- it isn't
              meant to be read here. Address bar shows <code><xsl:value-of select="atom:link/@href"/></code>.
            </p>
          </header>
          <ul class="items">
            <xsl:for-each select="item">
              <li>
                <div class="meta">
                  <xsl:for-each select="category">
                    <xsl:variable name="cls"><xsl:call-template name="category-class"><xsl:with-param name="name" select="."/></xsl:call-template></xsl:variable>
                    <span class="badge {$cls}"><xsl:value-of select="."/></span>
                  </xsl:for-each>
                  <xsl:call-template name="pretty-date"><xsl:with-param name="raw" select="pubDate"/></xsl:call-template>
                </div>
                <h2><a href="{link}"><xsl:value-of select="title"/></a></h2>
                <p><xsl:value-of select="description"/></p>
              </li>
            </xsl:for-each>
          </ul>
          <footer>
            <xsl:if test="copyright">
              <xsl:value-of select="copyright"/><xsl:text> &#8226; </xsl:text>
            </xsl:if>
            <a href="{link}">Back to the site</a>
          </footer>
        </main>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
