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
<table cellpadding="0" cellspacing="0" width="100%">
	<xsl:if test="cambioFormaCobro/datosFormaCobro">
		<tr><td colspan="4" align="center"><label>Forma de Cobro</label> &nbsp;
			<xsl:if test="cambioFormaCobro/datosFormaCobro/@CTcobro = '4'">
				Cuenta Corriente RACSA
			</xsl:if>
			<xsl:if test="cambioFormaCobro/datosFormaCobro/@CTcobro = '2'">
				Descargo automático a tarjeta
			</xsl:if>
			<xsl:if test="cambioFormaCobro/datosFormaCobro/@CTcobro = '1'">
				Pago automático de recibos
			</xsl:if>
		</td></tr>
		
		<xsl:if test="cambioFormaCobro/datosFormaCobro/@CTcobro = '2'">
			
			<tr>
				<td align="right"><label>Tipo Tarjeta</label> </td><td> &nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@MTid"/></td>
				<td align="right"><label>N° Tarjeta</label> </td><td> &nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTbcoRef"/></td>
			</tr>
			
			<tr>
				<td align="right"><label>Vence (mes-año)</label></td>
				<td>
					&nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTmesVencimiento"/>
					&nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTanoVencimiento"/>
				</td>
				<td  align="right"><label>Dígitos de Verificación</label> </td>
				<td></td> 
			</tr>
			<tr>
				<td align="right"><label>Nombre </label></td><td> &nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTnombreTH"/></td>
				<td align="right"><label>Apellidos</label> </td>
				<td>&nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTapellido1TH"/> 
					&nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTapellido2TH"/>
				</td>
			</tr>
			<tr>
				<td align="right"><label>País</label> </td><td > &nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@PpaisTH"/></td>
				<td align="right"><label>Cédula</label></td><td > &nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTcedulaTH"/></td>
			</tr>
		</xsl:if>
		
		<xsl:if test="cambioFormaCobro/datosFormaCobro/@CTcobro = '1'">
			<tr>
				<td align="right"><label>Banco</label></td><td>&nbsp; <xsl:value-of select="cambioFormaCobro/datosFormaCobro/@EFid"/></td>
				<td align="right"><label>Tipo Cuenta</label></td>
				<td>&nbsp;
					<xsl:if test="cambioFormaCobro/datosFormaCobro/@CTtipoCtaBco = 'C'">Corriente</xsl:if>
					<xsl:if test="cambioFormaCobro/datosFormaCobro/@CTtipoCtaBco = 'A'">Ahorro</xsl:if>
				</td>
			</tr>
			<tr>
				<td align="right"><label>N° Cuenta</label></td><td>&nbsp; <xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTbcoRef"/></td>
				<td align="right"><label>Cédula</label></td><td>&nbsp; <xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTcedulaTH"/></td>
			</tr>
			<tr>
				<td align="right"><label>Nombre</label></td><td>&nbsp; <xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTnombreTH"/></td>
				<td align="right"><label>Apellidos</label></td>
				<td>&nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTapellido1TH"/>
					&nbsp;<xsl:value-of select="cambioFormaCobro/datosFormaCobro/@CTapellido2TH"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:if>
</table>
</xsl:template>
</xsl:stylesheet>