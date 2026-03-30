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

<cfinclude template="query-lista.cfm">

<cfif isdefined("rsProductos") and rsProductos.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Futuros Abiertos" 
			filename="FuturosAbiertos-#Session.Usucodigo#.xls" 
			ira="index.cfm?botonsel=btnLista&CodICTS=#ETQCodICTS#">

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