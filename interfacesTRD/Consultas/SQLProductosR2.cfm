<!---
<cf_PleaseWait SERVER_NAME="/cfmx/interfacesTRD/consultas/SQLProductosR2.cfm" > --->
<cfsetting requesttimeout="3600"> 

<cfparam name="url.formato" default="HTML">

<cfquery name="rsProductos" datasource="sifinterfaces">
	select *
	from sif_interfaces..ProductosPMI
</cfquery>

<cfif isdefined("rsProductos") and rsProductos.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Compra Venta de Productos" 
			filename="CompraVentaProductos-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesTRD/componentesInterfaz/ProcFactProd.cfm">

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
						<strong>"PMI - TRADING"</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Compra y Venta de Productos</strong>
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
						<td nowrap align="left"><strong>Fecha Voucher</strong></td>
						<td nowrap align="left"><strong>No. Voucher</strong></td>
						<td nowrap align="right"><strong>Importe</strong></td>
						<td nowrap align="right"><strong>Iva</strong></td>
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
							<td nowrap align="right">#numberformat(rsProductos.iva, ",9.00")#</td>
							<td nowrap align="center" >#rsProductos.moneda#</td>
							<td nowrap >#rsProductos.modulo#</td>
							<td nowrap >#rsProductos.tipotransaccion#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>


