<cf_templateheader title="Consulta de Rechazos Presupuestario">
	<cf_web_portlet_start titulo="Consulta de Rechazos Presupuestario">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfif isdefined("Form.CPNRPnum") and isdefined("Form.CPNRPDlinea")
		  and Len(Trim(Form.CPNRPnum)) and Len(Trim(Form.CPNRPDlinea))>
			<cfinclude template="ConsNRP-form.cfm">
		<cfelseif isdefined("url.lin")>
			<cfinclude template="ConsNRP-form.cfm">
		<cfelse>
			<cfinclude template="ConsPresupuesto-detallesNRP-form.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
