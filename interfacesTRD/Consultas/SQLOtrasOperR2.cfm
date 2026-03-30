<!---
<cf_PleaseWait SERVER_NAME="/cfmx/interfacesTRD/consultas/SQLErroresR2.cfm" > --->
<!--- ABG. 
		CAMBIO PARA EXTRACCION DE DATOS DE MAS DE UNA EMPRESA ICTS POR CADA EMPRESA EN SIF
		04 DE NOVIEMBRE DE 2008 --->

<cfsetting requesttimeout="3600"> 

<!--- Etiqueta para Indicar al Usuario la empresa que se esta ejecutando --->
<cfif isdefined("url.CodICTS") and len(url.CodICTS) and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset ETQCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset ETQCodICTS = form.CodICTS>
<cfelse>
	<cfset ETQCodICTS = "">
</cfif>	

<cfif isdefined("ETQCodICTS") and len(ETQCodICTS)>
	<cfquery name="rsNombre" datasource="preicts">
		select min(acct_full_name) as acct_full_name
		from account
		where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#ETQCodICTS#">
	</cfquery>
</cfif>

<cfif isdefined("rsNombre") AND rsNombre.recordcount GT 0>
	<cfset etiquetaT = " #rsNombre.acct_full_name#">
<cfelse>
	<cfset etiquetaT = "">
</cfif>


<cfparam name="url.formato" default="HTML">

<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa=" ">
</cfif>

<cfquery name="rsErrores" datasource="sifinterfaces">
	select distinct Documento,Concepto,Ccontable,TipoCD,Moneda,Tcambio,MontoCalculado
	from OtrOperaPMI
	where MensajeError is null 
	and sessionid = #session.monitoreo.sessionid#
	order by Documento
</cfquery>

<cfif isdefined("rsErrores") and rsErrores.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Futuros Otras Operaciones" 
			filename="Futuros Otras Operaciones-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesTRD/componentesInterfaz/futuros-operaciones/#url.Regresa#?CodICTS=#ETQCodICTS#">
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
						<strong>"#etiquetaT#"</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Registros a Procesar</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						<td nowrap><strong>Documento</strong></td>
						<td nowrap><strong>Descripción</strong></td>
						<td nowrap align="left"><strong>Cuenta</strong></td>
						<td nowrap align="left"><strong>Tipo Movimiento</strong></td>
						<td nowrap align="left"><strong>Moneda</strong></td>
						<td nowrap align="right"><strong>Tipo Cambio</strong></td>
						<td nowrap align="right"><strong>Monto</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsErrores">
						<tr>
							<td nowrap >#rsErrores.Documento#</td>
							<td nowrap >#rsErrores.Concepto#</td>
							<td nowrap >#rsErrores.Ccontable#</td>
							<td nowrap >#rsErrores.TipoCD#</td>
							<td >#rsErrores.Moneda#</td>
							<td align="right" >#rsErrores.Tcambio#</td>
							<td align="right" >#rsErrores.Montocalculado#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>


