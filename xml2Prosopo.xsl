<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" 
  xpath-default-namespace="" xmlns="xpr"
  version="2.0">
  
  <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="csv">
    <listPerson>
      <xsl:apply-templates/>
    </listPerson>
  </xsl:template>
  
  <xsl:template match="record">
    <xsl:variable name="names" select="name | firstName"/>
    <xsl:variable name="num" select="concat(
      'xpr', 
      format-number(number(substring-after(id, 'E')), '0000')
      )"/>
    <person xml:id="{$num}">
      <xsl:call-template name="persName">
        <xsl:with-param name="names" select="$names"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </person>
    
  </xsl:template>
  
  <xsl:template name="persName">
    <xsl:param name="names"/>
    <persName>
      <forename>
        <xsl:value-of select="$names[1]"/>
      </forename>
      <surname>
        <xsl:value-of select="$names[2]"/>
      </surname>
    </persName>
    <xsl:apply-templates select="variant"/>
  </xsl:template>
  
  <xsl:template match="variant">
    <persName type="variant">
      <surname><xsl:value-of select="."/></surname>
    </persName>
  </xsl:template>
  
  <!-- Copie à l'identique du fichier (toutes les passes) -->
  <xsl:template match="node()|@*" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="#current" />
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>