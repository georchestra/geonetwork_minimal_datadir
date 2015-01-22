geonetwork minimal datadir
==========================

The main differences with the data dir which ships with GeoNetwork in ```web/src/main/webapp/WEB-INF/data``` are:
 * it does not include the ```iso19139.fra``` schema anymore
 * schematron rules were added:
   * ```schema_plugins/iso19139/schematron/schematron-rules-iso.xsl```
   * ```schema_plugins/iso19139/schematron/schematron-rules-geonetwork.xsl```
 * several thesauri were added:
   * ```codelist/external/thesauri/theme/gemet.rdf```
   * ```codelist/external/thesauri/theme/inspire-theme.rdf```
   * ```codelist/external/thesauri/theme/inspire-service-taxonomy.rdf```
 * etc
