<cfcomponent>
	<cffunction name="GetPuesto" access="public" returntype="query">
    	<cfargument name="Ecodigo" 	  type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   type="string"  required="no" hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfquery name="rsPuesto" datasource="#Arguments.conexion#">
         	select Ecodigo, RHPcodigo,RHPdescpuesto,RHOcodigo,RHPEid
            	from RHPuestos
            where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">
            Order by RHPdescpuesto
         </cfquery>
		<cfreturn rsPuesto>
	</cffunction>
<!---==========================================================================================--->
    <cffunction name="AltaPuesto" access="public" returntype="string">
    	<cfargument name="RHPcodigo"   	 type="string"   required="yes" hint="Codigo del Puesto">
        <cfargument name="RHPdescpuesto" type="string"   required="no" 	hint="Descripción del Puesto" default="#Arguments.RHPcodigo#">
        <cfargument name="Ecodigo" 	  	 type="numeric"  required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   	 type="string"   required="no" 	hint="Nombre del DataSource">
        <cfargument name="BMusuario"   	 type="numeric"  required="no" 	hint="Usuario del Portal">
        <cfargument name="RHOcodigo"   	 type="string"   required="no" 	hint="Codigo de la ocupacion" default="-1">
        <cfargument name="RHPEid"   	 type="numeric"  required="no" 	hint="Codigo del puesto externo" default="-1">

		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.BMusuario') and isdefined('session.Usucodigo')>
        	<cfset Arguments.BMusuario = session.Usucodigo>
        </cfif>
        <cfquery name="AltaPuestos" datasource="#Arguments.conexion#">
        	insert into RHPuestos (Ecodigo, RHPcodigo,RHPdescpuesto,BMusuario,RHOcodigo,RHPEid,BMfecha)
            values
            (
            	<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">,
            	<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#TRIM(Arguments.RHPcodigo)#">,                
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#TRIM(Arguments.RHPdescpuesto)#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.BMUsuario#">,
               	<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#TRIM(Arguments.RHOcodigo)#" voidnull null="#Arguments.RHOcodigo EQ -1#">,
               	<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#TRIM(Arguments.RHPEid)#"  voidnull null="#Arguments.RHPEid EQ -1#">,
                <cf_dbfunction name="now">
            )
			</cfquery>
		<cfreturn Arguments.RHPcodigo>
    </cffunction>
<!---==========================================================================================--->
    <cffunction name="CambioPuesto" access="public" returntype="string">
    	<cfargument name="RHPcodigo"   	 type="string"   required="yes" hint="Codigo del Puesto">
        <cfargument name="RHPdescpuesto" type="string"   required="yes"	hint="Descripción del Puesto" default="#Arguments.RHPcodigo#">
        <cfargument name="Ecodigo" 	  	 type="numeric"  required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   	 type="string"   required="no" 	hint="Nombre del DataSource">
        <cfargument name="BMusuario"   	 type="numeric"  required="no" 	hint="Usuario del Portal">
        <cfargument name="RHOcodigo"   	 type="string"   required="no" 	hint="Codigo de la ocupacion" default="">
        <cfargument name="RHPEid"   	 type="numeric"  required="no" 	hint="Codigo del puesto externo">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.BMusuario') and isdefined('session.Usucodigo')>
        	<cfset Arguments.BMusuario = session.Usucodigo>
        </cfif>
            <cfquery name="CambioPuesto" datasource="#Arguments.conexion#">
            	update RHPuestos
              	set RHPdescpuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHPdescpuesto#">
                <cfif isdefined ("Arguments.RHOcodigo")>
                	, RHOcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#TRIM(Arguments.RHOcodigo)#">
                </cfif>
                <cfif isdefined ("Arguments.RHPEid")>
                	, RHPEid 	  = <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#TRIM(Arguments.RHPEid)#">
                </cfif>
                Where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHPcodigo#">
            </cfquery>
		<cfreturn Arguments.RHPcodigo>
<!---==========================================================================================--->
    </cffunction>
        <cffunction name="BajaPuesto" access="public" returntype="string">
    	<cfargument name="RHPcodigo"   	 type="string"   required="yes" hint="Codigo del Puesto">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
            <cfquery name="BajaPuesto" datasource="#Arguments.conexion#">
            	delete from RHPuestos
                Where RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.RHPcodigo#">
            </cfquery>
    </cffunction>   
</cfcomponent>