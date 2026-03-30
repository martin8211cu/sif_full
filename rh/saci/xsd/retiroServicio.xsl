<?xml version="1.0" encoding="utf-8"?><!-- DWXMLSource="arch.xml" -->
<!DOCTYPE xsl:stylesheet  [
	<!ENTITY nbsp   "&#160;">
	<!ENTITY copy   "&#169;">
	<!ENTITY reg    "&#174;">
	<!ENTITY trade  "&#8482;">
	<!ENTITY mdash  "&#8212;">
	<!ENTITY ldquo  "&#8220;">
	<!ENTITY rdquo  "&#8221;"> 
	<!ENTITY pound  "&#163;">
	<!ENTITY yen    "&#165;">
	<!ENTITY euro   "&#8364;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="utf-8"/>
<xsl:template match="/">
<!---<table cellpadding="0" cellspacing="0">--->
	<tr><td align="right"><label>Paquete</label>
		</td><td>&nbsp;<xsl:value-of select="retiroServicio/paquete/nombrePaquete"/></td>
	</tr>
	<tr><td align="right"><label>Motivo de Retiro</label>
		</td><td>&nbsp;<xsl:value-of select="retiroServicio/motivoRetiro/nombreMotivo"/></td>
	</tr>
	<tr><td align="right"><label>Fecha de Retiro</label>
		</td><td>&nbsp;<xsl:value-of select="retiroServicio/fechaSolicitadaRetiro"/></td>
	</tr>
	<tr><td align="right"><label>Devolución de Depósito</label>
		</td><td>&nbsp;
			<xsl:if test="retiroServicio/devolucionDeposito = 'true'">Si</xsl:if>
			<xsl:if test="retiroServicio/devolucionDeposito = 'false'">No</xsl:if>
		</td>
	</tr>
<!---</table>--->
</xsl:template>
</xsl:stylesheet>