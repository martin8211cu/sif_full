<cfif isdefined("form.paso")>
	<cfswitch expression="#form.paso#">
		<cfcase value="0">
			<cfinclude template="concursoProceso-paso0-SQL.cfm">
		</cfcase>
		<cfcase value="1">
			<cfinclude template="concursoProceso-paso1-SQL.cfm">
		</cfcase>
		<cfcase value="2">
			<cfinclude template="concursoProceso-paso2-SQL.cfm">
		</cfcase>
		<cfcase value="3">
			<cfinclude template="concursoProceso-paso3-SQL.cfm">
		</cfcase>
		<cfcase value="4">
			<cfinclude template="concursoProceso-paso4-SQL.cfm">
		</cfcase>		
	</cfswitch>
</cfif>