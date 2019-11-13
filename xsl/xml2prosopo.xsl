<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs" 
    xpath-default-namespace=""
    xmlns="eac"
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
        <bio xmlns="xpr">
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
        <xsl:variable name="deathSource">
            <xsl:choose>
                <xsl:when test="deathSource = 'IAD'">
                    <xsl:value-of select="iadSource[1]"/>
                </xsl:when>
                <xsl:when test="not(deathSource = 'IAD') and not(deathSource = '')">
                    <xsl:value-of select="deathSource"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- occupation -->
        <xsl:variable name="occupation" select="title"/>
        <!--Almanachs-->
        <xsl:variable name="almanachEntry" select="almanachEntry"/>
        <xsl:variable name="almanachExit" select="almanachExit"/>
        <!-- honoraire -->
        <xsl:variable name="honorary" select="honorary"/>
        <!-- academy -->
        <xsl:variable name="academy" select="academy"/>
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
        <!-- lettre de provision -->
        <xsl:variable name="provision" select="provisionDate"/>
        <!-- dispense -->
        <xsl:variable name="dispense" select="dispense"/>
        <!-- réception -->
        <xsl:variable name="dateReception" select="dateReception"/>
        <xsl:variable name="sourceReception" select="sourceReception"/>
        <!-- fin de l'activité -->
        <xsl:variable name="officeSuccessor" select="successor"/>
        <xsl:variable name="dateEndActivity" select="dateEndActivity"/>
        <xsl:variable name="endActivity" select="endActivity"/>
        <!-- Inventaire après décès / estate inventory -->
        <xsl:variable name="iad" select="iad"/>
        <xsl:variable name="iadSource" select="iadSource[position() = 1]"/>
        <xsl:variable name="iadEtude" select="iadEtude"/>
        <xsl:variable name="iadSource2" select="iadSource[position() = 2]"/>
        <xsl:variable name="iadPhoto" select="iadPhoto"/>
        <!-- notes/commentaire -->
        <xsl:variable name="note" select="normalize-space(note)"/>
        <xsl:variable name="commentary" select="normalize-space(commentary)"/>
        <eac-cpf xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xpr="xpr" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:rico="rico" xml:id="{$id}">
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
                    <!--birth-->
                    <xsl:with-param name="birthPlace" select="$birthPlace"/>
                    <xsl:with-param name="birthSource" select="$birthSource"/>
                    <!--death-->
                    <xsl:with-param name="deathSource" select="$deathSource"/>
                    <!-- occupation -->
                    <xsl:with-param name="occupation" select="$occupation"></xsl:with-param>
                    <!--functions (à partir de l'Almanach)-->
                    <xsl:with-param name="almanachEntry" select="$almanachEntry"/>
                    <xsl:with-param name="almanachExit" select="$almanachExit"/>
                    <!-- honorary -->
                    <xsl:with-param name="honorary" select="$honorary"/>
                    <!-- academy -->
                    <xsl:with-param name="academy" select="$academy"/>
                    <!-- mariage -->
                    <xsl:with-param name="spouse" select="$spouse"/>
                    <xsl:with-param name="etude" select="$etude"/>
                    <xsl:with-param name="etudeBis" select="$etudeBis"/>
                    <!-- master -->
                    <xsl:with-param name="master" select="$master"/>
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
                    <!-- provision Letter -->
                    <xsl:with-param name="provision" select="$provision"/>
                    <!-- exemption -->
                    <xsl:with-param name="dispense" select="$dispense"/>
                    <!-- reception -->
                    <xsl:with-param name="dateReception" select="$dateReception"/>
                    <xsl:with-param name="sourceReception" select="$sourceReception"/>
                    <!-- end Activity -->
                    <xsl:with-param name="dateEndActivity" select="$dateEndActivity"/>
                    <xsl:with-param name="endActivity" select="$endActivity"/>
                </xsl:call-template>
            </cpfDescription>
            <xsl:choose>
                <xsl:when test="($commentary = '' and $note = '') 
                    or (not($note = '') and $commentary = '')
                    or (not($commentary = '') and $note = '')">
                    <xpr:comment><xsl:value-of select="$note"/><xsl:value-of select="$commentary"/></xpr:comment>
                </xsl:when>
                <xsl:when test="not($commentary = '') and not($note = '')">
                    <xpr:comment><xsl:value-of select="$note"/></xpr:comment>
                    <xpr:comment><xsl:value-of select="$commentary"/></xpr:comment>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </eac-cpf>
    </xsl:template>

    <xsl:template name="names">
        <xsl:param name="id"/>
        <xsl:param name="names"/>
        <xsl:param name="variant"/>
        <identity localType="expert">
            <entityId><xsl:value-of select="$id"/></entityId>
            <entityType>person</entityType>
            <nameEntry>
                <part><xsl:value-of select="concat($names[1], ', ', $names[2])"/></part>
                <authorizedForm/>
            </nameEntry>
            <nameEntry>
                <part localType="surname"><xsl:value-of select="$names[1]"/></part>
                <part localType="forename"><xsl:value-of select="$names[2]"/></part>
                <part localType="particle"/>
                <part localType="common"/>
                <part localType="formal"/>
                <part localType="academic"/>
                <part localType="religious"/>
                <part localType="nobiliary"/>
                <alternativeForm/>
                <xpr:source xlink:href=""/>
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
                    <xpr:source xlink:href=""/>
                </nameEntry>
            </xsl:if>
        </identity>
    </xsl:template>
    
    <xsl:template name="description">
        <!-- existDates -->
        <xsl:param name="birthDate"/>
        <xsl:param name="deathDate"/>
        <!-- birth -->
        <xsl:param name="birthPlace"/>
        <xsl:param name="birthSource"/>
        <!-- death -->
        <xsl:param name="deathSource"/>
        <!-- occupation -->
        <xsl:param name="occupation"/>
        <!-- functions -->
        <xsl:param name="almanachEntry"/>
        <xsl:param name="almanachExit"/>
        <!-- honorary -->
        <xsl:param name="honorary"/>
        <!-- academy -->
        <xsl:param name="academy"/>
        <!-- mariage -->
        <xsl:param name="spouse"/>
        <xsl:param name="etude"/>
        <xsl:param name="etudeBis"/>
        <!-- master -->
        <xsl:param name="master"/>
        <!--provision-->
        <xsl:param name="provision"/>
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
        <!-- exemption -->
        <xsl:param name="dispense"/>
        <!-- reception -->
        <xsl:param name="dateReception"/>
        <xsl:param name="sourceReception"/>
        <!-- relinquishment -->
        <xsl:param name="dateEndActivity"/>
        <xsl:param name="endActivity"/>
        <description>
            <xsl:call-template name="existDates">
                <xsl:with-param name="birthDate" select="$birthDate"/>
                <xsl:with-param name="deathDate" select="$deathDate"/>
            </xsl:call-template>
            <xsl:call-template name="occupation">
                <xsl:with-param name="occupation" select="$occupation"/>
            </xsl:call-template>
            <xsl:call-template name="functions">
                <xsl:with-param name="almanachEntry" select="$almanachEntry"/>
                <xsl:with-param name="almanachExit" select="$almanachExit"/>
                <xsl:with-param name="officeCategory" select="$officeCategory"/>
                <xsl:with-param name="honorary" select="$honorary"/>
                <xsl:with-param name="academy" select="$academy"/>
            </xsl:call-template>
            <biogHist>
                <chronList>
                    <xsl:call-template name="birthEvent">
                        <xsl:with-param name="birthDate" select="$birthDate"/>
                        <xsl:with-param name="birthPlace" select="$birthPlace"/>
                        <xsl:with-param name="birthSource" select="$birthSource"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="marriageContract">
                        <xsl:with-param name="spouse" select="$spouse"/>
                        <xsl:with-param name="etude" select="$etude"/>
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
                        <xsl:with-param name="officeAcquisitionDate" select="$officeAcquisitionDate"/>
                        <xsl:with-param name="officeCategory" select="$officeCategory"/>
                        <xsl:with-param name="officeCost" select="$officeCost"/>
                        <xsl:with-param name="officeCostMentionned" select="$officeCostMentionned"/>
                        <xsl:with-param name="officeId" select="$officeId"/>
                        <xsl:with-param name="officePredecessor" select="$officePredecessor"/>
                        <xsl:with-param name="officeSuccessor" select="$officeSuccessor"/>
                        <xsl:with-param name="officeVacant" select="$officeVacant"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="provision">
                        <xsl:with-param name="provision" select="$provision"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="dispense">
                        <xsl:with-param name="dispense" select="$dispense"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="reception">
                        <!-- reception -->
                        <xsl:with-param name="dateReception" select="$dateReception"/>
                        <xsl:with-param name="sourceReception" select="$sourceReception"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="endActivity">
                        <xsl:with-param name="officeSuccessor" select="$officeSuccessor"/>
                        <xsl:with-param name="officeId" select="$officeId"/>
                        <xsl:with-param name="dateEndActivity" select="$dateEndActivity"/>
                        <xsl:with-param name="endActivity" select="$endActivity"/>
                    </xsl:call-template>
                    
                    <xsl:call-template name="deathEvent">
                        <xsl:with-param name="deathDate" select="$deathDate"/>
                        <xsl:with-param name="deathSource" select="$deathSource"/>
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
    
    <xsl:template name="occupation">
        <xsl:param name="occupation"/>
        <occupations>
            <occupation>
                <term><xsl:value-of select="$occupation"/></term>
                <dateRange>
                    <fromDate standardDate=""/>
                    <toDate standardDate=""/>
                </dateRange>
            </occupation>
        </occupations>
    </xsl:template>
    
    <xsl:template name="functions">
        <!-- @todo sources pour indiquer qu'il s'agit des informations tirées des almanachs -->
        <!-- @todo vérifier dans les almanachs lorsqu'ils changent de colonne pour avoir chaques intervalles -->
        <xsl:param name="officeCategory"/>
        <xsl:param name="almanachEntry"/>
        <xsl:param name="almanachExit"/>
        <xsl:param name="honorary"/>
        <xsl:param name="academy"/>
        <xsl:variable name="honorary">
            <xsl:choose>
                <xsl:when test="string(lower-case($honorary)) = 'non'
                    or $honorary = 'sans objet'
                    or $honorary =''">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <xsl:when test="substring-after($honorary, '(')">
                    <xsl:value-of select="substring-after(substring-before($honorary, ')'), '(')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$honorary"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <functions>
            <xsl:choose>
                <xsl:when test="$officeCategory = 'E' or $officeCategory = 'E (mention LP)'">
                    <function>
                        <term>Expert entrepreneur</term>
                        <dateRange>
                            <fromDate standardDate="{$almanachEntry}"/>
                            <toDate standardDate="{$almanachExit}"/>
                        </dateRange>
                    </function>
                </xsl:when>
                <xsl:when test="$officeCategory = 'A'">
                    <function>
                        <term>Expert bourgeois</term>
                        <dateRange>
                            <fromDate standardDate="{$almanachEntry}"/>
                            <toDate standardDate="{$almanachExit}"/>
                        </dateRange>
                    </function>
                </xsl:when>
                <xsl:when test="$officeCategory = 'arpenteur (E)'">
                    <function>
                        <term>Arpenteur</term>
                        <dateRange>
                            <fromDate standardDate="{$almanachEntry}"/>
                            <toDate standardDate="{$almanachExit}"/>
                        </dateRange>
                    </function>
                </xsl:when>
                <xsl:when test="$officeCategory = 'E puis A' or 'E puis A (voir convention)'">
                    <function>
                        <term>Expert entrepreneur</term>
                    </function>
                    <function>
                        <term>Expert bourgeois</term>
                    </function>
                </xsl:when>
                <xsl:when test="$officeCategory = 'A puis E'">
                    <function>
                        <term>Expert bourgeois</term>
                    </function>
                    <function>
                        <term>Expert entrepreneur</term>
                    </function>
                </xsl:when>
                <!-- @todo  les autres cas qui ne figurent vraisemblablement pas-->
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:if test="not($honorary = '')">
                <function>
                    <term>Honoraire</term>
                    <dateRange>
                        <fromDate standardDate="{substring-before($honorary, '-')}"/>
                        <toDate standardDate="{substring-after($honorary, '-')}"/>
                    </dateRange>
                </function>
            </xsl:if>
            <xsl:if test="not($academy = '' or $academy = 'néant')">
                <function>
                    <term>Membre de l'Académie <xsl:value-of select="$academy"/></term>
                    <dateRange>
                        <fromDate standardDate=""/>
                        <toDate standardDate=""/>
                    </dateRange>
                </function>
            </xsl:if>
        </functions>
    </xsl:template>
    
    <xsl:template name="birthEvent">
        <xsl:param name="birthDate"/>
        <xsl:param name="birthPlace"/>
        <xsl:param name="birthSource"/>
        <xsl:choose>
            <xsl:when test="not($birthDate = '')">
                <chronItem localType="birth">
                    <date standardDate="{$birthDate}"/>
                    <placeEntry><xsl:value-of select="$birthPlace"/></placeEntry>
                    <event>Naissance</event>
                    <rico:participant xlink:href="" type=""/>
                    <rico:involve xlink:href=""/>
                    <xpr:source xlink:href="{replace(normalize-space($birthSource), ' ', '')}"/>
                </chronItem>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="marriageContract">
        <xsl:param name="spouse"/>
        <xsl:param name="etude"></xsl:param>
    </xsl:template>
    
    <xsl:template name="mariage">
        <xsl:param name="spouse"/>
        <!-- @todo à quoi correspondent mariageEtude et mariageEtudeBis -->
        <xsl:param name="etude"/>
        <xsl:param name="etudeBis"/>
        <xsl:variable name="etude">
            <xsl:choose>
                <xsl:when test="not($etude = '')">
                    <xsl:value-of select="concat('xprNotaryOffice', format-number(number($etude), '000'))"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="string($spouse)">
            <xsl:choose>
                <xsl:when test="starts-with($spouse, '1/') and matches($spouse, '2/')">
                    <xsl:variable name="firstSpouse" select="substring-after(substring-before($spouse, ' 2/'), '1/')"/>
                    <xsl:variable name="secondSpouse" select="substring-after($spouse, ' 2/')"/>
                    <chronItem localType="marriage">
                        <date/>
                        <placeEntry/>
                        <event>Mariage</event>
                        <rico:participant xlink:href="" type=""><xsl:value-of select="normalize-space($firstSpouse)"/></rico:participant>
                        <rico:involve xlink:href="TODO{$etude}"/>
                        <xpr:source xlink:href=""/>
                    </chronItem>
                    <chronItem localType="marriage">
                        <date/>
                        <placeEntry/>
                        <event>Mariage</event>
                        <rico:participant xlink:href="" type=""><xsl:value-of select="normalize-space($secondSpouse)"/></rico:participant>
                        <rico:involve xlink:href="TODO{$etude}"/>
                        <xpr:source xlink:href=""/>
                    </chronItem>
                </xsl:when>
                <xsl:otherwise>
                    <chronItem localType="marriage">
                        <date/>
                        <placeEntry/>
                        <event>Mariage</event>
                        <rico:participant xlink:href="" type=""><xsl:value-of select="normalize-space($spouse)"/></rico:participant>
                        <rico:involve xlink:href="{$etude}"/>
                        <xpr:source xlink:href=""/>
                    </chronItem>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="master">
        <xsl:param name="master"/>
        <xsl:if test="string($master)">
            <chronItem localType="master">
                <xsl:choose>
                    <xsl:when test="$master castable as xs:date">
                        <date standardDate="{normalize-space($master)}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- @todo -->
                        <xsl:comment><xsl:value-of select="normalize-space($master)"/></xsl:comment>
                    </xsl:otherwise>
                </xsl:choose>
                <placeEntry/>
                <event>Maîtrise maç.<!-- @todo label avec $masterTitle ?--></event>
                <rico:participant xlink:href="" type=""/>
                <rico:involve xlink:href=""/>
                <xpr:source xlink:href=""/>
            </chronItem>
        </xsl:if>
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
        
        <xsl:variable name="officeId">
            <xsl:choose>
                <xsl:when test="string(number($officeId)) = 'NaN'">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('xprOffice', format-number(number($officeId), '0000'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
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
            <rico:participant xlink:href="" type=""/>
            <rico:involve xlink:href="{$officeId}"></rico:involve>
            <xpr:cost><xsl:value-of select="$officeCost"/></xpr:cost>
            <xsl:for-each select="$officePurchaseSource[position()][string(.)]">
                <xpr:source><xsl:attribute name="xlink:href"><xsl:value-of select="replace(.,' ', '')"/></xsl:attribute></xpr:source>
            </xsl:for-each>
        </chronItem>
    </xsl:template>
    
    <xsl:template name="dispense">
        <xsl:param name="dispense"/>
        <xsl:choose>
            <xsl:when test="$dispense = 'Non'
                or $dispense = ''
                or $dispense = '?'"/>
            <xsl:otherwise>
                <chronItem localType="exemption">
                    <date standardDate="{$dispense}"/>
                    <placeEntry/>
                    <event>Lettre de dispense</event>
                    <rico:participant xlink:href="" type=""/>
                    <rico:involve xlink:href=""/>
                    <xpr:source xlink:href=""/>
                </chronItem>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="provision">
        <xsl:param name="provision"/>
        <chronItem localType="provision">
            <date standardDate="{normalize-space($provision)}"/>
            <placeEntry/>
            <event>Lettre de provision</event>
            <rico:participant xlink:href="" type=""/>
            <rico:involve xlink:href=""/>
            <xpr:source xlink:href=""/>
        </chronItem>
    </xsl:template>

    <xsl:template name="reception">
        <xsl:param name="dateReception"/>
        <xsl:param name="sourceReception"/>
        <chronItem localType="reception">
            <date standardDate="{normalize-space($dateReception)}"/>
            <placeEntry/>
            <event>Réception</event>
            <rico:participant xlink:href="" type=""/>
            <rico:involve xlink:href=""/>
            <xpr:source xlink:href="{replace($sourceReception, ' ', '')}"/>
        </chronItem>
    </xsl:template>
    
    <xsl:template name="endActivity">
        <!-- @todo vérifier avec le tableau, je ne pense pas que nous puissions importer cette info en l'état -->
        <!-- @quest comment distinguer résignation et vente ? parfois les deux sont distincts -->
        <xsl:param name="officeSuccessor"/>
        <xsl:param name="officeId"/>
        <xsl:param name="dateEndActivity"/>
        <xsl:param name="endActivity"/>

        <xsl:variable name="officeId">
            <xsl:choose>
                <xsl:when test="string(number($officeId)) = 'NaN'">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('xprOffice', format-number(number($officeId), '0000'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="successorSurname" select="substring-before($officeSuccessor, ',')"/>
        <xsl:variable name="successorForename" select="substring-after($officeSuccessor, ', ')"/>
        
        <xsl:variable name="successorRef">
            <xsl:for-each select="//record[./name = $successorSurname or ./variant = $successorSurname][./firstName = $successorForename]">
                <xsl:value-of select="concat('xpr', format-number(number(substring-after(id, 'E')), '0000'))"/>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$endActivity = 'Résignation'">
                <chronItem localType="relinquishment">
                    <date standardDate=""/>
                    <event><xsl:value-of select="normalize-space($dateEndActivity)"/></event>
                    <rico:involve xlink:href="{$officeId}"/>
                    <rico:participant xlink:href="{$successorRef}" type="successor"><xsl:value-of select="$officeSuccessor"/></rico:participant>
                    <xpr:source xlink:href=""></xpr:source>
                </chronItem>
            </xsl:when>
            <xsl:when test="$endActivity = '1791'">
                <chronItem localType="officesEnding">
                    <date standardDate="{normalize-space($dateEndActivity)}"/>
                    <event>Suppression des offices</event>
                    <rico:involve xlink:href="{$officeId}"/>
                    <rico:participant xlink:href="" type=""/>
                    <xpr:source xlink:href=""></xpr:source>
                </chronItem>
            </xsl:when>
            <xsl:when test="$endActivity = 'Saisie réelle'">
                <chronItem localType="seizure">
                    <date standardDate=""></date>
                    <event><xsl:value-of select="normalize-space($dateEndActivity)"/></event>
                    <rico:involve xlink:href="{$officeId}"/>
                    <rico:participant xlink:href="" type=""/>
                    <xpr:source xlink:href=""></xpr:source>
                </chronItem>
            </xsl:when>
            <!--@rmq nous aurons vraisemblablement déjà un évènement pour le décès-->
            <xsl:when test="$endActivity = 'Décès' or $endActivity = 'décès'"/>
            <xsl:when test="$endActivity = ''"/>
            <!-- @rmq normalement il n'y a pas d'autre cas -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="deathEvent">
        <xsl:param name="deathDate"/>
        <xsl:param name="deathSource"/>
        <xsl:choose>
            <xsl:when test="not($deathDate = '')">
                <chronItem localType="death">
                    <date standardDate="{$deathDate}"/>
                    <placeEntry/>
                    <event>Décès</event>
                    <rico:participant xlink:href="" type=""/>
                    <rico:involve xlink:href=""/>
                    <xpr:source xlink:href="{replace(normalize-space($deathSource), ' ', '')}"/>
                </chronItem>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <!--<xsl:template name="iad">
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
                        <!-\- @todo ou place source de la ref (ici iadSource2) -\->
                        <note><xsl:value-of select="$iadSource2"/></note>
                    </xsl:if>
                    <xsl:if test="string($iadPhoto)">
                        <figure ref="{$iadPhoto}"/>
                    </xsl:if>
                </event>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>-->

    <xsl:template match="name 
        | id 
        | variant 
        | firstName 
        | birthDate 
        | birthParish 
        | birthSource 
        | deathDate 
        | deathSource 
        | activity 
        | aquisitionSource 
        | predecessor 
        | successor 
        | officeId 
        | acquisitionDate 
        | vacant 
        | propertySource 
        | cost 
        | category 
        | master 
        | provisionAge 
        | dateReception 
        | sourceReception
        | almanachs
        | almanachEntry
        | almanachExit
        | dateEndActivity
        | endActivity
        | honorary
        | existance
        | deathAge
        | iad
        | iadSource
        | iadEtude
        | iadSource
        | iadPhoto
        | mariageEtude
        | mariageEtudeBis
        | spouse
        | academy
        | academyPupil
        | note
        | dispense
        | provisionDate
        | commentary"/>

    <xsl:template match="costMentionned 
        | title
        | finance
        | survivance
        | cost24
        | cost12
        | cost8
        | cost4
        | costDouble
        | costTriple
        | costMarcDOr
        | seal
        | honoraries
        | laborde
        | adParisStatus
        | adParisFaillites
        | gallica
        | anSiv
        | bossu
        | lance
        | bauchal
        | gallet
        | bioSource"/>

    <xsl:template match="@* | node()" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
