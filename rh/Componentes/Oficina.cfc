<cfcomponent>  
<!---Obtener Oficinas--->
	<cffunction name="GetOficina" access="public" returntype="query">
    	<cfargument name="Ecodigo" 	  type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   type="string"  required="no" hint="Nombre del DataSource">
        <cfargument name="Ocodigo" 	  type="numeric" required="no" hint="Codigo de la Oficina">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfquery name="rsOficinas" datasource="#Arguments.conexion#">
         	select Ocodigo,Oficodigo,Odescripcion 
            	from Oficinas
            where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.Ocodigo')>
            	and Ocodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ocodigo#">
            </cfif>
         </cfquery>
		<cfreturn rsOficinas>
	</cffunction>
<!---Agregar Oficina--->
    <cffunction name="AltaOficina" access="public" returntype="numeric">
    	<cfargument name="Oficodigo"   	type="string"  required="yes" 	hint="Codigo de la Oficina">
        <cfargument name="Odescripcion" type="string"  required="yes" 	hint="Descripción de la Oficina">
        <cfargument name="Ecodigo" 	  	type="numeric" required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   	type="string"  required="no" 	hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfquery name="NewOcodigo" datasource="#Arguments.conexion#">
        	select Coalesce(max(Ocodigo),0) + 1 as Ocodigo
            	from Oficinas 
             where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        </cfquery>
        <cfquery name="AltaOficinas" datasource="#Arguments.conexion#">
        	insert into Oficinas (Ecodigo,Ocodigo,Oficodigo,Odescripcion)
            values
            (
            	<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">,
            	<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#NewOcodigo.Ocodigo#">,                
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Oficodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Odescripcion#">
            )
			</cfquery>
		<cfreturn NewOcodigo.Ocodigo>
    </cffunction> 
<!---Cambio Oficina--->
    <cffunction name="CambioOficina" access="public">
    	<cfargument name="Oficodigo"   	type="string"  required="yes" 	hint="Codigo de la Oficina">
        <cfargument name="Odescripcion" type="string"  required="no" 	hint="Descripción de la Oficina" default="#Arguments.Oficodigo#">
        <cfargument name="Ecodigo" 	  	type="numeric" required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   	type="string"  required="no" 	hint="Nombre del DataSource">
        <cfargument name="Ocodigo"   	type="string"  required="yes" 	hint="Codigo de la Oficina">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
		<cfquery datasource="#Arguments.conexion#">     
        	UPDATE Oficinas SET 
           		Oficodigo       = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#Arguments.Oficodigo#">,
           		Odescripcion    = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  value="#Arguments.Odescripcion#">
     		WHERE Ecodigo         = #Arguments.Ecodigo#
      		AND Ocodigo         = <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Ocodigo#"> 
     	</cfquery>
    </cffunction> 
<!---Eliminar Oficina--->
    <cffunction name="BajaOficina" access="public" >
    	<cfargument name="Ocodigo"   	type="string"  required="yes" 	hint="Codigo de la Oficina">
        <cfargument name="Ecodigo" 	  	type="numeric" required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   	type="string"  required="no" 	hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
  			<cfquery datasource="#Arguments.conexion#">     
            	DELETE FROM Oficinas
    		 	WHERE Ecodigo         = #Arguments.Ecodigo#
       			AND Ocodigo         = <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Ocodigo#"> 
       		</cfquery>
    </cffunction>         
</cfcomponent>