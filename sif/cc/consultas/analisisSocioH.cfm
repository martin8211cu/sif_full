<cfset Lvardireccionurl = "./analisisSocioH.cfm?SNcodigo=#url.SNcodigo#">
<cfinclude template="analisisSocioH_sql.cfm">
<cf_web_portlet_start titulo="An&aacute;lisis Hist&oacute;rico">
	<table border="1" cellpadding="0" cellspacing="2" width="100%">
		<tr>
			<td colspan="3" align="center"><strong>Detalle de Ventas</strong></td>
		</tr>
		<tr>
			<td align="left" width="15%"><strong>C&oacute;digo</strong></td>
			<td align="left" width="70%"><strong>Nombre</strong></td>
			<td align="right" width="15%"><strong>Monto</strong></td>
		</tr>
		<cfoutput query="rsVentasDireccion">
			<tr>
				<td align="left"> <a href="analisisSocioH.cfm?SNcodigo=#url.SNcodigo#&id_direccionFact=#id_direccionFact#"> #SNDcodigo#</td>
				<td align="left">#Nombre#</td>
				<td align="right">#lsNumberFormat(total,',9.00')#</td>
			</tr>
		</cfoutput>
	</table>
	<div style=" border-top:double"></div>
	
	<table border="0" width="100%">
		<cfif isdefined("LvarNombreDireccion")>
			<tr>
				<td colspan="2" align="center">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><strong>Analisis de <cfoutput>#LvarNombreDireccion#</cfoutput></strong></td>
			</tr>
			<tr>
				<td colspan="2" align="center">&nbsp;</td>
			</tr>
		</cfif>
		<tr>
			<td>
				<cfinclude template="analisisSocioH1.cfm">
			</td>
			<td>
				<cfinclude template="analisisSocioH2.cfm">
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<cfinclude template="analisisSocioH3.cfm">
			</td>
			<td>
				<cfinclude template="analisisSocioH4.cfm">
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	
	</table>
<cf_web_portlet_end>