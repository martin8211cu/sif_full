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
<table cellpadding="1" cellspacing="0" width="100%">
	<tr><td colspan="2" class="tituloAlterno">Configuración del Paquete Actual</td></tr>
	<tr><td>
			<label><cf_traducir key="paquete">Paquete</cf_traducir></label>
			&nbsp;<xsl:value-of select="cambioPaquete/paqueteAnterior/nombrePaquete"/>
		</td>
	</tr>
	<tr><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td></tr>
		<xsl:for-each select="cambioPaquete/paqueteAnterior/login">
			<xsl:for-each select="./servicio">
			<tr><td><xsl:value-of select="../@login"/></td><td><xsl:value-of select="current()"/></td></tr>
			</xsl:for-each>	
		</xsl:for-each>
	
	<tr><td colspan="2" class="tituloAlterno">Configuración del(os) Nuevo(s) Paquete(s)</td></tr>
	<tr><td colspan="2">
			<label><cf_traducir key="paquete">Paquete</cf_traducir></label>
			&nbsp;<xsl:value-of select="cambioPaquete/paqueteNuevo/nombrePaquete"/>
		</td>
	</tr>
	<xsl:if test="cambioPaquete/paqueteNuevo/CNsuscriptor">
	<tr>
		<td><label class="tituloAlterno">Suscriptor</label> &nbsp;<xsl:value-of select="cambioPaquete/paqueteNuevo/CNsuscriptor"/></td>
		<td><label class="tituloAlterno">No.Suscriptor</label> &nbsp;<xsl:value-of select="cambioPaquete/paqueteNuevo/CNnumero"/></td>
	</tr>
	</xsl:if>
	
	<xsl:if test="cambioPaquete/loginPorConservar">
		<tr><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td></tr> 
		 <xsl:for-each select="cambioPaquete/loginPorConservar">
			<xsl:for-each select="./servicio">
				<tr><td><xsl:value-of select="../@login"/></td><td><xsl:value-of select="current()"/></td></tr>
			</xsl:for-each>
		 </xsl:for-each>
	</xsl:if>
	
	<!---<xsl:if test="cambioPaquete/loginPorBorrar">
		<tr class="tituloAlterno"><td colspan="2"><strong>Servicio(s) Por Borrar</strong></td></tr>
		<tr class=""><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td></tr>
		<xsl:for-each select="cambioPaquete/loginPorBorrar">
			<xsl:for-each select="./servicio">
			<tr><td><xsl:value-of select="../@login"/></td><td><xsl:value-of select="current()"/></td></tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:if>--->
	
	<xsl:if test="cambioPaquete/paqueteAdicional/codigoPaquete">
		<xsl:for-each select="cambioPaquete/paqueteAdicional">
			<tr><td>
				<label><cf_traducir key="paquete">Paquete</cf_traducir></label>
				&nbsp;<xsl:value-of select="./nombrePaquete"/>
				</td>
			</tr>
			<tr class=""><td><label><cf_traducir key="login">Login</cf_traducir></label></td><td><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td></tr>
			<xsl:for-each select="./login">
				<xsl:for-each select="./servicio">
				<tr><td><xsl:value-of select="../@login"/></td><td><xsl:value-of select="current()"/></td></tr>
				</xsl:for-each>	
			</xsl:for-each>
		</xsl:for-each>
	</xsl:if>
</table>
</xsl:template>
</xsl:stylesheet>