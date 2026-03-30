
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

<cfquery name="rsCodICTS" datasource="sifinterfaces">
	select EQUempOrigen as CodICTS, EQUempSIF as Ecodigo, EQUcodigoSIF as EcodigoSDC, EQUdescripcion as Edescripcion
	from SIFLD_Equivalencia
	where EQUcodigoSIF = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	and CATcodigo = 'CADENA'
</cfquery>

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
	select *
	from PrevIntVentasEnc enc 
    inner join PrevIntVentasDet det on enc.voucher_num=det.voucherNum
	where mensajeError <>'ok'
    and voucher_book_comp_num=#ETQCodICTS#
    and invoiceType in ('F','G','K','p','R','W','w','P','C','D') 
	</cfquery>

<cfif isdefined("rsErrores") and rsErrores.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Ventas de Producto FACT Errores del Proceso de Extracción" 
			filename="VentasFACTErrores-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesNASA/componentesInterfaz/#url.Regresa#?botonsel=nada&CodICTS=#ETQCodICTS#">
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
						<strong>Errores del Proceso</strong>
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
						<td nowrap align="right"><strong>Importe</strong></td>
						<td nowrap align="right"><strong>IVA</strong></td>
						<td nowrap align="left"><strong>Moneda</strong></td>
						<td nowrap align="left"><strong>Modulo</strong></td>
						<td nowrap align="left"><strong>Tipo Trans.</strong></td>
						<td nowrap align="left"><strong>Mensaje Error.</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsErrores">
						<tr>
							<td nowrap >#rsErrores.yourrefnum#</td>
							<td nowrap >#rsErrores.invoice#</td>
							<td nowrap >#rsErrores.contraparte#</td>
							<td nowrap >#rsErrores.cost_code#</td>
							<td nowrap align="right">#numberformat(rsErrores.importe, ",9.00")#</td>
							<td nowrap align="right">#numberformat(rsErrores.iva, ",9.00")#</td>
							<td nowrap >#rsErrores.c_moneda#</td>
							<td nowrap >#rsErrores.Modulo#</td>
							<td nowrap >#rsErrores.transaccion#</td>
							<td nowrap >#rsErrores.MensajeError#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>

