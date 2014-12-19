geonetwork minimal datadir
==========================

Use with caution: this "data dir" is a work in progress...

The main differences with the data dir which ships with GeoNetwork in ```web/src/main/webapp/WEB-INF/data``` are:
 * it does not include the ```iso19139.fra``` schema
 * schematron rules were added:
   * ```schema_plugins/iso19139/schematron/schematron-rules-iso.xsl```
   * ```schema_plugins/iso19139/schematron/schematron-rules-geonetwork.xsl```
 * several thesauri were added:
   * ```codelist/external/thesauri/theme/gemet.rdf```
   * ```codelist/external/thesauri/theme/inspire-theme.rdf```
   * ```codelist/external/thesauri/theme/inspire-service-taxonomy.rdf```
 * updated files on both sides (they need special attention):
   * ```schema_plugins/iso19139/index-fields.xsl```
   * ```schema_plugins/iso19139/process/onlinesrc-add.xsl```
   * ```schema_plugins/iso19139/process/add-extent-from-geokeywords.xsl```
   * ```schema_plugins/iso19139/present/metadata-view.xsl```
   * ```schema_plugins/iso19139/present/metadata-edit.xsl```
   * ```schema_plugins/iso19139/loc/fre/codelists.xml```
   * ```schema_plugins/iso19139/convert/OGCWxSGetCapabilitiesto19119/identification.xsl```
   * ```schema_plugins/iso19139/convert/OGCWxSGetCapabilitiesto19119/OGCWxSGetCapabilities-to-19119.xsl```
