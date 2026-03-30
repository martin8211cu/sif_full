<cfcomponent>
	<cffunction name="AltaModulosCuentaE" access="public" returntype="string" hint="Agregar un nuevo modulo a la cuenta Empresarial">
		<cfargument name="CEcodigo" type="numeric" required="yes">
        <cfargument name="SScodigo" type="string" required="yes">
        <cfargument name="SMcodigo" type="string" required="yes">
        <cfargument name="Conexion" type="string" required="no" default="asp">
        
        
        <cfinvoke component="Modulo" method="validaModulosCuenta" returnvariable="noExiste">
        	<cfinvokeargument name="CEcodigo" value="#Arguments.CEcodigo#">
            <cfinvokeargument name="SScodigo" value="#Arguments.SScodigo#">
            <cfinvokeargument name="SMcodigo" value="#Arguments.SMcodigo#">
            <cfinvokeargument name="Conexion" value="#Arguments.Conexion#">
        </cfinvoke>
        
       <cfif #noExiste#>
            <cfquery name="rs" datasource="#Arguments.Conexion#">
                insert INTO ModulosCuentaE(CEcodigo,SScodigo,SMcodigo)
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SScodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SMcodigo#">
                )
            </cfquery>
       </cfif>
	</cffunction>
    
    <cffunction name="BajaModulosCuentaE" access="public" returntype="string" hint="Elimina un Modulo a la cuenta Empresarial">
		<cfargument name="CEcodigo" type="numeric" required="yes">
        <cfargument name="SScodigo" type="string" required="yes">
        <cfargument name="SMcodigo" type="string" required="yes">
        <cfargument name="Conexion" type="string" required="no" default="asp">
        
		 <cfquery name="rs" datasource="#Arguments.Conexion#">
			delete from ModulosCuentaE
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SScodigo#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SMcodigo#">
		</cfquery>
	</cffunction>
    
    <cffunction name="validaModulosCuenta" access="public" returntype="boolean" hint="Valida si existe ya registrada la opcion">
   		<cfargument name="CEcodigo" type="numeric" 	required="yes">
        <cfargument name="SScodigo" type="string" 	required="yes">
        <cfargument name="SMcodigo" type="string"	required="yes">
        <cfargument name="Conexion" type="string" required="no" default="asp">
        
        <cfquery name="rsModulo" datasource="#Arguments.Conexion#">
        	select count(1) as siExiste
            from ModulosCuentaE
            where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SScodigo#">
			  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SMcodigo#"> 
        </cfquery>
        
        <cfreturn rsModulo.siExiste EQ 0>	  
    
	</cffunction>  

    <cffunction name="ValidarModulos" access="public" returntype="boolean" hint="verifica si existen los modulos parael usuario">
        <cfargument name="Usucodigo"    type="numeric"  required="yes">
        <cfargument name="Ecodigo"      type="numeric"  required="yes">
        <cfargument name="SScodigo"     type="string"   required="yes">
        <cfargument name="SMcodigo"     type="string"   required="yes">
        <cfargument name="Conexion"     type="string"   required="no" default="asp">
        <cfquery name="rsModulos" datasource="#Arguments.Conexion#">
            select 
                (
                    select count(1)
                    from UsuarioProceso
                    where Usucodigo = #Arguments.Usucodigo#
                          and Ecodigo   =  #Arguments.Ecodigo#
                          and SScodigo  = '#Arguments.SScodigo#'
                          and SMcodigo  = '#Arguments.SMcodigo#'
                )
                + 
                (
                    select count(1)
                    from UsuarioRol a
                    	inner join SRoles b
                        	on a.SRcodigo=b.SRcodigo
                            and a.SScodigo=b.SScodigo
                        inner join SProcesosRol c
                        	on c.SScodigo=b.SScodigo
                            and c.SRcodigo=b.SRcodigo
                    where Usucodigo = #Arguments.Usucodigo#
                          and a.Ecodigo   =  #Arguments.Ecodigo#
                          and c.SScodigo  = '#Arguments.SScodigo#'
                          and c.SMcodigo  = '#Arguments.SMcodigo#'
                ) as siExiste      
            from dual
        </cfquery>
        <cfreturn rsModulos.siExiste gt 0>   
    </cffunction>

</cfcomponent>