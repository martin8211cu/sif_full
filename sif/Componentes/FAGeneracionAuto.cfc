<cfcomponent hint="Componente para el manejo de Generación Automatica de Facturación">
	<!---►►Funcion para Obtener los tipos de generacion de Facturación◄◄--->
	<cffunction name="GetGFATipos" access="public" returntype="query" hint="Funcion para Obtener los tipos de generacion de Facturación">
    	<cfargument name="Conexion" type="string"  required="no" hint="Nommbre del DataSource">
        <cfargument name="Ecodigo" 	type="numeric" required="no" hint="Codigo Interno de la empresa">
        
        <cfif NOT ISDEFINED('Arguments.Conexion') and ISDEFINED('Session.DSN')>
			<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo') and ISDEFINED('Session.Ecodigo')>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        <cfquery name="rsSQL" datasource="#Arguments.Conexion#">     
            SELECT GFAid,
                   Ecodigo,
                   GFACodigo,
                   GFADescripcion,
                   GFAMetodo,
                   GFAPeriodicidad,
                   GFAPorcentaje,
                   fechaalta,
                   BMUsucodigo,
                   ts_rversion
          FROM GFATipos
          WHERE Ecodigo = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Ecodigo#"> 
          <cfif isdefined('Arguments.GFAid')>
           and GFAid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.GFAid#"> 
          </cfif>
       	</cfquery>
		
        <cfreturn rsSQL>
    </cffunction>
	<!---►►Funcion para crear un nuevo tipo de generacion de Facturación◄◄--->
	<cffunction name="ALTAGFATipos" access="public" hint="Funcion para crear un nuevo tipo de generacion de Facturación" returntype="numeric">
    	<cfargument name="Conexion" 		type="string"  	required="no"  hint="Nommbre del DataSource">
        <cfargument name="GFACodigo" 		type="string" 	required="yes" hint="Codigo">
        <cfargument name="GFADescripcion" 	type="string"  	required="yes" hint="Descripción">
        <cfargument name="GFAMetodo" 		type="numeric" 	required="yes" hint="Metodo">
        <cfargument name="GFAPeriodicidad" 	type="numeric" 	required="yes" hint="periodicidad">
        <cfargument name="GFAPorcentaje" 	type="numeric" 	required="yes" hint="Porcentaje">
        <cfargument name="Ecodigo" 			type="numeric"  required="no"  hint="Empresa">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no"  hint="Usuario">   
        <cfargument name="BMfechaalta" 		type="date"  	required="no"  hint="Fecha del Registro">
        
        <cfif NOT ISDEFINED('Arguments.Conexion') and ISDEFINED('Session.DSN')>
			<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        
        <cfif NOT ISDEFINED('Arguments.Ecodigo') and ISDEFINED('Session.Ecodigo')>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>

        <cfif NOT ISDEFINED('Arguments.BMfechaalta')>
			<cfset Arguments.BMfechaalta = NOW()>
        </cfif>

        <cfif NOT ISDEFINED('Arguments.BMUsucodigo') and ISDEFINED('Session.Usucodigo')>
			<cfset Arguments.BMUsucodigo = Session.Usucodigo>
        </cfif>
        
        <cfquery name="rsInsert" datasource="#Arguments.Conexion#">     
        	INSERT INTO GFATipos (
               Ecodigo,
               GFACodigo,
               GFADescripcion,
               GFAMetodo,
               GFAPeriodicidad,
               GFAPorcentaje,
               fechaalta,
               BMUsucodigo
    		)VALUES(
           <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" 			value="#Arguments.Ecodigo#">,
           <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#Arguments.GFACodigo#">,
           <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  value="#Arguments.GFADescripcion#">,
           <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.GFAMetodo#">,
           <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.GFAPeriodicidad#">,
           <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.GFAPorcentaje#">,           
           <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Arguments.BMfechaalta#">,
           <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" 			value="#Arguments.BMUsucodigo#">
    		)     
            <cf_dbidentity1 name="rsInsert" datasource="#Arguments.Conexion#"> 
          </cfquery> 
          	<cf_dbidentity2 name="rsInsert" datasource="#Arguments.Conexion#" returnvariable="LvarIdentity">
            
		<cfreturn LvarIdentity>
    </cffunction>
    <!---►►Funcion para Modificar nueva Cuenta de Salarios por Pagar◄◄--->
    <cffunction name="CAMBIOGFATipos" access="public" hint="Funcion para Modificar nueva Cuenta de Salarios por Pagar" returntype="numeric">
		<cfargument name="Conexion" 		type="string"  	required="no"  hint="Nommbre del DataSource">
        <cfargument name="GFAid" 			type="numeric" 	required="yes" hint="id">
        <cfargument name="GFACodigo" 		type="string" 	required="yes" hint="Codigo">
        <cfargument name="GFADescripcion" 	type="string"  	required="yes" hint="Descripción">
        <cfargument name="GFAMetodo" 		type="numeric" 	required="yes" hint="Metodo">
        <cfargument name="GFAPeriodicidad" 	type="numeric" 	required="yes" hint="periodicidad">
        <cfargument name="GFAPorcentaje" 	type="numeric" 	required="no"  hint="Porcentaje" default="0">
        <cfargument name="Ecodigo" 			type="numeric"  required="no"  hint="Empresa">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no"  hint="Usuario">        
        <cfargument name="BMfechaalta" 		type="date"  	required="no"  hint="Fecha del Registro">               
        
        <cfif NOT ISDEFINED('Arguments.Conexion') and ISDEFINED('Session.DSN')>
			<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        
        <cfif NOT ISDEFINED('Arguments.Ecodigo') and ISDEFINED('Session.Ecodigo')>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>
        
		<cfif NOT ISDEFINED('Arguments.BMfechaalta')>
			<cfset Arguments.BMfechaalta = NOW()>
        </cfif>
        
        <cfif NOT ISDEFINED('Arguments.BMUsucodigo') and ISDEFINED('Session.Usucodigo')>
			<cfset Arguments.BMUsucodigo = Session.Usucodigo>
        </cfif>        
        
        <cfquery datasource="#Arguments.Conexion#">     
        UPDATE GFATipos
           SET Ecodigo         = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Ecodigo#">,
               GFACodigo       = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="10"  value="#Arguments.GFACodigo#">,
               GFADescripcion  = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  value="#Arguments.GFADescripcion#">,
               GFAMetodo       = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.GFAMetodo#">,
               GFAPeriodicidad = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.GFAPeriodicidad#">,
               GFAPorcentaje   = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.GFAPorcentaje#">,
               fechaalta       = <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Arguments.BMfechaalta#">,
               BMUsucodigo     = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.BMUsucodigo#">
         WHERE GFAid           = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.GFAid#"> 
        </cfquery>		
       <cfreturn Arguments.GFAid>
    </cffunction>
    <!---►►Funcion para Eliminar una nueva Cuenta de Salarios por Pagar◄◄--->
    <cffunction name="BAJAGFATipos" access="public" hint="Funcion para Eliminar una nueva Cuenta de Salarios por Pagar">
		<cfargument name="Conexion" 	type="string"  	required="no"  hint="Nommbre del DataSource">
        <cfargument name="GFAid" 		type="numeric" 	required="yes" hint="Id de la cuenta de Salario por Pagar">
        
        <cfif NOT ISDEFINED('Arguments.Conexion') and ISDEFINED('Session.DSN')>
			<cfset Arguments.Conexion = Session.DSN>
        </cfif>
        
        <cfquery datasource="#Arguments.Conexion#">     
        	DELETE FROM GFATipos
     		WHERE GFAid = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.GFAid#"> 
        </cfquery>
    </cffunction>
</cfcomponent>