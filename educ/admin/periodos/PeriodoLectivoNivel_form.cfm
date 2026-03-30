
<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
	<cfif Form.nivel EQ 3 >
		<cfinclude template="PeriodoEvaluacion_form.cfm">
		
	<cfelse>
		<cfinclude template="PeriodoLectivo_form.cfm">
	</cfif>
</cfif>