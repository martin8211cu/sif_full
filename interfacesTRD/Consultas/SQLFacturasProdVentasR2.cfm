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
	<cfset url.Regresa="ProcFactProdVent.cfm">
</cfif>

<cfquery name="rsErrores" datasource="sifinterfaces">
	select *, 'CC' as Modulo, 
	case when invoiceType in ('F','G','K','p','R','W','w','P') then 'FC' 
		 when invoiceType = 'c' then 'NC'
		 else 'ND' end as c_tipo_folio
	from sif_interfaces..facturasProdVentPMI
	where MensajeError is null
	and sessionid = #session.monitoreo.sessionid#
</cfquery>

<cfif isdefined("rsErrores") and rsErrores.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Ventas de Producto FACT" 
			filename="Ventas de Producto FACT-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesTRD/componentesInterfaz/#url.Regresa#?botonsel=nada&CodICTS=#ETQCodICTS#">
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
						<td nowrap align="left"><strong>Contrato</strong></td>
						<td nowrap align="left"><strong>Documento</strong></td>
						<td nowrap align="left"><strong>Socio</strong></td>
						<td nowrap align="left"><strong>Producto</strong></td>
						<td nowrap align="left"><strong>Fecha Voucher</strong></td>
						<td nowrap align="left"><strong>No. Voucher</strong></td>
						<td nowrap align="right"><strong>Importe</strong></td>
						<td nowrap align="right"><strong>IVA</strong></td>
						<td nowrap align="left"><strong>Moneda</strong></td>
						<td nowrap align="left"><strong>Modulo</strong></td>
						<td nowrap align="left"><strong>Tipo Trans.</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsErrores">
						<tr>
							<td nowrap >#rsErrores.yourrefnum#</td>
							<td nowrap >#rsErrores.invoice#</td>
							<td nowrap >#rsErrores.acct_num#</td>
							<td nowrap >#rsErrores.cmdty_code#</td>
							<td nowrap >#dateformat(rsErrores.voucher_creation_date,"dd/mm/yyyy")#</td>
							<td nowrap >#rsErrores.voucher_num#</td>
							<td nowrap align="right">#numberformat(rsErrores.montocosto, ",9.00")#</td>
							<td nowrap align="right">#numberformat(rsErrores.f_iva, ",9.00")#</td>
							<td nowrap >#rsErrores.voucher_curr_code#</td>
							<td nowrap >#rsErrores.Modulo#</td>
							<td nowrap >#rsErrores.c_tipo_folio#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>