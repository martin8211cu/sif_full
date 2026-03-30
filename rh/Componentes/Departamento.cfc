<cfcomponent>  
	<!---Obtener Departamentos--->  
	<cffunction name="GetDepartamento" access="public" returntype="query">
    	<cfargument name="Ecodigo" 	  type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   type="string"  required="no" hint="Nombre del DataSource">
        <cfargument name="Dcodigo"    type="numeric" required="no" hint="Id Departamento">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfquery name="rsDepartamentos" datasource="#Arguments.conexion#">
         	select Ecodigo,Dcodigo,Deptocodigo,Ddescripcion 
            	from Departamentos
            where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.Dcodigo')>
            	and Dcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Dcodigo#">
                Order by Ddescripcion
            </cfif>
         </cfquery>
		<cfreturn rsDepartamentos>
	</cffunction>
	<!---Alta Departamento--->
    <cffunction name="AltaDepartamento" access="public" returntype="numeric">
    	<cfargument name="Deptocodigo"  type="string"  required="yes" 	hint="Codigo del Departamento">
        <cfargument name="Ddescripcion" type="string"  required="no" 	hint="Descripción del Departamento" default="#Arguments.Deptocodigo#">
        <cfargument name="Ecodigo" 	  	type="numeric" required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   	type="string"  required="no" 	hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfquery name="NewDcodigo" datasource="#Arguments.conexion#">
        	select Coalesce(max(Dcodigo),0) + 1 as Dcodigo
            	from Departamentos 
             where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        </cfquery>
        <cfquery name="AltaDepartamento" datasource="#Arguments.conexion#">
        	insert into Departamentos (Ecodigo,Dcodigo,Deptocodigo,Ddescripcion)
            values
            (
            	<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">,
            	<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#NewDcodigo.Dcodigo#">,                
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Deptocodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Ddescripcion#">
            )
			</cfquery>
		<cfreturn NewDcodigo.Dcodigo>
    </cffunction>
    <!---Cambio Departamento--->
    <cffunction name="CambioDepartamento" access="public" >
    	<cfargument name="Deptocodigo"  type="string"  required="no" 	hint="Codigo del Departamento">
        <cfargument name="Ddescripcion" type="string"  required="no" 	hint="Descripción del Departamento" default="#Arguments.Deptocodigo#">
        <cfargument name="Ecodigo" 	  	type="numeric" required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   	type="string"  required="no" 	hint="Nombre del DataSource">
       	<cfargument name="Dcodigo"  	type="string"  required="yes" 	hint="Codigo del Departamento">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfquery datasource="#Arguments.conexion#">    
            UPDATE Departamentos
               SET Deptocodigo  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#Arguments.Deptocodigo#">,
                   Ddescripcion = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  value="#Arguments.Ddescripcion#" >
             WHERE Ecodigo      = #Arguments.Ecodigo#
               AND Dcodigo      = <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Dcodigo#"> 
       </cfquery>
    </cffunction>  
    <!---Baja Departamentos--->
    <cffunction name="BajaDepartamento" access="public">
    	<cfargument name="Dcodigo"  type="string"  required="yes" 	hint="Codigo del Departamento">
        <cfargument name="Ecodigo" 	type="numeric" required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion" type="string"  required="no" 	hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif> 
            <cfquery datasource="#Arguments.conexion#">     
            	DELETE FROM Departamentos
             	WHERE Ecodigo      = #Arguments.Ecodigo#
               	AND Dcodigo      = <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Dcodigo#"> 
         	</cfquery>
	</cffunction>
</cfcomponent>