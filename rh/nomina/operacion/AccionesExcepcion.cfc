<cfcomponent output="true" >
	<cffunction name="getListaErr" access="remote" returnformat="JSON">
		<cfargument name="DEid" type="numeric" default="-1">
		<cfargument name="DLfvigencia" type="string" default="-1">
		<cfargument name="RHTid" type="numeric" default="-1">
				
			<cfquery name="rsTipoCambio" datasource="#Session.DSN#">

				SELECT  RHAid,DEid,DLfvigencia,RHTid, * from RHAcciones
					where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTid#">
						and DLfvigencia = <cfqueryparam cfsqltype="cf_sql_date"	 value="#arguments.DLfvigencia#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			</cfquery>

			<cfif rsTipoCambio.RecordCount neq 0>
				<cfreturn  "Ya existe un empleado para ese concepto en esta fecha.">
			<cfelse> 
				<cfreturn "CONTINUA">			
			</cfif>

	</cffunction>
</cfcomponent>
