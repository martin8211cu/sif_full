<cfsetting requesttimeout="3600"> 

<cfparam name="url.formato" default="HTML">

<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa="/cfmx/interfacesTRD/componentesInterfaz/futuros-abiertos/index.cfm?botonsel=btnLista">
</cfif>

<cfquery name="rsErrores" datasource="sifinterfaces">
	select distinct <!--- DISTINCT porque podrian tener distintos item_num --->
		broker_name, port_num, port_short_name, cobertura_VR_FE	+ 
					case when venta_realizada = 1 then '-VR' else '-VNR' end as cobertura_VR_FE
		, mtm_pl, currency_code,
		trade_num, acct_ref_num, acct_num,
		mensajeerror
	from futurosabiertosPMI
	where sessionid = #session.monitoreo.sessionid#
	  and mensajeerror is not null
	order by port_num, port_short_name, trade_num
</cfquery>

<cfif isdefined("rsErrores") and rsErrores.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado más de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango más pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Errores del Proceso de Extracción" 
			filename="Errores del Proceso de Extracción-#Session.Usucodigo#.xls" 
			ira="#url.Regresa#">
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
		</cfoutput>
					<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td nowrap><strong>Broker</strong></td>
						<td nowrap><strong>Portafolio</strong></td>
						<td nowrap align="left"><strong>Estrategia</strong></td>
						<td nowrap align="left"><strong>Tipo Cobertura</strong></td>
						<td align="right" nowrap><strong>Importe</strong></td>
						<td align="right" nowrap>&nbsp;</td>
						<td nowrap align="left"><strong>Trade Producto </strong></td>
						<td nowrap align="left"><strong>Acct Ref Num </strong></td>
						<td nowrap align="left"><strong>Error</strong></td>
					  </tr>
					<cfoutput query="rsErrores" group="port_num">
					<cfset first_trade = true>
					<tr><td colspan="8">&nbsp;</td></tr>
					<cfoutput>
						<tr>
							<td align="left" nowrap >#HTMLEditFormat(rsErrores.broker_name)#</td>
							<td align="left" nowrap >#rsErrores.port_num#</td>
							<td align="left" nowrap >#HTMLEditFormat(rsErrores.port_short_name)#</td>
							<td align="left" nowrap >#HTMLEditFormat(rsErrores.cobertura_VR_FE)#</td>
							<td nowrap align="right" ><cfif first_trade>#NumberFormat(rsErrores.mtm_pl,',0.00')#</cfif></td>
							<td align="left" nowrap ><cfif first_trade>#rsErrores.currency_code#</cfif></td>
							<td align="left" nowrap >#rsErrores.trade_num#<cfif Len(rsErrores.trade_num) is 0>N/D</cfif></td>
							<td align="left" nowrap >#rsErrores.acct_ref_num#</td>
							<td align="left" >#Replace (HTMLEditFormat(rsErrores.mensajeerror), '$$', '<br />', 'all')#</td>
						</tr>
						<cfset first_trade = false>
						</cfoutput>					</cfoutput>
					</table>
<br /><br /><br /><br /></body></head>
</cfif>
