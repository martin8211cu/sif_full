<cf_templateheader title="Consulta de Presupuesto">
	<cf_web_portlet_start titulo="Per&iacute;odos de Presupuesto">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfif isdefined("Form.CPcuenta") and Len(Trim(Form.CPcuenta))>
			<cfinclude template="ConsPresupuesto-form.cfm">
		<cfelse>
			<cfinclude template="ConsPresupuesto-lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
