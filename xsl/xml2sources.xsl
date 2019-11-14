<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs" 
    xpath-default-namespace=""
    xmlns:rico="rico"
    xmlns:xpr="xpr"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="3.0">
    
    <xsl:strip-space elements="*"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="csv">
        <xsl:variable name="acquisitionSource" select="//aquisitionSource"/>
        <xsl:variable name="propertySource" select="//propertySource"/>
        <xsl:variable name="receptionSource" select="//sourceReception"/>
        <xsl:variable name="birthSource" select="//birthSource"/>
        <xsl:variable name="deathSource" select="//deathSource"/>
        <xsl:variable name="iadSource" select="//iadSource"/>
        <sources>
            <xsl:for-each select="distinct-values($acquisitionSource | $propertySource | $birthSource | $birthSource | $deathSource | $iadSource)">
                <xsl:choose>
                    <xsl:when test=". = ''"/>
                    <xsl:otherwise>
                        <xsl:variable name="value" select="replace(normalize-space(.), ' ', '')"/>
                        <source><xsl:value-of select="$value"/></source>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </sources>
    </xsl:template>
    
    
    
    
    
</xsl:stylesheet>