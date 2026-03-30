<cf_templateheader title="Cuentas Vinculadas">
	<cf_web_portlet_start titulo="Cuentas Vinculadas">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		
		<cfif isdefined("form.btnImportar")>
			<cfset form.CPPid = form.CPPid_Filtro>
			<cfinclude template="CuentasVinculadas-importar.cfm">
		<cfelse>
			<cfinclude template="CuentasVinculadas-form.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>