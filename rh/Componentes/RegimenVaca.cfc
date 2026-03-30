<cfcomponent>
<!---Obtener Regimen--->
	<cffunction name="GetRegimen" access="public" returntype="query">
    	<cfargument name="Ecodigo" 	  type="numeric" required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   type="string"  required="no" 	hint="Nombre del DataSource">
        <cfargument name="FiltroExtra" type="string" default="" 	required="no" 	hint="Variable de paso">
        
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
         <cfquery name="rsRegimen" datasource="#Arguments.conexion#">
         	select RVid,RVcodigo,Descripcion,ts_rversion
            	from RegimenVacaciones
            where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"><cfoutput>#FiltroExtra#</cfoutput> 
         </cfquery>
		<cfreturn rsRegimen>
	</cffunction>
<!---Obtener el Detalle de Regimen--->
  	<cffunction name="GetDRegimen" access="public" returntype="query">
    	<cfargument name="Ecodigo" 	  type="numeric" required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   type="string"  required="no" 	hint="Nombre del DataSource">
        <cfargument name="FiltroExtra" type="string" required="yes" hint="Variable de paso">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
            <cfquery name="rsDregimen" datasource="#Arguments.conexion#">     
                SELECT DRVlinea,
                       RVid,
                       DRVcant,
                       DRVdias,
                       Usucodigo,
                       Ulocalizacion,
                       DRcantcomp,
                       DRVdiasgratifica,
                       DRVdiasprima
                  FROM DRegimenVacaciones
                 WHERE <cfoutput>#FiltroExtra#</cfoutput> 
             </cfquery>
		<cfreturn rsDregimen>
	</cffunction>

<!---Insertar un nuevo Regimen---->
	<cffunction name="AltaRegimen" access="public" returntype="numeric">
    	<cfargument name="Ecodigo" 	  		type="numeric" 	required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   		type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="Usucodigo"  		type="numeric" 	required="no" hint="Codigo de la Empresa">
		<cfargument name="Ulocalizacion"   	type="string" 	required="no" hint="Nombre del DataSource">
        <cfargument name="RVcodigo" 		type="string" 	required="yes" hint="Codigo de la Empresa">
		<cfargument name="Descripcion"   	type="string"  	required="yes" hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ulocalizacion') and isdefined('session.Ulocalizacion')>
        	<cfset Arguments.Ulocalizacion = session.Ulocalizacion>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
              <cfquery name="rsInsert" datasource="#Arguments.conexion#">     
              		INSERT INTO RegimenVacaciones (
                           Ecodigo,
                           RVcodigo,
                           Descripcion,
                           RVfecha,
                           Usucodigo,
                           Ulocalizacion,
                           BMUsucodigo
                    )
                    VALUES(
                           #Arguments.Ecodigo#,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#Arguments.RVcodigo#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#Arguments.Descripcion#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Usucodigo#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#Arguments.Ulocalizacion#">,
                           #Arguments.Usucodigo#
                    )     <cf_dbidentity1 name="rsInsert" datasource="#Arguments.conexion#"> 
            </cfquery> <cf_dbidentity2 name="rsInsert" datasource="#Arguments.conexion#" returnvariable="LvarRVid">
		<cfreturn rsInsert.IDENTITY>
	</cffunction>
<!---Actualizar Regimen---->
	<cffunction name="CambioRegimen" access="public" >
    	<cfargument name="Ecodigo" 	  		type="numeric" 	required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   		type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="Usucodigo"  		type="numeric" 	required="no" hint="Codigo de la Empresa">
		<cfargument name="Ulocalizacion"   	type="string" 	required="no" hint="Nombre del DataSource">
        <cfargument name="RVid" 			type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="RVcodigo" 		type="string" 	required="yes" hint="Codigo de la Empresa">
		<cfargument name="Descripcion"   	type="string"  	required="yes" hint="Nombre del DataSource">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ulocalizacion') and isdefined('session.Ulocalizacion')>
        	<cfset Arguments.Ulocalizacion = session.Ulocalizacion>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfquery datasource="#session.dsn#" name="rsUpdate">     
        	UPDATE RegimenVacaciones
               SET Ecodigo       = #Arguments.Ecodigo#,
                   RVcodigo      = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#Arguments.RVcodigo#">,
                   Descripcion   = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#Arguments.Descripcion#">,
                   RVfecha       = <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
                   Usucodigo     = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Usucodigo#">,
                   Ulocalizacion = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#Arguments.Ulocalizacion#">,
                   BMUsucodigo   = #Arguments.Usucodigo#
             WHERE RVid          = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.RVid#"> 
        </cfquery>
	</cffunction>
