<!--- Actualiza el orden de los registros en las tablas que usan el campo orden 
		Requiere definir antes del include: 
			1. La variable table, que indica la tabla sobre la cual se va trabajar.
			2. La variable where, que me indica la sentencia where del query
			3. La variable orden que tiene el nombre del campo correspondiente al orden
--->

<cfif isdefined("table") and isdefined("orden") and isdefined("where")>
	<cftry>
		<cfset sql = "select " & orden & " from " & table & " where " & where >
	
		<cfquery name="rsOrden" datasource="asp">
			#preservesinglequotes(sql)#
		</cfquery>
	
		<cfif rsOrden.RecordCount gt 0>
			<cfset update = "update " & table & " set " & orden & "=" & orden & "+1 " & "where " & where_upd >
			<cfquery name="rsUpdOrden" datasource="asp">
				#preservesinglequotes(update)#
			</cfquery>
		</cfif>
	<cfcatch type="any">
		<cfset error = true>
	</cfcatch>
	</cftry> 
</cfif>