<cfif isdefined("Form.tab") and Len(Trim(Form.tab)) and Form.tab EQ 5>
	<cfif isdefined("Form.op") and Len(Trim(Form.op))>
		<cfif Form.op EQ 0>
			<cfinclude template="ConcursosMng-sqlAddConcursante.cfm">
		<cfelseif Form.op EQ 2>
			<cfinclude template="ConcursosMng-sqlDescalificar.cfm">
		<cfelseif Form.op EQ 3>
			<cfinclude template="ConcursosMng-sqlCalificar.cfm">
		<cfelseif Form.op EQ 4>
			<cfinclude template="ConcursosMng-sqlDelConcursante.cfm">
		</cfif>
	</cfif>
</cfif>
