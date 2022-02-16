<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="#all">

    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/record">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                 xmlns:foaf="http://xmlns.com/foaf/0.1/"
                 xmlns:dct="http://purl.org/dc/terms/"
                 xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
                 xmlns:dcat="http://www.w3.org/ns/dcat#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 xmlns:spdx="http://spdx.org/rdf/terms#"
                 xmlns:adms="http://www.w3.org/ns/adms#"
                 xmlns:prov="http://www.w3.org/ns/prov#"
                 xmlns:owl="http://www.w3.org/2002/07/owl#"
                 xmlns:schema="http://schema.org/"
                 xmlns:locn="http://www.w3.org/ns/locn#"
                 xmlns:gml="http://www.opengis.net/gml/3.2"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xsi:schemaLocation="http://www.w3.org/1999/02/22-rdf-syntax-ns# http://localhost:8080/geonetwork/xml/schemas/dcat2/schema.xsd">
            <dcat:Dataset>
                <dct:identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                    <xsl:value-of select="identifier"/>
                </dct:identifier>
                <dct:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                    <xsl:value-of select="issued"/>
                </dct:issued>
                <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                    <xsl:value-of select="modified"/>
                </dct:modified>
                <dct:title rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                    <xsl:value-of select="title"/>
                </dct:title>
                <dct:description rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                    <xsl:value-of select="description"/>
                </dct:description>

                <!-- TODO: determine language? -->
                <dct:language rdf:resource="http://id.loc.gov/vocabulary/iso639-2/eng"/>

                <xsl:if test="landingPage != ''">
                    <dcat:landingPage>
                        <foaf:Document rdf:about="https://www.google.com">
                            <xsl:attribute name="rdf:about" select="landingPage"></xsl:attribute>
                        </foaf:Document>
                    </dcat:landingPage>
                </xsl:if>

                <dct:license rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                    <xsl:value-of select="license"></xsl:value-of>
                </dct:license>

                <xsl:if test="accessLevel = 'public'">
                    <dct:accessRights>
                        <skos:Concept rdf:about="http://publications.europa.eu/resource/authority/access-right/PUBLIC">
                            <rdf:type rdf:resource="http://purl.org/dc/terms/RightsStatement"/>
                            <skos:prefLabel xml:lang="eng">public</skos:prefLabel>
                            <skos:inScheme
                                    rdf:resource="http://publications.europa.eu/resource/authority/access-right"/>
                        </skos:Concept>
                    </dct:accessRights>
                </xsl:if>

                <xsl:for-each select="keyword">
                    <dcat:keyword rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                        <xsl:value-of select="."/>
                    </dcat:keyword>
                </xsl:for-each>

                <xsl:if test="publisher != ''">
                    <dct:publisher>
                        <rdf:Description>
                            <skos:prefLabel rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                                <xsl:value-of select="publisher/name"/>
                            </skos:prefLabel>
                        </rdf:Description>
                    </dct:publisher>
                </xsl:if>

                <xsl:if test="contactPoint != ''">
                    <dcat:contactPoint>
                        <vcard:Contact>
                            <vcard:email rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                                <xsl:value-of select="contactPoint/hasEmail"/>
                            </vcard:email>
                            <vcard:fn rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                                <xsl:value-of select="contactPoint/fn"/>
                            </vcard:fn>
                        </vcard:Contact>
                    </dcat:contactPoint>
                </xsl:if>

                <xsl:for-each select="theme">
                    <dcat:theme rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                        <xsl:value-of select="."/>
                    </dcat:theme>
                </xsl:for-each>

                <xsl:for-each select="distribution">
                    <dcat:distribution>
                        <dct:title rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                            <xsl:value-of select="./title"/>
                        </dct:title>
                        <dct:description rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                            <xsl:value-of select="./title"/>
                        </dct:description>
                        <dcat:accessURL>
                            <xsl:value-of select="./accessURL"/>
                        </dcat:accessURL>
                        <dcat:mediaType rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                            <xsl:value-of select="./mediaType"/>
                        </dcat:mediaType>
                        <dct:format rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                            <xsl:value-of select="lower-case(./format)"/>
                        </dct:format>
                    </dcat:distribution>
                </xsl:for-each>

                <xsl:if test="spatial">
                    <xsl:variable name="extent" select="tokenize(spatial, ',')"></xsl:variable>
                    <dct:spatial>
                        <dct:Location>
                            <locn:geometry rdf:datatype="http://www.opengis.net/ont/geosparql#wktLiteral">
                                <xsl:value-of select="concat('POLYGON((',
                                    $extent[1], ' ', $extent[2],',',
                                    $extent[1], ' ', $extent[4],',',
                                    $extent[3], ' ', $extent[4],',',
                                    $extent[3], ' ', $extent[2],',',
                                    $extent[1], ' ', $extent[2],'))')" />
                            </locn:geometry>
                        </dct:Location>
                    </dct:spatial>
                </xsl:if>
            </dcat:Dataset>
        </rdf:RDF>
    </xsl:template>
</xsl:stylesheet>