<!---Insertar un nuevo Detalle de Regimen---->
	<cffunction name="AltaDRegimen" access="public" returntype="query">
    	<cfargument name="Ecodigo" 	  		type="numeric" 	required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   		type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="Usucodigo"  		type="numeric" 	required="no" hint="Codigo de la Empresa">
		<cfargument name="Ulocalizacion"    type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="RVcodigo" 		type="string" 	required="yes" hint="Codigo de la Empresa">
		<cfargument name="Descripcion"   	type="string"  	required="yes" hint="Nombre del DataSource">
        <cfargument name="DRVcant"  		type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="DRVdias"  		type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="DRVdiasgratifica"	type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="DRVdiasprima"  	type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="RVid" 			type="string" 	required="yes" hint="Codigo de la Empresa">
       	<cfargument name="DRcantcomp"  		type="string" default="0"	required="no">
        <cfargument name="DRVdiasenf"  		type="string" default="0" 	required="no">
        <cfargument name="DRVdiasvericomp"  type="string" default="0" 	required="no">
        <cfargument name="DRVdiasadic" 		type="string" default="0" 	required="no" >
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ulocalizacion') and isdefined('session.Ulocalizacion')>
        	<cfset Arguments.Ulocalizacion = session.Ulocalizacion>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
            <cfquery name="rsInsert" datasource="#Arguments.conexion#">     
                    INSERT INTO DRegimenVacaciones (
                           RVid,
                           DRVcant,
                           DRVdias,
                           Usucodigo,
                           Ulocalizacion,
                           DRcantcomp,
                           DRVdiasenf,
                           DRVdiasadic,
                           DRVdiasvericomp,
                           DRVdiasgratifica,
                           DRVdiasprima,
                           BMUsucodigo
                    )
                    VALUES(
                           <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" value="#Arguments.RVid#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_float"   value="#Arguments.DRVcant#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_float"   value="#Arguments.DRVdias#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_integer" value="#Arguments.DRcantcomp#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_float"   value="#Arguments.DRVdiasenf#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_float"   value="#Arguments.DRVdiasadic#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_float"   value="#Arguments.DRVdiasvericomp#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_float"	  value="#Arguments.DRVdiasgratifica#">,
                           <cf_jdbcQuery_param cfsqltype="cf_sql_float"   value="#Arguments.DRVdiasprima#">,
                           #Arguments.Usucodigo#
                    )     <cf_dbidentity1 name="rsInsert" datasource="#Arguments.conexion#">
            </cfquery> 
    	<cf_dbidentity2 name="rsInsert" datasource="#Arguments.conexion#" returnvariable="LvarIdentity">
		<cfreturn rsInsert>
	</cffunction>
<!---Eliminar un Regimen de Vacaciones--->   
	<cffunction name="BajaRegimen" access="public">
    	<cfargument name="Ecodigo" 	  	type="numeric" 	required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   	type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="RVid" 		type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="DRVlinea" 	type="string" 	required="yes" hint="Codigo de la Empresa">
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
       <!--- <cfinvoke component="RegimenVaca" method="BajaDRegimen">
        	<cfinvokeargument name="DRVlinea" 	value="#Arguments.DRVlinea#">
        </cfinvoke>--->
       <cfquery datasource="#Arguments.conexion#">     
           DELETE FROM RegimenVacaciones
     		WHERE RVid          = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.RVid#"> 
       </cfquery>
	</cffunction>  
