<cfcomponent>
	<cffunction name="GetProyecto" output="false" access="public" returntype="query">
		<cfargument name="Conexion"  		type="string"  required="no">
		<cfargument name="Ecodigo"   		type="numeric" required="no">
		<cfargument name="OBPcodigo" 	 	type="string"  required="no">
		<cfargument name="OBPdescripcion" 	type="string"  required="no">
		<cfargument name="filtro" 			type="boolean" required="no" default="true">
		
		<cfif not isdefined('Arguments.Conexion') or NOT LEN(TRIM(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo') or NOT LEN(TRIM(Arguments.Ecodigo))>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="rsObras" datasource="#Arguments.Conexion#">
			select 0 as nivel, OP.OBPid, OP.OBPcodigo, OP.OBPdescripcion
				from OBproyecto OP 
			   where OP.Ecodigo = #Arguments.Ecodigo#
			<cfif isdefined('Arguments.OBPcodigo') and len(trim(Arguments.OBPcodigo)) and Arguments.filtro>
				and upper(OP.OBPcodigo) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Arguments.OBPcodigo)#%">
			<cfelseif isdefined('Arguments.OBPcodigo') and len(trim(Arguments.OBPcodigo))>
				and OP.OBPcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBPcodigo#">
			</cfif>
			<cfif isdefined('Arguments.OBPdescripcion') and len(trim(Arguments.OBPdescripcion)) and Arguments.filtro>
				and upper(OP.OBPdescripcion) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Arguments.OBPdescripcion)#%">
			<cfelseif isdefined('Arguments.OBPdescripcion') and len(trim(Arguments.OBPdescripcion))>
				and OP.OBPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBPdescripcion#">
			</cfif>
			order by OP.OBPcodigo, OP.OBPdescripcion
		</cfquery>
		<cfreturn rsObras>
	</cffunction>
 	<cffunction name="GetObra" output="false" access="public" returntype="query">
		<cfargument name="Conexion"  		type="string"  required="no">
		<cfargument name="Ecodigo"   		type="numeric" required="no">
		<cfargument name="OBOid" 	 		type="numeric" required="no">
		<cfargument name="OBPid" 	 		type="numeric" required="no">
		<cfargument name="OBOcodigo" 	 	type="string"  required="no">
		<cfargument name="OBOdescripcion" 	type="string"  required="no">
		<cfargument name="filtro" 			type="boolean" required="no" default="true">
		
		<cfif not isdefined('Arguments.Conexion') or NOT LEN(TRIM(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo') or NOT LEN(TRIM(Arguments.Ecodigo))>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="rsObras" datasource="#Arguments.Conexion#">
			select 1 nivel, OB.OBOid, OB.OBOcodigo, OB.OBOdescripcion, OP.OBPid, OP.OBPcodigo, OP.OBPdescripcion
				from OBobra OB 
          			inner join OBproyecto OP 
                    	on OP.OBPid = OB.OBPid 
			   where OB.Ecodigo = #Arguments.Ecodigo#
			<cfif isdefined('Arguments.OBPid') and len(trim(Arguments.OBPid))>
			     and OB.OBPid = #Arguments.OBPid#
			</cfif>
			<cfif isdefined('Arguments.OBOid') and len(trim(Arguments.OBOid))>
			     and OB.OBOid = #Arguments.OBOid#
			</cfif>
			<cfif isdefined('Arguments.OBOcodigo') and len(trim(Arguments.OBOcodigo)) and Arguments.filtro>
				and upper(OB.OBOcodigo) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Arguments.OBOcodigo)#%">
			<cfelseif isdefined('Arguments.OBOcodigo') and len(trim(Arguments.OBOcodigo))>
				and OB.OBOcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OBOcodigo#">
			</cfif>
			<cfif isdefined('Arguments.OBOdescripcion') and len(trim(Arguments.OBOdescripcion)) and Arguments.filtro>
				and upper(OB.OBOdescripcion) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Arguments.OBOdescripcion)#%">
			</cfif>
			order by OB.OBOcodigo, OB.OBOdescripcion
		</cfquery>
		<cfreturn rsObras>
	</cffunction>
</cfcomponent>
