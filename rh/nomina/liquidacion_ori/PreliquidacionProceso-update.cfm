<cfif isdefined("form.paso")>
	<cfswitch expression="#form.paso#"> 
		<cfcase value="0">
			<cfinclude template="liquidacionProceso-paso0-SQL.cfm">
		</cfcase>
		<cfcase value="1"> 
			<cfinclude template="liquidacionProceso-paso1-SQL.cfm">
		</cfcase> 
		<cfcase value="2">
			<cfinclude template="liquidacionProceso-paso2-SQL.cfm">
		</cfcase>
		<cfcase value="3">
			<cfinclude template="liquidacionProceso-paso3-SQL.cfm">
		</cfcase>
		<cfcase value="4">
			<cfinclude template="liquidacionProceso-paso4-SQL.cfm">
		</cfcase>		
	</cfswitch> 
</cfif>