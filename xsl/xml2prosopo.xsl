<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs" 
    xpath-default-namespace=""
    xmlns:rico="rico"
    xmlns:xpr="xpr"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">

    <xsl:strip-space elements="*"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="csv">
        <bio>
            <xsl:apply-templates/>
        </bio>
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

        <xsl:variable name="officeId" select="officeId"/>
        <xsl:variable name="officeAcquisitionDate" select="acquisitionDate"/>
        <xsl:variable name="officeVacant" select="vacant"/>
        <xsl:variable name="officeCost" select="cost"/>
        <!-- @rmq costMentionned n'est jamais renseigné -->
        <xsl:variable name="officeCostMentionned" select="costMentionned"/>
        <xsl:variable name="officeCategory" select="category"/>

        <!-- Résignation/Vente d'un office (par un expert) -->
        <xsl:variable name="officeSuccessor" select="successor"/>
        <xsl:variable name="dateEndActivity" select="dateEndActivity"/>
        <xsl:variable name="endActivity" select="endActivity"/>
        
        <!-- Inventaire après décès / estate inventory -->
        <xsl:variable name="iad" select="iad"/>
        <xsl:variable name="iadSource" select="iadSource[position() = 1]"/>
        <xsl:variable name="iadEtude" select="iadEtude"/>
        <xsl:variable name="iadSource2" select="iadSource[position() = 2]"/>
        <xsl:variable name="iadPhoto" select="iadPhoto"/>
        
        <!--Almanachs-->
        <xsl:variable name="almanachEntry" select="almanachEntry"/>
        <xsl:variable name="almanachExit" select="almanachExit"/>

        <eac-cpf xmlns="eac" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xpr="xpr" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rico="rico">
            <control/>
            <cpfDescription>
                <xsl:call-template name="names">
                    <xsl:with-param name="id" select="$id"/>
                    <xsl:with-param name="names" select="$names"/>
                    <xsl:with-param name="variant" select="$variant"/>
                </xsl:call-template>
                <xsl:call-template name="description">
                    <!--existDate-->
                    <xsl:with-param name="birthDate" select="$birthDate"/>
                    <xsl:with-param name="deathDate" select="$deathDate"/>
                    <!--functions (à partir de l'Almanach)-->
                    <xsl:with-param name="almanachEntry" select="$almanachEntry"/>
                    <xsl:with-param name="almanachExit" select="$almanachExit"/>
                    <!--occupation-->
                    <!--office Acquisition-->
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
                
                <!--<xsl:call-template name="birth">
                <xsl:with-param name="birthDate" select="$birthDate"/>
                <xsl:with-param name="birthPlace" select="$birthPlace"/>
                <xsl:with-param name="birthSource" select="$birthSource"/>
            </xsl:call-template>
            <xsl:call-template name="death">
                <xsl:with-param name="deathDate" select="$deathDate"/>
                <!-\- @rmq creation of deathPlace for Xforms instance -\->
                <xsl:with-param name="deathPlace" select="$deathPlace"/>
                <xsl:with-param name="deathSource" select="$deathSource"/>
            </xsl:call-template>-->
                <xsl:call-template name="mariage">
                    <xsl:with-param name="spouse" select="$spouse"/>
                    <xsl:with-param name="etude" select="$etude"/>
                    <xsl:with-param name="etudeBis" select="$etudeBis"/>
                </xsl:call-template>
                <xsl:call-template name="master">
                    <!-- @rmq toutes les données ne sont pas formalisées en date -->
                    <xsl:with-param name="master" select="$master"/>
                </xsl:call-template>
                
                <xsl:call-template name="relinquishment">
                    <xsl:with-param name="officeSuccessor" select="$officeSuccessor"/>
                    <xsl:with-param name="officeId" select="$officeId"/>
                    <xsl:with-param name="dateEndActivity" select="$dateEndActivity"/>
                    <xsl:with-param name="endActivity" select="$endActivity"/>
                </xsl:call-template>
                
                <xsl:call-template name="iad">
                    <xsl:with-param name="iad" select="$iad"/>
                    <xsl:with-param name="iadSource" select="$iadSource"/>
                    <xsl:with-param name="iadEtude" select="$iadEtude"/>
                    <xsl:with-param name="iadSource2" select="$iadSource2"/>
                    <xsl:with-param name="iadPhoto" select="$iadPhoto"/>
                </xsl:call-template>
            </cpfDescription>
            <xsl:apply-templates/>
        </eac-cpf>
    </xsl:template>

    <xsl:template name="names">
        <xsl:param name="id"/>
        <xsl:param name="names"/>
        <xsl:param name="variant"/>
        <identity>
            <entityId><xsl:value-of select="$id"/></entityId>
            <entityType>person</entityType>
            <nameEntry>
                <part localType="surname"><xsl:value-of select="$names[1]"/></part>
                <part localType="forename"><xsl:value-of select="$names[2]"/></part>
                <part localType="particle"/>
                <part localType="common"/>
                <part localType="formal"/>
                <part localType="academic"/>
                <part localType="religious"/>
                <part localType="nobiliary"/>
                <authorizedForm/>
            </nameEntry>
            <!-- @rmq test if $variant is not null -->
            <xsl:if test="string($variant)">
                <nameEntry>
                    <part localType="surname"><xsl:value-of select="$variant"/></part>
                    <part localType="forename"><xsl:value-of select="$names[2]"/></part>
                    <part localType="particle"/>
                    <part localType="common"/>
                    <part localType="formal"/>
                    <part localType="academic"/>
                    <part localType="religious"/>
                    <part localType="nobiliary"/>
                    <alternativeForm/>
                </nameEntry>
            </xsl:if>
        </identity>
    </xsl:template>
    
    <xsl:template name="description">
        <!-- existDates -->
        <xsl:param name="birthDate"/>
        <xsl:param name="deathDate"/>
        <!-- functions -->
        <xsl:param name="almanachEntry"/>
        <xsl:param name="almanachExit"/>
        <!-- Office acquisition -->
        <xsl:param name="officeAcquisitionDate"/>
        <xsl:param name="officeCategory"/>
        <xsl:param name="officeCost"/>
        <xsl:param name="officeCostMentionned"/>
        <xsl:param name="officeId"/>
        <xsl:param name="officePredecessor"/>
        <xsl:param name="officePurchaseSource"/>
        <xsl:param name="officeSuccessor"/>
        <xsl:param name="officeVacant"/>
        <description>
            <xsl:call-template name="existDates">
                <xsl:with-param name="birthDate" select="$birthDate"/>
                <xsl:with-param name="deathDate" select="$deathDate"/>
            </xsl:call-template>
            <xsl:call-template name="functions">
                <xsl:with-param name="almanachEntry" select="$almanachEntry"/>
                <xsl:with-param name="almanachExit" select="$almanachExit"/>
                <xsl:with-param name="officeCategory" select="$officeCategory"/>
            </xsl:call-template>
            <occupations>
            </occupations>
            <biogHist>
                <chronList>
                    <xsl:call-template name="officePurchase">
                        <xsl:with-param name="officeAcquisitionDate" select="$officeAcquisitionDate"/>
                        <xsl:with-param name="officeCategory" select="$officeCategory"/>
                        <xsl:with-param name="officeCost" select="$officeCost"/>
                        <xsl:with-param name="officeCostMentionned" select="$officeCostMentionned"/>
                        <xsl:with-param name="officeId" select="$officeId"/>
                        <xsl:with-param name="officePredecessor" select="$officePredecessor"/>
                        <xsl:with-param name="officeSuccessor" select="$officeSuccessor"/>
                        <xsl:with-param name="officeVacant" select="$officeVacant"/>
                    </xsl:call-template>
                </chronList>
            </biogHist>
        </description>
    </xsl:template>
    
    <xsl:template name="existDates">
        <xsl:param name="birthDate"/>
        <xsl:param name="deathDate"/>
        <existDates>
            <dateRange>
                <xsl:call-template name="birth">
                    <xsl:with-param name="birthDate" select="$birthDate"/>
                </xsl:call-template>
                <xsl:call-template name="death">
                    <xsl:with-param name="deathDate" select="$deathDate"/>
                </xsl:call-template>
            </dateRange>
        </existDates>
    </xsl:template>
    
    <xsl:template name="birth">
        <xsl:param name="birthDate"/>
        <fromDate standardDate="{$birthDate}"/>
    </xsl:template>
    
    <xsl:template name="death">
        <xsl:param name="deathDate"/>
        <toDate standardDate="{$deathDate}"/>
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
        
        <xsl:variable name="officeId" select="concat('xprOff', format-number(number($officeId), '00'))"/>
        
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
        <chronItem localType="officePurchase">
            <xsl:choose>
                <xsl:when test="$officeAcquisitionDate castable as xs:date">
                    <date standardDate="{normalize-space($officeAcquisitionDate)}"/>
                </xsl:when>
                <xsl:otherwise>
                    <date>
                        <xsl:value-of select="normalize-space($officeAcquisitionDate)"/>
                    </date>
                </xsl:otherwise>
            </xsl:choose>
            <placeEntry/>
            <event>Acquisition d'un office</event>
            <!--<xsl:choose>
                <xsl:when test="not($predecessorRef = 'Création') or not($predecessorRef = '')">
                    <rico:participant ref="{$predecessorRef}" type="predecessor"><xsl:value-of select="$officePredecessor"/></rico:participant>
                </xsl:when>
                <xsl:otherwise>
                    <rico:participant ref="" type=""><xsl:value-of select="$officePredecessor"/></rico:participant>
                </xsl:otherwise>
            </xsl:choose>-->
            <rico:involve ref="{$officeId}"></rico:involve>
            <cost>
                <xsl:value-of select="$officeCost"/>
            </cost>
            <category>
                <xsl:value-of select="$officeCategory"/>
            </category>
            <xsl:for-each select="$officePurchaseSource[position()][string(.)]">
                <xpr:source xlink:href=""><xsl:value-of select="."/></xpr:source>
            </xsl:for-each>
        </chronItem>
    </xsl:template>
    
    <xsl:template name="functions">
        <!-- @todo sources pour indiquer qu'il s'agit des informations tirées des almanachs -->
        <!-- @todo vérifier dans les almanachs lorsqu'ils changent de colonne pour avoir chaques intervalles -->
        <xsl:param name="officeCategory"/>
        <xsl:param name="almanachEntry"/>
        <xsl:param name="almanachExit"/>
        <functions>
            <xsl:choose>
                <xsl:when test="$officeCategory = 'E' or $officeCategory = 'E (mention LP)'">
                    <function>
                        <term>Entrepreneur</term>
                        <dateRange>
                            <fromDate standardDate="{$almanachEntry}"/>
                            <toDate standardDate="{$almanachExit}"/>
                        </dateRange>
                    </function>
                </xsl:when>
                <xsl:when test="$officeCategory = 'A'">
                    <function>
                        <term>Architecte</term>
                        <dateRange>
                            <fromDate standardDate="{$almanachEntry}"/>
                            <toDate standardDate="{$almanachExit}"/>
                        </dateRange>
                    </function>
                </xsl:when>
                <xsl:when test="$officeCategory = 'arpenteur (E)'">
                    <function>
                        <term>Arpenteur (entrepreneur)</term>
                        <dateRange>
                            <fromDate standardDate="{$almanachEntry}"/>
                            <toDate standardDate="{$almanachExit}"/>
                        </dateRange>
                    </function>
                </xsl:when>
                <xsl:when test="$officeCategory = 'E puis A' or 'E puis A (voir convention)'">
                    <function>
                        <term>Entrepreneur</term>
                    </function>
                    <function>
                        <term>Architecte</term>
                    </function>
                </xsl:when>
                <xsl:when test="$officeCategory = 'A puis E'">
                    <function>
                        <term>Architecte</term>
                    </function>
                    <function>
                        <term>Entrepreneur</term>
                    </function>
                </xsl:when>
                <!-- @todo  les autres cas qui ne figurent vraisemblablement pas-->
                <xsl:otherwise/>
            </xsl:choose>
        </functions>
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
        <occupation>
            <xsl:value-of select="."/>
        </occupation>
    </xsl:template>

    <xsl:template name="relinquishment">
        <!-- @quest comment distinguer résignation et vente ? parfois les deux sont distincts -->
        <xsl:param name="officeSuccessor"/>
        <xsl:param name="officeId"/>
        <xsl:param name="dateEndActivity"/>
        <xsl:param name="endActivity"/>

        <xsl:variable name="successorSurname" select="substring-before($officeSuccessor, ',')"/>
        <xsl:variable name="successorForename" select="substring-after($officeSuccessor, ', ')"/>
        <xsl:variable name="successorRef">
            <xsl:for-each select="//record[./name = $successorSurname or ./variant = $successorSurname][./firstName = $successorForename]">
                <xsl:value-of select="concat('xpr', format-number(number(substring-after(id, 'E')), '0000'))"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$endActivity = 'Résignation'">
                <event type="relinquishment">
                    <!-- @todo label -->
                    <label>Résignation/vente de l'office</label>
                    <xsl:choose>
                        <xsl:when test="$dateEndActivity castable as xs:date">
                            <date when="{normalize-space($dateEndActivity)}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <date>
                                <xsl:value-of select="normalize-space($dateEndActivity)"/>
                            </date>
                        </xsl:otherwise>
                    </xsl:choose>
                    <officeId ref="{$officeId}"/>
                    <persName ref="{$successorRef}" type="successor">
                        <xsl:value-of select="$officeSuccessor"/>
                    </persName>
                </event>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="iad">
        <xsl:param name="iad"/>
        <xsl:param name="iadSource"/>
        <xsl:param name="iadEtude"/>
        <xsl:param name="iadSource2"/>
        <xsl:param name="iadPhoto"/>
        <xsl:choose>
            <xsl:when test="string($iad)">
                <event type="estateInventory">
                    <label>Inventaire après décès</label>
                    <xsl:choose>
                        <xsl:when test="$iad castable as xs:date">
                            <date when="{normalize-space($iad)}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <date>
                                <xsl:value-of select="normalize-space($iad)"/>
                            </date>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="string($iadEtude)">
                        <office><xsl:value-of select="$iadEtude"/></office>
                    </xsl:if>
                    <xsl:if test="string($iadSource)">
                        <bibl><xsl:value-of select="$iadSource"/></bibl>
                    </xsl:if>
                    <xsl:if test="string($iadSource2)">
                        <!-- @todo ou place source de la ref (ici iadSource2) -->
                        <note><xsl:value-of select="$iadSource2"/></note>
                    </xsl:if>
                    <xsl:if test="string($iadPhoto)">
                        <figure ref="{$iadPhoto}"/>
                    </xsl:if>
                </event>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="name | id | variant | firstName | birthDate | birthParish | birthSource | deathDate | deathSource"/>

    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
