<cfsetting requesttimeout="3600"> 

<cfparam name="url.formato" default="HTML">

<cfquery name="rsProductos" datasource="sifinterfaces">
	select *
	from #session.Dsource#futuroscerradosPMI
	where sessionid=#session.monitoreo.sessionid#
	  and mensajeerror is null
</cfquery>

<cfif isdefined("rsProductos") and rsProductos.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Futuros Cerrados" 
			filename="FuturosCerrados-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesTRD/componentesInterfaz/ProcFutuCerr.cfm">

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
						<strong>Futuros Cerrados</strong>
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
						<td nowrap align="left"><strong>Fecha Mercado</strong></td>
						<td nowrap align="left"><strong>No. Trade</strong></td>
						<td nowrap align="right"><strong>Monto</strong></td>
						<td nowrap align="left"><strong>Moneda</strong></td>
						<td nowrap align="left"><strong>Módulo</strong></td>
						<td nowrap align="left"><strong>T.T.</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsProductos">
						<tr>
							<td nowrap >#rsProductos.acct_ref_num#</td>
							<td nowrap >#rsProductos.documento#</td>
							<td nowrap >#rsProductos.acct_num#</td>
							<td nowrap >#rsProductos.cmdty_code#</td>
							<td nowrap >#dateformat(rsProductos.market_day,"dd/mm/yyyy")#</td>
							<td nowrap >#rsProductos.trade_num#</td>
							<td nowrap align="right">#numberformat(rsProductos.mtm_pl, ",9.00")#</td>
							<td nowrap align="center" >#rsProductos.currency_code#</td>
							<td nowrap >#rsProductos.modulo#</td>
							<td nowrap >FC</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>
