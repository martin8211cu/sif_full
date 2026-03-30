<cf_templateheader title="Cambio de Tesorería de Solicitudes de Pago Aprobadas">
	<cf_navegacion name="TESOPid">
	<cfset navegacion = "">

	<cfif isdefined("form.TESSPid")>
		<cfinclude template="solicitudesPasar_form.cfm">
	<cfelse>
		<cfinclude template="solicitudesPasar_lista.cfm">
	</cfif>
<cf_templatefooter>