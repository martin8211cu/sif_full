<cfif isdefined("Form.m") and Form.m EQ 1>
	<cfinclude template="PlanificaJornadas-SQL-CF.cfm">
<cfelseif isdefined("Form.m") and Form.m EQ 2>
	<cfinclude template="PlanificaJornadas-SQL-CFEmp.cfm">
<cfelseif isdefined("Form.m") and Form.m EQ 3>
	<cfinclude template="PlanificaJornadas-SQL-Empleado.cfm">
<cfelse>
	<cflocation addtoken="no" url="PlanificaJornadas.cfm">
</cfif>