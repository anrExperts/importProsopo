<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" 
    xpath-default-namespace="" xmlns="xpr"
    version="2.0">

    <xsl:strip-space elements="*"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="csv">
        <listPerson>
            <xsl:apply-templates/>
        </listPerson>
    </xsl:template>

    <xsl:template match="record">
        <!-- id -->
        <xsl:variable name="id" select="concat('xpr', format-number(number(substring-after(id, 'E')), '0000'))"/>
        <!-- names -->
        <xsl:variable name="names" select="name | firstName"/>
        <xsl:variable name="variant" select="variant"/>
        <!-- birth -->
        <xsl:variable name="birthDate" select="birthDate"/>
        <xsl:variable name="birthPlace" select="birthParish"/>
        <xsl:variable name="birthSource" select="birthSource"/>
        <!-- death -->
        <xsl:variable name="deathDate" select="deathDate"/>
        <xsl:variable name="deathPlace"/>
        <xsl:variable name="deathSource" select="deathSource"/>
        <!-- mariage -->
        <xsl:variable name="spouse" select="spouse"/>
        <xsl:variable name="etude" select="mariageEtude"/>
        <xsl:variable name="etudeBis" select="mariageEtudeBis"/>
        <!-- Maîtrise maç. -->
        <xsl:variable name="master" select="master"/>
        <!-- achat de office -->
        <!-- @quest ne faut-il pas distinguer ces deux types de source ? -->
        <xsl:variable name="officePurchaseSource" select="aquisitionSource | propertySource"/>
        <xsl:variable name="officePredecessor" select="predecessor"/>
        <xsl:variable name="officeSuccessor" select="successor"/>
        <xsl:variable name="officeId" select="officeId"/>
        <xsl:variable name="officeAcquisitionDate" select="acquisitionDate"/>
        <xsl:variable name="officeVacant" select="vacant"/>
        <xsl:variable name="officeCost" select="cost"/>
        <!-- @rmq costMentionned n'est jamais renseigné -->
        <xsl:variable name="officeCostMentionned" select="costMentionned"/>
        <xsl:variable name="officeCategory" select="category"/>
        
        <person xml:id="{$id}">
            <xsl:call-template name="names">
                <xsl:with-param name="names" select="$names"/>
                <xsl:with-param name="variant" select="$variant"/>
            </xsl:call-template>
            <xsl:call-template name="birth">
                <xsl:with-param name="birthDate" select="$birthDate"/>
                <xsl:with-param name="birthPlace" select="$birthPlace"/>
                <xsl:with-param name="birthSource" select="$birthSource"/>
            </xsl:call-template>
            <xsl:call-template name="death">
                <xsl:with-param name="deathDate" select="$deathDate"/>
                <!-- @rmq creation of deathPlace for Xforms instance -->
                <xsl:with-param name="deathPlace" select="$deathPlace"/>
                <xsl:with-param name="deathSource" select="$deathSource"/>
            </xsl:call-template>
            <xsl:call-template name="mariage">
                <xsl:with-param name="spouse" select="$spouse"/>
                <xsl:with-param name="etude" select="$etude"/>
                <xsl:with-param name="etudeBis" select="$etudeBis"/>
            </xsl:call-template>
            <xsl:call-template name="master">
                <!-- @rmq toutes les données ne sont pas formalisées en date -->
                <xsl:with-param name="master" select="$master"/>
            </xsl:call-template>
            <xsl:call-template name="officePurchase">
                <xsl:with-param name="officePurchaseSource" select="$officePurchaseSource"/>
                <xsl:with-param name="officePredecessor" select="$officePredecessor"/>
                <xsl:with-param name="officeSuccessor" select="$officeSuccessor"/>
                <xsl:with-param name="officeId" select="$officeId"/>
                <xsl:with-param name="officeAcquisitionDate" select="$officeAcquisitionDate"/>
                <xsl:with-param name="officeVacant" select="$officeVacant"/>
                <xsl:with-param name="officeCost" select="$officeCost"/>
                <xsl:with-param name="officeCostMentionned" select="$officeCostMentionned"/>
                <xsl:with-param name="officeCategory" select="$officeCategory"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </person>
    </xsl:template>

    <xsl:template name="names">
        <xsl:param name="names"/>
        <xsl:param name="variant"/>
        <persName>
            <surname>
                <xsl:value-of select="$names[1]"/>
            </surname>
            <forename>
                <xsl:value-of select="$names[2]"/>
            </forename>
        </persName>
        <!-- @rmq test if $variant is not null -->
        <xsl:if test="string($variant)">
            <persName type="variant">
                <surname>
                    <xsl:value-of select="$variant"/>
                </surname>
                <forename>
                    <xsl:value-of select="$names[2]"/>
                </forename>
            </persName>
        </xsl:if>
    </xsl:template>

    <xsl:template name="birth">
        <xsl:param name="birthDate"/>
        <xsl:param name="birthPlace"/>
        <xsl:param name="birthSource"/>
        <birth>
            <date when="{$birthDate}"/>
            <placeName>
                <xsl:value-of select="$birthPlace"/>
            </placeName>
            <bibl>
                <xsl:value-of select="$birthSource"/>
            </bibl>
        </birth>
    </xsl:template>

    <xsl:template name="death">
        <xsl:param name="deathDate"/>
        <xsl:param name="deathPlace"/>
        <xsl:param name="deathSource"/>
        <death>
            <date when="{$deathDate}"/>
            <placeName>
                <xsl:value-of select="$deathPlace"/>
            </placeName>
            <bibl>
                <xsl:value-of select="$deathSource"/>
            </bibl>
        </death>
    </xsl:template>

    <xsl:template name="mariage">
        <xsl:param name="spouse"/>
        <!-- @todo à quoi correspondent mariageEtude et mariageEtudeBis -->
        <xsl:param name="etude"/>
        <xsl:param name="etudeBis"/>
        <xsl:if test="string($spouse)">
            <xsl:choose>
                <xsl:when test="starts-with($spouse, '1/') and matches($spouse, '2/')">
                    <xsl:variable name="firstSpouse" select="substring-after(substring-before($spouse, ' 2/'), '1/')"/>
                    <xsl:variable name="secondSpouse" select="substring-after($spouse, ' 2/')"/>
                    <event type="mariage">
                        <label>Mariage</label>
                        <xsl:choose>
                            <xsl:when test="matches($firstSpouse, '\(')">
                                <persName>
                                    <xsl:value-of select="normalize-space(substring-before($firstSpouse, ' ('))"/>
                                </persName>
                                <note>
                                    <xsl:value-of select="normalize-space(concat('(', substring-after($firstSpouse, ' (')))"/>
                                </note>
                            </xsl:when>
                            <xsl:otherwise>
                                <persName>
                                    <xsl:value-of select="normalize-space($firstSpouse)"/>
                                </persName>
                            </xsl:otherwise>
                        </xsl:choose>
                    </event>
                    <event type="mariage">
                        <label>Mariage</label>
                        <xsl:choose>
                            <xsl:when test="matches($secondSpouse, '\(')">
                                <persName>
                                    <xsl:value-of select="normalize-space(substring-before($secondSpouse, ' ('))"/>
                                </persName>
                                <note>
                                    <xsl:value-of select="normalize-space(concat('(', substring-after($secondSpouse, ' (')))"/>
                                </note>
                            </xsl:when>
                            <xsl:otherwise>
                                <persName>
                                    <xsl:value-of select="normalize-space($secondSpouse)"/>
                                </persName>
                            </xsl:otherwise>
                        </xsl:choose>
                    </event>
                </xsl:when>
                <xsl:otherwise>
                    <event type="mariage">
                        <label>Mariage</label>
                        <xsl:choose>
                            <xsl:when test="matches($spouse, '\(')">
                                <persName>
                                    <xsl:value-of select="normalize-space(substring-before($spouse, ' ('))"/>
                                </persName>
                                <note>
                                    <xsl:value-of select="normalize-space(concat('(', substring-after($spouse, ' (')))"/>
                                </note>
                            </xsl:when>
                            <xsl:otherwise>
                                <persName>
                                    <xsl:value-of select="normalize-space($spouse)"/>
                                </persName>
                            </xsl:otherwise>
                        </xsl:choose>
                    </event>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="master">
        <xsl:param name="master"/>
        <xsl:if test="string($master)">
            <event type="master">
                <label>Maîtrise maç.<!-- @todo label avec $masterTitle ?--></label>
                <xsl:choose>
                    <xsl:when test="$master castable as xs:date">
                        <date when="{normalize-space($master)}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <note>
                            <xsl:value-of select="normalize-space($master)"/>
                        </note>
                    </xsl:otherwise>
                </xsl:choose>
            </event>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="title">
        <occupation><xsl:value-of select="."/></occupation>
    </xsl:template>
    
    <xsl:template name="officePurchase">
        <xsl:param name="officePurchaseSource"/>
        <xsl:param name="officePredecessor"/>
        <xsl:param name="officeSuccessor"/>
        <xsl:param name="officeId"/>
        <xsl:param name="officeAcquisitionDate"/>
        <xsl:param name="officeVacant"/>
        <xsl:param name="officeCost"/>
        <xsl:param name="officeCostMentionned"/>
        <xsl:param name="officeCategory"/>
        <xsl:variable name="predecessorSurname" select="substring-before($officePredecessor, ',')"/>
        <xsl:variable name="predecessorForename" select="substring-after($officePredecessor, ', ')"/>
        <xsl:variable name="predecessorRef">
            <xsl:for-each select="//record[./name = $predecessorSurname or ./variant = $predecessorSurname][./firstName = $predecessorForename]">
                <xsl:value-of select="concat('xpr', format-number(number(substring-after(id, 'E')), '0000'))"/>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="successorSurname" select="substring-before($officeSuccessor, ',')"/>
        <xsl:variable name="successorForename" select="substring-after($officeSuccessor, ', ')"/>
        <xsl:variable name="successorRef">
            <xsl:for-each select="//record[./name = $successorSurname or ./variant = $successorSurname][./firstName = $successorForename]">
                <xsl:value-of select="concat('xpr', format-number(number(substring-after(id, 'E')), '0000'))"/>
            </xsl:for-each>
        </xsl:variable>
        
        <event type="officePurchase">
            <label>Acquisition d'un office</label>
            <xsl:choose>
                <xsl:when test="$officeAcquisitionDate castable as xs:date">
                    <date when="{normalize-space($officeAcquisitionDate)}"/>
                </xsl:when>
                <xsl:otherwise>
                    <date><xsl:value-of select="normalize-space($officeAcquisitionDate)"/></date>
                </xsl:otherwise>
            </xsl:choose>
            <officeId ref="{$officeId}"/>
            <!-- @quest predecessor/successor plutot que persName @type -->
            <!-- @rmq je récupère les ref à la volée, mais uniquement sur le nom de famille, il faut donc vérifier les cas d'homonymie-->
            <persName ref="{$predecessorRef}" type="predecessor"><xsl:value-of select="$officePredecessor"/></persName>
            <persName ref="{$successorRef}" type="successor"><xsl:value-of select="$officeSuccessor"/></persName>
            <cost><xsl:value-of select="$officeCost"/></cost>
            <category><xsl:value-of select="$officeCategory"/></category>
            <xsl:for-each select="$officePurchaseSource[position()][string(.)]">
                <bibl><xsl:value-of select="."/></bibl>
            </xsl:for-each>
        </event>
    </xsl:template>

    <xsl:template match="name | id | variant | firstName | birthDate | birthParish | birthSource | deathDate | deathSource"/>

    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
