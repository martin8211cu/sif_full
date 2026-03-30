<cfsetting requesttimeout="3600"> 

<cfparam name="url.formato" default="HTML">

<cfinclude template="query-lista.cfm">

<cfif isdefined("rsProductos") and rsProductos.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Futuros Abiertos" 
			filename="FuturosAbiertos-#Session.Usucodigo#.xls" 
			ira="index.cfm?botonsel=btnLista">

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
						<strong>Futuros Abiertos</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
		  </table>
					<table width="100%">
					<tr>
						<td nowrap align="left"><strong>Portafolio</strong></td>
						<td nowrap align="left"><strong>Estrategia</strong></td>
						<td nowrap align="left"><strong>Tipo Cobertura</strong></td>
						<td nowrap align="right"><strong>MTM PL </strong></td>
						<td nowrap align="left"><strong>Moneda</strong></td>
						<td nowrap align="left"><strong>Clearing Broker</strong></td>
					</tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<cfloop query="rsFuturos">
						<tr>
							<td nowrap align="left">#port_num#</td>
							<td nowrap align="left">#port_short_name#</td>
							<td nowrap align="left">#cobertura_VR_FE#</td>
							<td nowrap align="right">#NumberFormat(mtm_pl,',0.00')#&nbsp;</td>
							<td nowrap align="left">#currency_code#</td>
						    <td nowrap align="left">#HTMLEditFormat(broker_name)#</td>
						</tr>
					</cfloop>
					</table>
		</cfoutput>
</body>
</html>
</cfif>