<!---Eliminar un Detalle Regimen de Vacaciones--->    
	<cffunction name="BajaDRegimen" access="public">
    	<cfargument name="Ecodigo" 	  	type="numeric" 	required="no" 	hint="Codigo de la Empresa">
		<cfargument name="conexion"   	type="string"  	required="no" 	hint="Nombre del DataSource">
        <cfargument name="DRVlinea" 	type="string" 	required="yes" 	hint="Codigo de la Empresa">
        
		<cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfquery datasource="#Arguments.conexion#">     
            DELETE FROM DRegimenVacaciones
            WHERE DRVlinea         = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.DRVlinea#"> 
        </cfquery>
	</cffunction> 

<!---Actualizar un Detalle Regimen de Vacaciones--->    
	<cffunction name="CambioDRegimen" access="public">
    	<cfargument name="Ecodigo" 	  		type="numeric" 	required="no" hint="Codigo de la Empresa">
		<cfargument name="conexion"   		type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="Usucodigo"  		type="numeric" 	required="no" hint="Codigo de la Empresa">
		<cfargument name="Ulocalizacion"    type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="RVcodigo" 		type="string" 	required="yes" hint="Codigo de la Empresa">
		<cfargument name="Descripcion"   	type="string"  	required="yes" hint="Nombre del DataSource">
        <cfargument name="DRVcant"  		type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="DRVdias"  		type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="DRVdiasgratifica" type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="DRVdiasprima"  	type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="RVid" 			type="string" 	required="yes" hint="Codigo de la Empresa">
        <cfargument name="DRVlinea" 		type="string" 	required="yes" hint="Codigo de la Empresa">        
       	<cfargument name="DRcantcomp"  		type="string" default="0"	required="no" hint="Codigo de la Empresa">
        <cfargument name="DRVdiasenf"  		type="string" default="0" 	required="no" hint="Codigo de la Empresa">
        <cfargument name="DRVdiasvericomp"  type="string" default="0" 	required="no" hint="Codigo de la Empresa">
        <cfargument name="DRVdiasadic" type="string" default="0" 	required="no" hint="Codigo de la Empresa">
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ulocalizacion') and isdefined('session.Ulocalizacion')>
        	<cfset Arguments.Ulocalizacion = session.Ulocalizacion>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfquery datasource="#Arguments.conexion#">     
       		UPDATE DRegimenVacaciones
       		SET RVid             = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.RVid#">,
                   DRVcant          = <cf_jdbcQuery_param cfsqltype="cf_sql_float"             	value="#Arguments.DRVcant#">,
                   DRVdias          = <cf_jdbcQuery_param cfsqltype="cf_sql_float"             	value="#Arguments.DRVdias#">,
                   Usucodigo        = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#Arguments.Usucodigo#">,
                   Ulocalizacion    = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   	value="#Arguments.Ulocalizacion#">,
                   DRcantcomp       = <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           	value="#Arguments.DRcantcomp#">,
                   DRVdiasenf       = <cf_jdbcQuery_param cfsqltype="cf_sql_float"             	value="#Arguments.DRVdiasenf#">,
                   DRVdiasadic     = <cf_jdbcQuery_param cfsqltype="cf_sql_float"             	value="#Arguments.DRVdiasadic#">,
                   DRVdiasvericomp  = <cf_jdbcQuery_param cfsqltype="cf_sql_float"             	value="#Arguments.DRVdiasvericomp#">,
                   DRVdiasgratifica = <cf_jdbcQuery_param cfsqltype="cf_sql_float"             	value="#Arguments.DRVdiasgratifica#">,
                   DRVdiasprima     = <cf_jdbcQuery_param cfsqltype="cf_sql_float"             	value="#Arguments.DRVdiasprima#">,
                   BMUsucodigo      = #Arguments.Usucodigo#
           WHERE DRVlinea         = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.DRVlinea#"> 
     	</cfquery>
	</cffunction>   
</cfcomponent>