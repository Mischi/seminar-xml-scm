<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://schemas.example.com/project project.xsd"
  xmlns:p="http://schemas.example.com/project"
  xmlns:u="http://schemas.example.com/user">
  <!--xpath-default-namespace="http://shemas.example.com/project"  -->
  <xsl:output method="html" indent="no"/>
   
  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="p:project/p:name"/></title>
        <link rel="stylesheet" type="text/css" href="project.css" />
      </head>
      <body>
        <nav>
          <div class="centered">
            <a id="nav-commits" href="#commits" class="active">Commits</a>
            <a id="nav-user" href="#user">User</a>
          </div>
        </nav>
        <main class="centered">
          <header>
            <div id="hero">
              <h1><xsl:value-of select="p:project/p:name"/></h1>
              <p><xsl:value-of select="p:project/p:description"/></p>
            </div>
          </header>
          <section id="commits">
            <h2>Latest Commits</h2>
            <xsl:apply-templates select="p:project/p:commits/p:commit">
              <!-- sort commits by date with newest commits first -->
              <xsl:sort select="p:date" order="descending"/>
            </xsl:apply-templates>
          </section>
          <section id="users" class="hidden">
            <h2>User</h2>
              <div id="users-container">
                <xsl:apply-templates select="p:project/p:users/u:user"></xsl:apply-templates>
              </div>
          </section>
        </main>
        <footer>
            <div class="centered">
              <p>Wahlpflichtfach XML, Prof. Dr. Renate Meyer</p>
              <p>&#169; Copyright 2013 by Fabian Raetz</p>
            </div>
        </footer>
        <script type="text/javascript" src="project.js"></script>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="u:user">
    
    <xsl:variable name="fullName" select="concat(u:firstname, ' ', u:lastname)"></xsl:variable>
    <xsl:variable name="authoredCommitsCount" select="count(/p:project/p:commits/p:commit[p:author=current()/@id])"></xsl:variable>

    <article class="user">
      <xsl:attribute name="style"><xsl:value-of select="concat('background-image: url(', u:image, ')')" /></xsl:attribute>
      <div class="details">
        <h3>
          <xsl:value-of select="$fullName" />
        </h3>
        <xsl:if test="u:contact/u:email">
          <h4>Mail</h4>
          <ul>
            <xsl:for-each select="u:contact/u:email">
                <xsl:if test="@type='primary'">
                  <li><xsl:value-of select="." /> 
                    <span class="primary"> PRIMARY</span>
                  </li>
                </xsl:if>
                <xsl:if test="@type!='primary'">
                  <li><xsl:value-of select="." /></li>
                </xsl:if>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <xsl:if test="u:contact/u:aim">
          <h4>AIM</h4>
          <ul>
            <xsl:for-each select="u:contact/u:aim">
              <li><xsl:value-of select="." /></li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <p>
          Authored <xsl:value-of select="$authoredCommitsCount" /> commits.
        </p>
      </div>
    </article>
  </xsl:template>
  
  <xsl:template match="p:commit">
    <!-- Declare author and commiter as local variable -->
    <xsl:variable name="author" select="/p:project/p:users/u:user[@id=current()/p:author][1]"/>
    <xsl:variable name="commiter" select="/p:project/p:users/u:user[@id=current()/p:commiter][1]"/>
    
    <xsl:variable name="authorFullName" select="concat($author/u:firstname, ' ', $author/u:lastname)"></xsl:variable>
    <xsl:variable name="commiterFullName" select="concat($commiter/u:firstname, ' ', $commiter/u:lastname)"></xsl:variable>  
    
    <article class="commit">
        <!-- More Infos about details element. 
             http://html5doctor.com/the-details-and-summary-elements/ 
             
             NOTE: Only supported in Google Chrome -->
        <details>
          <summary>
            <div class="summary-container">
              <div class="summary-image">
                <img src="{$author/u:image}" alt="Profilbild {$author/u:firstname} {$author/u:lastname}"/>
              </div>
              <div class="summary-info">
                <p>
                  <xsl:value-of select="@id" /> - 
                  <xsl:value-of select="concat(substring(p:message, 1, 35), ' ...')" />
                  <!--<xsl:value-of select="format-dateTime(p:date, '[D01]/[M01]/[Y0001]')" />-->
                </p>
              </div>
            </div>
          </summary>  
          <div class="content">
            <p>Authored by <xsl:value-of select="$authorFullName" /></p>
            <!-- only display the commiter if the author is not the commiter -->
            <xsl:if test="$author[@id] != $commiter[@id]">
              <p>Commited by <xsl:value-of select="$commiterFullName" /></p>
            </xsl:if>
            <h4>Commit Message</h4>
            <p><xsl:value-of select="p:message" /></p>
            <h4>Diff</h4>
            <pre><xsl:value-of select="p:diff" /></pre>
          </div>
        </details>
    </article>
  </xsl:template>
  
</xsl:stylesheet>
