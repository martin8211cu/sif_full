<!---
<cf_PleaseWait SERVER_NAME="/cfmx/interfacesPMI/consultas/SQLProductosR2.cfm" > --->
<cfsetting requesttimeout="3600"> 

<cfparam name="url.formato" default="HTML">

<cfif isdefined("session.qproductos") and session.qproductos.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Compra Venta de Productos" 
			filename="CompraVentaProductos-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesPMI/componentesInterfaz/ProcFactProd.cfm">

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
						<strong>#session.DescripcionICTS#</strong>	
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
						<td nowrap align="left"><strong>Tipo Venta</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="session.qproductos">
						<tr>
							<td nowrap >#session.qproductos.orden#</td>
							<td nowrap >#session.qproductos.documento#</td>
							<td nowrap >#session.qproductos.Nsocio#</td>
							<td nowrap >#session.qproductos.producto#</td>
							<td nowrap >#dateformat(session.qproductos.fechavoucher,"dd/mm/yyyy")#</td>
							<td nowrap >#session.qproductos.vouchernum#</td>
							<td nowrap align="right">#numberformat(session.qproductos.importe, ",9.00")#</td>
							<td nowrap align="right">#numberformat(session.qproductos.iva, ",9.00")#</td>
							<td nowrap align="center" >#session.qproductos.moneda#</td>
							<td nowrap >#session.qproductos.modulo#</td>
							<td nowrap >#session.qproductos.tipotransaccion#</td>
							<td nowrap >#session.qproductos.tipoventa#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>


