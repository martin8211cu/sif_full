<cfsetting requesttimeout="3600"> 

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
	<cfset url.Regresa="ProcNoFactServ.cfm">
</cfif>
<cfif not IsDefined("url.ModoV")>
	<cfset varModoRegreso="?ModoV=1">
<cfelse>
	<cfset varModoRegreso="?ModoV=#url.ModoV#">
</cfif>
<cfset varRegresa = "#url.Regresa##varModoRegreso#&botonsel=nada">

<cfquery name="rsErrores" datasource="sifinterfaces">
	select title_tran_date as FechaDocumento,MensajeError,
		Documento,tipo_modulo as Modulo,montocosto as Monto,trade_num,order_num,item_num,
		cmdty_code as Producto, acct_num as NSocio
	from nofactProdPMI
	where sessionid=#session.monitoreo.sessionid#
	and MensajeError is not null
	order by Documento
</cfquery>

<cfif isdefined("rsErrores") and rsErrores.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Errores del Proceso de Extracción" 
			filename="Errores del Proceso de Extracción-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesNASA/componentesInterfaz/#varRegresa#&CodICTS=#ETQCodICTS#">
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
						<strong>Errores del Proceso Producto NoFact</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						<td nowrap><strong>Fecha Cambio Prop.</strong></td>
						<td nowrap align="left"><strong>Documento</strong></td>
						<td nowrap align="left"><strong>Socio de Negocios</strong></td>
						<td nowrap align="left"><strong>Producto</strong></td>
						<td nowrap align="left"><strong>Modulo</strong></td>
						<td nowrap align="left"><strong>Trade-Order-Item</strong></td>
						<td nowrap align="right"><strong>Monto</strong></td>
						<td nowrap align="left"><strong>Mensaje Error</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsErrores">
						<tr>
							<td nowrap >#dateformat(rsErrores.fechadocumento,"dd/mm/yyyy")#</td>
							<td nowrap >#rsErrores.Documento#</td>
							<td nowrap >#rsErrores.NSocio#</td>
							<td nowrap >#rsErrores.Producto#</td>
							<td nowrap >#rsErrores.modulo#</td>
							<td nowrap >#rsErrores.trade_num#-#rsErrores.order_num#-#rsErrores.item_num#</td>
							<td nowrap align="right">#numberformat(rsErrores.monto, ",9.00")#</td>
							<td >#rsErrores.mensajeerror#</td>
						</tr>
					</cfloop>
					</table>
		</cfoutput>
</cfif>