<cfswitch expression="#form.ArchivoIDSE#">
	<cfcase value="1">
		<cfinclude template="ImpMovimientosReingresos_form.cfm">
	</cfcase>
	<cfcase value="2">
		<cfinclude template="ImpMovimientosModificacionSalarial_form.cfm">
	</cfcase>
	<cfcase value="3">
		<cfinclude template="ImpMovimientosBaja_form.cfm">
	</cfcase>
	<!---
	<cfcase value="2">
		<cfinclude template="ImpMovimientosAusentismos_form.cfm">
	</cfcase>
	<cfcase value="3">
		<cfinclude template="ImpMovimientosIncap_form.cfm">
	</cfcase>
	<cfcase value="5">
    	<cfinclude template="RepImpIDSE_B-filtro.cfm">
	</cfcase>
    <cfcase value="6">
		<cfinclude template="RepImpIDSE-filtro.cfm">
	</cfcase>--->
</cfswitch>