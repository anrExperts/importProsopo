<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" xpath-default-namespace="" xmlns="xpr" version="2.0">

    <xsl:strip-space elements="*"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="csv">
        <listOffice>
            <xsl:apply-templates/>
        </listOffice>
    </xsl:template>
    
    <xsl:template match="record">
        <xsl:variable name="id" select="concat('xprOffice', format-number(number(office), '00'))"/>
        <xsl:variable name="office" select="."/>
        <xsl:variable name="expertList" select="document('expertsFichier.xml')"/>
        <office xml:id="{$id}">
            <xsl:apply-templates/>
            <xsl:call-template name="listOwner">
                <xsl:with-param name="office" select="$office"/>
                <xsl:with-param name="expertList" select="$expertList"/>
            </xsl:call-template>
        </office>
    </xsl:template>
    
    <xsl:template name="listOwner">
        <xsl:param name="office"/>
        <xsl:param name="expertList"/>
        <listOwner>
            <xsl:for-each select="$office/owner[string(.)]">
                <xsl:variable name="xprId" select="substring-after(substring-before(., ' '), 'E')"/>
                <xsl:variable name="ref" select="concat('xpr', format-number(number($xprId), '0000'))"/>
                <!-- @todo simplifier cette variable une fois que nous aurons tout mis au propre -->
                <xsl:variable name="record" select="$expertList//record[concat('xpr', format-number(number(substring-after(id, 'E')), '0000')) = $ref]"/>
                <xsl:variable name="ownerOrder">
                    <xsl:number count="owner" level="any" from="$office"/>
                </xsl:variable>
                <xsl:choose>
                    <!-- @todo vérifier avec Juliette -->
                    <xsl:when test=". = '?'">
                        <owner n="{$ownerOrder}">Unknown</owner>
                    </xsl:when>
                    <xsl:when test=". = 'FIN'"/>
                    <xsl:otherwise>
                        <owner n="{$ownerOrder}" ref="{$ref}"><xsl:value-of select="concat($record/name, ', ', $record/firstName)"/></owner>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </listOwner>
    </xsl:template>
    
    <xsl:template match="office | owner"/>
    
    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
