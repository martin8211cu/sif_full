<cf_templateheader title="Anulación de TEF y TCE">
	<cf_navegacion name="TESOPid">
	<cfset titulo = 'Anulaci&oacute;n de Transferencias de Fondos y Pagos con Tarjeta de Crédito Empresarial'>
	<cfset navegacion = "">
	<cfset estadoTEF = 'in (1,2)'>
	<cfset anulacion = 1>
	<cfset irA = 'TEFanulacion.cfm'>
	<cfif isdefined("form.TESOPid") and LEN(form.TESOPid)>
		<cfinclude template="TEFanulacion_form.cfm">
	<cfelse>
		<cfinclude template="listaTEF.cfm">
	</cfif>
<cf_templatefooter>