<cfcomponent>

	<cffunction name="delErrors" access="public" output="no" returntype="void">
		<cfargument name="Spcodigo" 	required = "yes"	type="string">
        <cfargument name="Ecodigo" 		type="numeric" 		default="#session.Ecodigo#">

		<cfquery name="delError" datasource="#session.dsn#">
			DELETE from ErrorProceso
		    WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
		    	AND Spcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Spcodigo#">
		        AND Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		</cfquery>
	</cffunction>

	<cffunction name="insertErrors" access="public" output="no" returntype="void">
		<cfargument name="Spcodigo" 	required = "yes"	type="string">
        <cfargument name="Descripcion" 	required = "yes"	type="string">
		<cfargument name="Valor" 		required = "false"	type="string">
		<cfargument name="Ecodigo" 							type="numeric" 		default="#session.Ecodigo#">
		<cfargument name="borrarTabla" 						type="boolean"		default="no">

		<cfif arguments.borrarTabla>
			<cfset delErrors(arguments.Spcodigo,arguments.Ecodigo)>
		</cfif>

		<cfquery name="insError" datasource="#session.dsn#">

			INSERT INTO ErrorProceso
		    (
		    		[Ecodigo]
		           ,[Spcodigo]
		           ,[Usucodigo]
		           ,[Descripcion]
		     	<cfif isdefined("arguments.Valor")>
		           ,[Valor]
		        </cfif>
		     )
		     VALUES
		     (
		           <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">,
		           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Spcodigo#">,
		           <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		           <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Descripcion#">
		         <cfif isdefined("arguments.Valor")>
		           ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Valor#">
		         </cfif>
		    )

		</cfquery>

	</cffunction>

</cfcomponent>