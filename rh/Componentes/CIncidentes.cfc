<cfcomponent>
	<cffunction name="GetCIncidentes" access="public" returntype="query" hint="Funcion para recuperar toda la informacion permitente a una Incidencia">
    	<cfargument name="CIid"  		type="numeric" required="no"  hint="Id de la Incidencia">
		<cfargument name="Ecodigo"  	type="numeric" required="no"  hint="Codigo de la empresa">
        <cfargument name="Conexion"  	type="string"  required="no"  hint="Nombre del Datasource">
         
    	<CFIF NOT ISDEFINED('Arguments.Conexion')>
        	<CFSET Arguments.Conexion = session.dsn>
        </CFIF>
        <CFIF NOT ISDEFINED('Arguments.Ecodigo')>
        	<CFSET Arguments.Ecodigo = session.Ecodigo>
        </CFIF>
        
        <cfquery name="rsCIncidentes" datasource="#Arguments.Conexion#">
        	select * from CIncidentes
            	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.CIid')>
            	  and CIid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">
            </cfif>	
        </cfquery>
        
		<cfreturn rsCIncidentes>
	</cffunction>
</cfcomponent>