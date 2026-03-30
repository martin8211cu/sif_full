<cfparam name="PermiteCierrePoliza" default="false">

<cf_templateheader title="Consulta de Polizas de Desalmacenaje">
	<cfinclude template="../../portlets/pNavegacionCM.cfm"> 
		<cf_web_portlet_start titulo='Consulta de Polizas de desalmacenaje'>
			<cfinclude template="polizaDesalmacenaje-config.cfm">
			<cfinclude template="polizaDesalmacenaje-dbcommon.cfm">
			<cfif (isdefined("modo") and lcase(modo) eq "lista")>
				<br><cfinclude template="polizaDesalmacenaje-filtro.cfm">
				<br><cfinclude template="polizaDesalmacenaje-lista.cfm"><br>
			<cfelse>
				<br><cf_rhimprime datos="/sif/cm/consultas/polizaDesalmacenaje-reporte.cfm" paramsuri="&imprime=1&EPDid=#form.EPDid#"><br>
				<br><cfinclude template="polizaDesalmacenaje-reporte.cfm"><br>
			</cfif>
		<cf_web_portlet_end>
<cf_templatefooter>