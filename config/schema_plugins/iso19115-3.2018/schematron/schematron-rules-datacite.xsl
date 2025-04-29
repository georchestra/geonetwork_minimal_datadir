<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:gmd="http://standards.iso.org/iso/19115/-3/gmd"
                xmlns:gmx="http://standards.iso.org/iso/19115/-3/gmx"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/2.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                exclude-result-prefixes="#all"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is
      the preferred method for meta-stylesheets to use where possible.
    -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <xsl:include xmlns:svrl="http://purl.oclc.org/dsdl/svrl" href="../../../xsl/utils-fn.xsl"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="lang"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="thesaurusDir"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="rule"/>
   <xsl:variable xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="loc"
                 select="document(concat('../loc/', $lang, '/', $rule, '.xml'))"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1"
                          select="1+       count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+     count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@
              <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans
      (Top-level element has index)
    -->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH-->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2-->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Datacite (DOI)"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>
         
        <xsl:value-of select="$archiveNameParameter"/>
         
        <xsl:value-of select="$fileNameParameter"/>
         
        <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml" prefix="gml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gmd" prefix="gmd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gmx" prefix="gmx"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.fao.org/geonetwork" prefix="geonet"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2004/02/skos/core#" prefix="skos"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/srv/2.0" prefix="srv"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mdb/2.0" prefix="mdb"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mcc/1.0" prefix="mcc"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mri/1.0" prefix="mri"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mrs/1.0" prefix="mrs"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mrd/1.0" prefix="mrd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mco/1.0" prefix="mco"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/msr/2.0" prefix="msr"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/lan/1.0" prefix="lan"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gcx/1.0" prefix="gcx"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gex/1.0" prefix="gex"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19157/-2/dqm/1.0" prefix="dqm"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/cit/2.0" prefix="cit"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19157/-2/mdq/1.0" prefix="mdq"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mrl/2.0" prefix="mrl"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gco/1.0" prefix="gco"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
               <xsl:value-of select="$loc/strings/datacite.mandatory"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Datacite (DOI)</svrl:text>

   <!--PATTERN
        $loc/strings/datacite.mandatory-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      <xsl:copy-of select="$loc/strings/datacite.mandatory"/>
   </svrl:text>

  <!--RULE
      -->
<xsl:template match="//mdb:MD_Metadata|//*[@gco:isoType='mdb:MD_Metadata']" priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mdb:MD_Metadata|//*[@gco:isoType='mdb:MD_Metadata']"/>
      <xsl:variable name="title" select="mdb:identificationInfo/*/mri:citation/*/cit:title"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$title != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$title != ''">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/datacite.title.missing"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$title != ''">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$title != ''">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/datacite.title.present"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:copy-of select="$title"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="identifier"
                    select="string-join(mdb:metadataIdentifier/*/mcc:code/gco:CharacterString, ', ')"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$identifier != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$identifier != ''">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/datacite.identifier.missing"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$identifier != ''">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$identifier != ''">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/datacite.identifier.present"/>
               <xsl:text/>
        "<xsl:text/>
               <xsl:copy-of select="normalize-space($identifier)"/>
               <xsl:text/>"
      </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="numberOfCreators"
                    select="count(mdb:identificationInfo/*/mri:pointOfContact/*[cit:role/*/@codeListValue = ('pointOfContact', 'custodian')])"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$numberOfCreators &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$numberOfCreators &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/datacite.creator.missing"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$numberOfCreators &gt; 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$numberOfCreators &gt; 0">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$numberOfCreators"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/datacite.creator.found"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="publisher"
                    select="(mdb:distributionInfo//mrd:distributorContact)[1]//cit:CI_Organisation/cit:name/gco:CharacterString"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$publisher != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$publisher != ''">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/datacite.publisher.missing"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$publisher != ''">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$publisher != ''">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/datacite.publisher.present"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:copy-of select="$publisher"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="publicationDate"
                    select="string-join(mdb:identificationInfo/*/mri:citation/*/cit:date/*[cit:dateType/*/@codeListValue = 'publication'], ', ')"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$publicationDate != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$publicationDate != ''">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/datacite.publicationDate.missing"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$publicationDate != ''">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$publicationDate != ''">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/datacite.publicationDate.present"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:copy-of select="$publicationDate"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="type"
                    select="string-join(mdb:metadataScope/*/mdb:resourceScope/*/@codeListValue, ', ')"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$type != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$type != ''">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                  <xsl:copy-of select="$loc/strings/datacite.type.missing"/>
               </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$type != ''">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$type != ''">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:copy-of select="$loc/strings/datacite.type.present"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:copy-of select="$type"/>
               <xsl:text/>
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
</xsl:stylesheet>