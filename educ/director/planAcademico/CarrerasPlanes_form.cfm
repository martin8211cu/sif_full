<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
	<cfif Form.nivel EQ 1>
		<cfinclude template="Carreras_form.cfm">
	<cfelseif Form.nivel EQ 2>
		<cfinclude template="PlanEstudios_form.cfm">
	</cfif>
</cfif>