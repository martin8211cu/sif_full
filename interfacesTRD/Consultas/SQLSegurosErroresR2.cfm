<!---
<cf_PleaseWait SERVER_NAME="/cfmx/interfacesTRD/consultas/SQLErroresR2.cfm" > --->
<cfsetting requesttimeout="3600"> 

<cfparam name="url.formato" default="HTML">

<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa="ProcSeguros.cfm">
</cfif>

<cfquery name="rsErrores" datasource="sifinterfaces">
	select Documento,orden, fecha_creacion, 
		prima_cargo as monto, moneda, mensajeerror
		from #session.Dsource#segurosPMI
		where sessionid=#session.monitoreo.sessionid#
		  and mensajeerror is not null
</cfquery>

<cfif isdefined("rsErrores") and rsErrores.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Errores en Seguros" 
			filename="Seguros-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesTRD/componentesInterfaz/Seguros/ProcSeguros.cfm">

		<cf_templatecss>
		<cfflush interval="512">
		<cfoutput>

				<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
					<tr>
						<td colspan="2">&nbsp;</td>
						<td align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
					</tr>					
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>"P.M.I. TRADING"</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Errores del Proceso</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						<td nowrap align="center"><strong>Documento</strong></td>
						<td nowrap align="center"><strong>Orden</strong></td>
						<td nowrap><strong>Fecha Creacion</strong></td>
						<td nowrap align="center"><strong>Prima Monto</strong></td>
						<td nowrap align="center"><strong>Moneda</strong></td>
						<td nowrap align="center"><strong>Mensaje Error</strong></td>				
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsErrores">
						<tr>
							<td nowrap >#rsErrores.documento#</td>
							<td nowrap >#rsErrores.orden#</td>
							<td nowrap >#dateformat(rsErrores.fecha_creacion,"dd/mm/yyyy")#</td>
							<td nowrap align="right">#numberformat(rsErrores.monto, ",9.00")#</td>
							<td nowrap align="center">#rsErrores.moneda#</td>
							<td nowrap >#rsErrores.mensajeerror#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>

