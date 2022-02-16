<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:dcat="http://www.w3.org/ns/dcat#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                exclude-result-prefixes="#all">

  <xsl:import href="distribution-mapping.xsl">

  </xsl:import>
  <xsl:output method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/record">
    <rdf:RDF xmlns:skos="http://www.w3.org/2004/02/skos/core#"
             xmlns:foaf="http://xmlns.com/foaf/0.1/"
             xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
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
          <xsl:value-of select="datasetid"/>
        </dct:identifier>
        <!--
                <dct:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
                  <xsl:value-of select="issued"/>
                </dct:issued>
        -->
        <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
          <xsl:value-of select="metas/modified"/>
        </dct:modified>
        <dct:title rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
          <xsl:value-of select="metas/title"/>
        </dct:title>
        <dct:description rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
          <xsl:value-of select="metas/description"/>
        </dct:description>

        <!-- TODO: iso3 ? -->
        <dct:language>
          <xsl:attribute name="resource" namespace="rdf">
            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/iso639-2/', metas/language)"></xsl:value-of>
          </xsl:attribute>
        </dct:language>

        <dct:license rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
          <xsl:value-of select="metas/license"></xsl:value-of>
        </dct:license>

        <xsl:if test="accessLevel = 'Open Database License (ODbL)'">
          <dct:accessRights>
            <skos:Concept rdf:about="http://publications.europa.eu/resource/authority/access-right/PUBLIC">
              <rdf:type rdf:resource="http://purl.org/dc/terms/RightsStatement"/>
              <skos:prefLabel xml:lang="eng">public</skos:prefLabel>
              <skos:inScheme
                      rdf:resource="http://publications.europa.eu/resource/authority/access-right"/>
            </skos:Concept>
          </dct:accessRights>
        </xsl:if>

        <xsl:for-each select="metas/keyword">
          <dcat:keyword rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
            <xsl:value-of select="."/>
          </dcat:keyword>
        </xsl:for-each>

        <xsl:if test="metas/publisher != ''">
          <dct:publisher>
            <rdf:Description>
              <skos:prefLabel rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                <xsl:value-of select="metas/publisher"/>
              </skos:prefLabel>
            </rdf:Description>
          </dct:publisher>
        </xsl:if>

        <xsl:if test="author_email != ''">
          <dcat:contactPoint>
            <vcard:Contact>
              <vcard:email rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                <xsl:value-of select="author_email"/>
              </vcard:email>
            </vcard:Contact>
          </dcat:contactPoint>
        </xsl:if>

        <xsl:for-each select="metas/theme">
          <dcat:theme rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
            <xsl:value-of select="."/>
          </dcat:theme>
        </xsl:for-each>

        <xsl:if test="metas/records_count > 0">
          <xsl:call-template name="distribution">
            <xsl:with-param name="format">csv</xsl:with-param>
            <xsl:with-param name="fields"><xsl:copy-of select="fields"></xsl:copy-of></xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="distribution">
            <xsl:with-param name="format">json</xsl:with-param>
            <xsl:with-param name="fields"><xsl:copy-of select="fields"></xsl:copy-of></xsl:with-param>
          </xsl:call-template>
          <xsl:if test="count(features[. = 'geo']) > 0">
            <xsl:call-template name="distribution">
              <xsl:with-param name="format">geojson</xsl:with-param>
              <xsl:with-param name="fields"><xsl:copy-of select="fields"></xsl:copy-of></xsl:with-param>
            </xsl:call-template>
            <xsl:if test="number(records_count)  &lt; 5000">
              <xsl:call-template name="distribution">
                <xsl:with-param name="format">shapefile</xsl:with-param>
                <xsl:with-param name="fields"><xsl:copy-of select="fields"></xsl:copy-of></xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:if>
        </xsl:if>

        <!--domain-->
        <!--geographic_reference-->
        <!--metadata_processed-->
        <!--data_processed-->
        <!--territory-->
        <!--license_url-->

        <!--
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
        -->
      </dcat:Dataset>
    </rdf:RDF>
  </xsl:template>

  <xsl:template name="distribution">
    <xsl:param name="format" />
    <xsl:param name="fields" />
    <xsl:variable name="description">
      <xsl:for-each select="$fields/fields">
        <xsl:value-of select="concat('- *', label, '* : ', name, '[', type, ']\n')" />
      </xsl:for-each>
    </xsl:variable>

    <dcat:distribution>
      <dct:description rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
        <xsl:value-of select="$description"/>
      </dct:description>
      <dct:title rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
        <xsl:value-of select="concat($format, ' Format')"/>
      </dct:title>
      <dcat:accessURL>
        <xsl:value-of select="concat(nodeUrl, '/explore/dataset/', datasetid, '/download?format=', $format, '&amp;timezone=Europe/Berlin&amp;use_labels_for_header=false')" />
      </dcat:accessURL>
      <dcat:mediaType rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
        <xsl:value-of select="$format-mimetype-mapping/entry[format=lower-case($format)]/mimetype"/>
      </dcat:mediaType>
      <dct:format rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
        <xsl:value-of select="$format"/>
      </dct:format>
    </dcat:distribution>
  </xsl:template>

</xsl:stylesheet>
