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
	<cfset url.Regresa="ProcNoFactProd.cfm">
</cfif>
<cfif not IsDefined("url.ModoV") AND not IsDefined("form.ModoV")>
	<cfabort showerror="Variable ModoV no definida">
<cfelseif not IsDefined("url.ModoV") AND IsDefined("form.ModoV")>
	<cfset url.ModoV = form.ModoV>
	<cfset varModoRegreso="?ModoV=#form.ModoV#">
<cfelse>
	<cfset varModoRegreso="?ModoV=#url.ModoV#">
	<cfset form.ModoV = url.ModoV>
</cfif>
<cfset varRegresa = "#url.Regresa##varModoRegreso#&botonsel=nada">

<cfif url.ModoV EQ 2>
	<cfquery name="rsProductos" datasource="sifinterfaces">
	<!--- fechavoucher --->
		select distinct acct_ref_num as orden,Documento as documento,acct_num as Nsocio, 
						cmdty_code as producto, max(title_tran_date) as fechavoucher, 
						trade_num as vouchernum, Total as importe, price_curr_code as moneda, tipo_modulo as modulo, 
						tipo_transaccion as tipotransaccion
		from nofactProdPMI a1
		where MensajeError is null
		and sessionid=#session.monitoreo.sessionid#
		group by sessionid,trade_num,acct_num,cmdty_code
		order by Documento
	</cfquery>
	<cfset varIncluye = ", Incluye Documentos con costos Parciales rev ICTS">
<cfelse>
	<cfquery name="rsProductos" datasource="sifinterfaces">
		<!--- fechavoucher --->
		select distinct acct_ref_num as orden,Documento as documento,acct_num as Nsocio, 
						cmdty_code as producto, max(title_tran_date) as fechavoucher, 
						trade_num as vouchernum, Total as importe, price_curr_code as moneda, tipo_modulo as modulo, 
						tipo_transaccion as tipotransaccion
		from nofactProdPMI a1
		where not Exists (Select 1 from nofactProdPMI a2
							 where a1.Documento = a2.Documento
							 and a2.MensajeError is not null)
		and sessionid=#session.monitoreo.sessionid#
		group by sessionid,Documento,cmdty_code	
		order by Documento
	</cfquery>
	<cfset varIncluye = "">
</cfif>

<cfif isdefined("rsProductos") and rsProductos.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Documentos NoFACT de Producto#varIncluye#" 
			filename="NoFact Producto-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesTRD/componentesInterfaz/#varRegresa#&CodICTS=#ETQCodICTS#">

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
						<strong>NoFact de Productos#varIncluye#</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						<td nowrap><strong>Contrato</strong></td>
						<td nowrap><strong>Documento</strong></td>
						<td nowrap align="left"><strong>Socio</strong></td>
						<td nowrap align="left"><strong>Producto</strong></td>
						<td nowrap align="left"><strong>Fecha Propiedad</strong></td>
						<td nowrap align="left"><strong>No. Trade</strong></td>
						<td nowrap align="right"><strong>Importe</strong></td>
						<td nowrap align="left"><strong>Moneda</strong></td>
						<td nowrap align="left"><strong>Módulo</strong></td>
						<td nowrap align="left"><strong>T.T.</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsProductos">
						<tr>
							<td nowrap >#rsProductos.orden#</td>
							<td nowrap >#rsProductos.documento#</td>
							<td nowrap >#rsProductos.Nsocio#</td>
							<td nowrap >#rsProductos.producto#</td>
							<td nowrap >#dateformat(rsProductos.fechavoucher,"dd/mm/yyyy")#</td>
							<td nowrap >#rsProductos.vouchernum#</td>
							<td nowrap align="right">#numberformat(rsProductos.importe, ",9.00")#</td>
							<td nowrap align="center" >#rsProductos.moneda#</td>
							<td nowrap >#rsProductos.modulo#</td>
							<td nowrap >#rsProductos.tipotransaccion#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>


