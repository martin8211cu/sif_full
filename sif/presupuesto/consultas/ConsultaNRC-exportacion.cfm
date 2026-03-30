<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<cfsetting requesttimeout="3600"> 
<cfparam name="url.formato" default="HTML">
<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa="Reversion.cfm">
</cfif>

<!---<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">
<cf_navegacion name="fltTipoVenta" 		navegacion="" session default="-1">
<cf_navegacion name="fltProducto" 		navegacion="" session default="-1">
<cf_navegacion name="fltTipoDoc" 		navegacion="" session default="-1">
<cf_navegacion name="Grupo1" 		navegacion="" session default="-1">
<cf_navegacion name="MovAd" 		navegacion="" session default="-1">--->
<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select Edescripcion
	from Empresas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsErrores" datasource="#Session.DSN#">
	select NRC_Numero, CPNAPnum, NRCD_Periodo, NRCD_Mes, NRC_Numero, CPNAPnum,  m.CPcuenta, NRCD_Periodo, NRCD_Mes, MontoComprometido,
	MontoEjecutar, CPformato  
	from MensNRCD m
	inner join CPresupuesto p on m.CPcuenta = p.CPcuenta
	where NRC_Numero = <cfqueryparam cfsqltype="cf_sql_integer" value="#NRC_Numero#">
</cfquery>

<cfif isdefined("rsErrores") and rsErrores.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif rsErrores.recordcount EQ 0>
	<cfthrow message="No existen registros que mostrar">
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Errores de Compromiso" 
			filename="ErroresCompromiso-#rsErrores.NRC_Numero#.xls" 
			ira="../consultas/ConsultaNRC-form.cfm">

		<cf_templatecss>
		<cfflush interval="512">
		<cfoutput>

				<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
					<tr>
						<td colspan="12">&nbsp;</td>
						<td align="right"><strong>#DateFormat(now(),"DD/MM/YYYY")#</strong></td>
					</tr>					
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>"#rsEmpresa.Edescripcion#"</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Errores al aplicar la Póliza</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						<td nowrap align="rigth"><strong>Cuenta</strong></td>
						<td nowrap align="rigth"><strong>Periodo</strong></td>
						<td nowrap align="rigth"><strong>Mes</strong></td>
						<td nowrap align="rigth"><strong>Monto Comprometido</strong></td>
						<td nowrap align="rigth"><strong>Monto Ejecutar</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsErrores">
						<tr>
							<td nowrap>#rsErrores.CPformato#</td>
							<td nowrap>#rsErrores.NRCD_Periodo#</td>
							<td nowrap>#rsErrores.NRCD_Mes#</td>
							<td nowrap>#rsErrores.MontoComprometido#</td>
							<td nowrap>#rsErrores.MontoEjecutar#</td>
						</tr>
					</cfloop>
					</table>
		</cfoutput>
</cfif>


