<cfcomponent>
	<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="DEid" 			type="numeric" 	required="yes">
		<cfargument name="Pid" 				type="numeric" 	required="yes" default="">
		<cfargument name="PEfechaini" 		type="date" required="no" default="">
		<cfargument name="PEfechafin" 		type="date" required="no" default="">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no" default="#session.usucodigo#">
		
		<cfquery datasource="#session.dsn#">
			insert into PEmpleado (
				 DEid,
				 Pid ,
				 PEfechaini,
				 PEfechafin,
				 BMUsucodigo   
			)
   			values(
			    #arguments.DEid#,
				#arguments.Pid#,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.PEfechaini)#">,
			    <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.PEfechafin)#">,
				#arguments.BMUsucodigo#
			)
		</cfquery>
			
		<cfquery name="rsSelectId" datasource="#session.dsn#">
			select max(ID_PEmpleado)as id from PEmpleado
		</cfquery>
		<cfreturn #rsSelectId.id#>
	</cffunction>
	

	<cffunction name="CAMBIO" access="public" returntype="numeric">
	    <cfargument name="ID_PEmpleado"		type="numeric" 	required="yes">
		<cfargument name="DEid" 			type="numeric" 	required="yes">
		<cfargument name="Pid" 				type="numeric" 	required="yes" default="">
		<cfargument name="PEfechaini" 		type="date" required="no" default="">
		<cfargument name="PEfechafin" 		type="date" required="no" default="">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no" default="#session.usucodigo#">

		<cfquery datasource="#session.dsn#">
			update 		PEmpleado
            set 		DEid=			#arguments.DEid#,
						Pid=			#arguments.Pid#,
						PEfechaini=		<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.PEfechaini)#">,
						PEfechafin=		<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.PEfechafin)#">,
						BMUsucodigo=	#arguments.BMUsucodigo#
						
			where ID_PEmpleado=			#arguments.ID_PEmpleado#
		</cfquery>
		<cfreturn #arguments.ID_PEmpleado#>
	</cffunction>
	<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="ID_PEmpleado" 	type="numeric" required="yes">

		<cfquery datasource="#session.dsn#">
			delete from PEmpleado
			where ID_PEmpleado=#arguments.ID_PEmpleado#
		</cfquery>
		<cfreturn #arguments.ID_PEmpleado#>
	</cffunction>
</cfcomponent>