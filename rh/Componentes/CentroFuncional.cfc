<cfcomponent>
	<!---- Obtener Centros Funcionales ---->
	<cffunction name="GetCentroFuncional" access="public" returntype="query">
    	<cfargument name="Ocodigo" 	  type="any"     required="no" hint="Codigo de la Oficina">
    	<cfargument name="Dcodigo" 	  type="numeric" required="no" hint="Codigo del Departamento">
        <cfargument name="Ecodigo" 	  type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   type="string"  required="no" hint="Nombre del DataSource">
        <cfargument name="CFid"  	  type="numeric" required="no" hint="Id Centro Funcional">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfquery name="rsCentroFuncional" datasource="#Arguments.conexion#">
         	select CFid,CFcodigo,CFdescripcion,CFidresp,Ocodigo,Dcodigo
            	from CFuncional
                where Ecodigo = #Arguments.Ecodigo#
     	<cfif isdefined('Arguments.CFid')>
            	and CFid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.CFid#">
            </cfif>
            order by upper(CFdescripcion)
         </cfquery>
		<cfreturn rsCentroFuncional>
	</cffunction>
<!---- Csonsultar si ya existe CFcodigo---->
	<cffunction name="existeCFcodigo" access="public" returntype="query">
        <cfargument name="Ecodigo" 	type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion" type="string"  required="no" hint="Nombre del DataSource">
        <cfargument name="CFcodigo"	type="string" required="yes" hint="Codigo del Centro Funcional">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfquery name="rsCentroFuncional" datasource="#Arguments.conexion#">
         	select CFid,CFcodigo,CFdescripcion,CFidresp,Ocodigo,Dcodigo
            	from CFuncional
                where Ecodigo = #Arguments.Ecodigo#
     		<cfif isdefined('Arguments.CFcodigo')>
            	and CFcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.CFcodigo#">
            </cfif>
         </cfquery>
		<cfreturn rsCentroFuncional>
	</cffunction>
 <!---- Consultar si un Padre tiene un hijos ---->
	<cffunction name="GetCentroFuncionalP" access="public" returntype="query">
        <cfargument name="Ecodigo" 	  type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   type="string"  required="no" hint="Nombre del DataSource">
        <cfargument name="CFid"  	  type="numeric" required="yes" hint="Id Centro Funcional">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfquery name="rsCentroFuncional" datasource="#Arguments.conexion#">
         	select CFid,CFcodigo,CFdescripcion,CFidresp,Ocodigo,Dcodigo
            	from CFuncional
                where Ecodigo = #Arguments.Ecodigo#
     	<cfif isdefined('Arguments.CFid')>
            	and CFidresp = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.CFid#">
            </cfif>
            order by upper(CFdescripcion)
         </cfquery>
		<cfreturn rsCentroFuncional>
	</cffunction>
   <!---- Busca hijos de padres Centros Funcionales ----> 
    <cffunction name="Busca_hijos" access="public" returntype="query">
    	<cfargument name="Ocodigo" 	  type="any"     required="no" hint="Codigo de la Oficina">
    	<cfargument name="Dcodigo" 	  type="numeric" required="no" hint="Codigo del Departamento">
        <cfargument name="Ecodigo" 	  type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   type="string"  required="no" hint="Nombre del DataSource">
        <cfargument name="CFid"  	  type="numeric" required="no" hint="Id Centro Funcional">
        <cfargument name="valor"  	  type="numeric" required="no" hint="Id Centro Funcional"> 
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfquery name="rsCentroFuncional" datasource="#Arguments.conexion#">
         	select CFid,CFcodigo,CFdescripcion,CFidresp,Ocodigo,Dcodigo
            	from CFuncional
         		where   CFidresp  =  <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.valor#">
         </cfquery>
		<cfreturn rsCentroFuncional>
	</cffunction>
  <!---- RAIZ Centros Funcionales ---->
    <cffunction name="GetCentroFuncionalRaiz" access="public" returntype="query">
        <cfargument name="Ecodigo" 	  type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   type="string"  required="no" hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfquery name="rsCentroFuncional" datasource="#Arguments.conexion#">
         	select * from CFuncional where Ecodigo = #Arguments.Ecodigo# and CFidresp is null
         </cfquery>
		<cfreturn rsCentroFuncional>
	</cffunction>
  <!---- ALTA Centros Funcionales ---->
    <cffunction name="AltaCentroFuncional" access="public" >
    	<cfargument name="CFcodigo"   		type="string" required="no"  hint="Codigo de la Empresa">
        <cfargument name="Dcodigo" 	  		type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="Ocodigo" 	  		type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="CFidresp"			type="numeric" required="no"  hint="Codigo de la Empresa">
        <cfargument name="CFdescripcion" 	type="string" required="no"  hint="Codigo de la Empresa" default="#Arguments.CFcodigo#">
        <cfargument name="CFpath" 	  		type="string" required="no"  hint="Codigo de la Empresa" default="#Arguments.CFcodigo#">
        <cfargument name="CFnivel" 	  		type="numeric" required="no" hint="Codigo de la Empresa" default="0">
        <cfargument name="CFcorporativo" 	type="numeric" required="no" hint="Codigo de la Empresa" default="0">
        <cfargument name="CFestado" 	  	type="numeric" required="no" hint="Codigo de la Empresa" default="1">
        <cfargument name="Ecodigo" 	  		type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   		type="string"  required="no" hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfquery name="AltaCentroFuncional" datasource="#Arguments.conexion#">
        	insert into CFuncional (Ecodigo,CFcodigo,Dcodigo,Ocodigo,CFdescripcion,CFidresp,CFpath,CFnivel,CFcorporativo,CFestado)
            values
            (
            	<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.CFcodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Dcodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ocodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.CFdescripcion#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.CFidresp#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.CFpath#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.CFnivel#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.CFcorporativo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.CFestado#">
            )
       	 		<cf_dbidentity1 datasource="#Arguments.conexion#">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.conexion#" name="AltaCentroFuncional">
    </cffunction>  
  <!---- CAMBIO Centros Funcionales ---->
    <cffunction name="CambioCentroFuncional" access="public" >
    	<cfargument name="CFcodigo"   		type="string" required="no"  hint="Codigo de la Empresa">
        <cfargument name="Dcodigo" 	  		type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="Ocodigo" 	  		type="numeric" required="no" hint="Codigo de la Empresa">
        <cfargument name="CFidresp"			type="numeric" required="no"  hint="Codigo de la Empresa">
        <cfargument name="CFdescripcion" 	type="string" required="no"  hint="Codigo de la Empresa" default="#Arguments.CFcodigo#">
        <cfargument name="CFpath" 	  		type="string" required="no"  hint="Codigo de la Empresa" default="#Arguments.CFcodigo#">
        <cfargument name="CFnivel" 	  		type="numeric" required="no" hint="Codigo de la Empresa" default="0">
        <cfargument name="CFcorporativo" 	type="numeric" required="no" hint="Codigo de la Empresa" default="0">
        <cfargument name="CFestado" 	  	type="numeric" required="no" hint="Codigo de la Empresa" default="1">
        <cfargument name="Ecodigo" 	  		type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   		type="string"  required="no" hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>               
          <cfquery datasource="#Arguments.conexion#">     
             UPDATE CFuncional
               SET Ecodigo              = #Arguments.Ecodigo#,
                   CFcodigo             = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#Arguments.CFcodigo#">,
                   Dcodigo              = <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Dcodigo#">,
                   Ocodigo              = <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Ocodigo#">,
                   CFdescripcion        = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  value="#Arguments.CFdescripcion#">,
                   CFidresp             = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CFidresp#"             voidNull>,
                   CFpath               = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#Arguments.CFpath#">,
                   CFnivel              = <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.CFnivel#">,
                   CFcorporativo        = <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#Arguments.CFcorporativo#">,
                   CFestado             = <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#Arguments.CFestado#">
             WHERE CFid                 = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CFid#">     
         </cfquery>           
    </cffunction>       
  <!---- Eliminar Centros Funcionales ---->
    <cffunction name="BajaCentroFuncional" access="public" >
    	<cfargument name="CFid"   		type="string" required="no"  hint="Codigo de la Empresa">
        <cfargument name="Ecodigo" 	  		type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   		type="string"  required="no" hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfquery datasource="#Arguments.conexion#">     
        		DELETE FROM CFuncional
                WHERE CFid                 = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CFid#"> 
         </cfquery>
    </cffunction>     
</cfcomponent>