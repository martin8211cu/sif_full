<!--- Consultas --->
<!--- Validación de la Placa --->
<cfquery name="rsExistePlaca" datasource="#session.dsn#">
	select 1
	from Activos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DSplaca#">
</cfquery>

<cfif rsExistePlaca.RecordCount is 0>
	<cflocation url="activosPorPlaca.cfm?existe=0">
</cfif>

<!--- Pintado de la consulta --->
<cf_templateheader title="Activos Fijos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Activos por Placa'>
			
			<!--- Inicia los include para el pintado del reporte y exportación a Excel --->
			<cfinclude template="../../../portlets/pNavegacionAF.cfm">
			<cf_rhimprime datos="/sif/af/consultas/activosPorPlaca/activosPorPlaca_Reporte.cfm" paramsuri="&DSplaca=#form.DSplaca#&Imprime=true&Periodo=#form.Periodo#&Periodoini=#form.Periodoini#&Mes=#form.Mes#&Mesini=#form.Mesini#&Aid=#form.Aid#">
				<cfinclude template="activosPorPlaca_Reporte.cfm">
			</cf_rhimprime>
			<!--- Inicia los include para el pintado del reporte y exportación a Excel --->		
		
		<cf_web_portlet_end>
	<cf_templatefooter>