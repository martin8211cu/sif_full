<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<cfsetting requesttimeout="3600"> 
<cfparam name="url.formato" default="HTML">
<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa="ProcAjusteCV.cfm">
</cfif>
<cfif IsDefined("url.Periodos") AND IsDefined("url.Meses")>
	<cfset iperiodo = url.Periodos>
	<cfset imes = url.Meses>
</cfif>

<cfset varRegresa = "#url.Regresa#?Periodos=#iperiodo#&Meses=#imes#">

<cfquery name="rsACV" datasource="sifinterfaces">
	select a.OCcontrato,a.Modulo,a.OriCosto,a.BMperiodo,a.BMmes,b.Miso4217
	from ACostoVentas a inner join #minisifdb#..Monedas b on a.Ecodigo = b.Ecodigo and a.Mcodigo = b.Mcodigo
	where sessionid = #session.monitoreo.sessionid#
	and BMperiodo <= #iperiodo#
	and BMmes < #imes#
</cfquery>

<cfif isdefined("rsACV") and rsACV.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Ajuste de Costo de Ventas" 
			filename="AjusteCostoVentas-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesTRD/componentesInterfaz/AjusteCV/#varRegresa#">

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
						<strong>Ajuste Costo de Ventas</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						<td nowrap><strong>Orden Comercial</strong></td>
						<td nowrap><strong>Modulo</strong></td>
						<td nowrap align="right"><strong>Monto</strong></td>
						<td nowrap align="center"><strong>Periodo</strong></td>
						<td nowrap align="center"><strong>Mes</strong></td>
						<td nowrap align="center"><strong>Moneda</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsACV">
						<tr>
							<td nowrap >#rsACV.OCcontrato#</td>
							<td nowrap >#rsACV.Modulo#</td>
							<td nowrap align="right">#rsACV.OriCosto#</td>
							<td nowrap align="center">#rsACV.BMperiodo#</td>
							<td nowrap align="center">#rsACV.BMmes#</td>
							<td nowrap align="center">#rsACV.Miso4217#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>


