<cfsetting requesttimeout="3600"> 

<cfparam name="url.formato" default="HTML">

<cfquery name="rsMostrar" datasource="sifinterfaces">
	select a1.ID, a2.MontoPago, a2.CodigoTransaccion, a2.Documento, a2.MontoPagoDocumento, a2.CodigoMonedaDoc,
		   a1.EcodigoSDC from PMIINT_IE11 a1, PMIINT_ID11 a2
	where a1.ID = a2.ID
	  and a1.sessionid = #session.monitoreo.sessionid#
	order by a1.ID
</cfquery>

<cfif isdefined("rsMostrar") and rsMostrar.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Cobros Pagos" 
			filename="CobrosPagos-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesTBS/ProcCobrosPagos.cfm">

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
						<strong>Cobros Pagos</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						<td nowrap><strong>ID</strong></td>
						<td nowrap align="left"><strong>Monto Pago</strong></td>
						<td nowrap align="left"><strong>Cod. Transacción</strong></td>
						<td nowrap align="left"><strong>Documento</strong></td>
						<td nowrap align="left"><strong>Monto Doc.</strong></td>
						<td nowrap align="left"><strong>Moneda</strong></td>
						<td nowrap align="left"><strong>Empresa</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsMostrar">
						<tr>
							<td nowrap >#rsMostrar.ID#</td>
							<td nowrap align="right">#numberformat(rsMostrar.MontoPago, ",9.00")#</td>
							<td nowrap >#rsMostrar.CodigoTransaccion#</td>
							<td nowrap >#rsMostrar.Documento#</td>
							<td nowrap align="right">#numberformat(rsMostrar.MontoPagoDocumento, ",9.00")#</td>
							<td nowrap >#rsMostrar.CodigoMonedaDoc#</td>
							<td nowrap >#rsMostrar.EcodigoSDC#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>
