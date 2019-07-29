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
            <xsl:call-template name="acquisition">
                <xsl:with-param name="office" select="$office"/>
                <xsl:with-param name="expertList" select="$expertList"/>
            </xsl:call-template>
        </office>
    </xsl:template>

    <xsl:template name="acquisition">
        <xsl:param name="office"/>
        <xsl:param name="expertList"/>
        <xsl:for-each select="$office/owner[string(.)]">
            <xsl:variable name="xprId" select="substring-after(substring-before(., ' '), 'E')"/>
            <xsl:variable name="type" select="substring-after(., ' ')"/>
            <xsl:variable name="ref" select="concat('xpr', format-number(number($xprId), '0000'))"/>
            <!-- @todo simplifier cette variable une fois que nous aurons tout mis au propre -->
            <xsl:variable name="record" select="$expertList//record[concat('xpr', format-number(number(substring-after(child::id, 'E')), '0000')) = $ref]"/>
            <xsl:variable name="ownerOrder">
                <xsl:number count="owner" level="any" from="$office"/>
            </xsl:variable>
            <event type="acquisition">
                <person ref="{$ref}"/>
                <xsl:if test="$record/(acquisitionDate | endActivity)[string(.)]">
                    <date>
                        <xsl:call-template name="acquisitionFrom">
                            <xsl:with-param name="record" select="$record"/>
                        </xsl:call-template>
                        <xsl:call-template name="acquisitionTo">
                            <xsl:with-param name="record" select="$record"/>
                        </xsl:call-template>
                    </date>
                </xsl:if>
                <type><xsl:value-of select="$type"/></type>
                <xsl:if test="$record/propertySource[string(.)]">
                    <bibl type="protertyStart"><xsl:value-of select="$record/propertySource"/></bibl>
                </xsl:if>
                <xsl:if test="$record/endActivity = 'Décès' and $record/deathSource[string(.)]">
                    <bibl type="propertyEnd"><xsl:value-of select="$record/deathSource[string(.)]"/></bibl>
                </xsl:if>
            </event>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="acquisitionFrom">
        <xsl:param name="record"/>
        <xsl:choose>
            <xsl:when test="$record/acquisitionDate = 'Création'">
                <xsl:choose>
                    <xsl:when test="number(parent::record/office) &lt; 50">
                        <xsl:attribute name="from"><xsl:value-of select="'1690'"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="from"><xsl:value-of select="'1693'"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$record/acquisitionDate[string(.)]">
                    <xsl:attribute name="from" select="$record/acquisitionDate"></xsl:attribute>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="acquisitionTo">
        <xsl:param name="record"/>
        <xsl:choose>
            <xsl:when test="$record/endActivity = 'Décès'">
                <xsl:variable name="deathDate" select="$record/deathDate"/>
                <xsl:attribute name="to" select="$deathDate"/>
            </xsl:when>
            <xsl:when test="$record/endActivity = '1791'">
                <xsl:attribute name="to" select="'1791'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="office | owner"/>

    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
