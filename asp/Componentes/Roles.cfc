<cfcomponent>
	<cffunction name="AltaRolesUsuarioCE" access="public" returntype="string" hint="Agregar un roles al usuario Administrador cuenta Empresarial">
		<cfargument name="Usucodigo" 	type="numeric" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
        <cfargument name="SScodigo" 	type="string" 	required="yes" default="RH">
        <cfargument name="SRcodigo" 	type="string" 	required="yes" default="CLD_RH_ADM">
        <cfargument name="Conexion" 	type="string" 	required="no" default="asp">
        
        <cfinvoke component="asp.Componentes.Roles" method="ValidarRoles" returnvariable="noExiste">
        	<cfinvokeargument name="Usucodigo" 	value="#Arguments.Usucodigo#" >
            <cfinvokeargument name="Ecodigo" 	value="#Arguments.Ecodigo#" >
            <cfinvokeargument name="SScodigo" 	value="#Arguments.SScodigo#" >
            <cfinvokeargument name="SRcodigo" 	value="#Arguments.SRcodigo#" >
            <cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#" >
        </cfinvoke>
        
        <cfif #noExiste#>
            <cfquery name="rs" datasource="#Arguments.Conexion#">
                insert INTO UsuarioRol( Usucodigo, Ecodigo, SScodigo, SRcodigo )
                    select  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
                            #Arguments.Ecodigo#, SScodigo, SRcodigo
                    from SRoles
                    where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SScodigo#">
                      and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SRcodigo#">
                      and SRinterno = 0
            </cfquery>
       	</cfif>
	</cffunction>
    
    <cffunction name="ValidarRoles" access="public" returntype="boolean" hint="verifica si existen los roles parael usuario">
		<cfargument name="Usucodigo" 	type="numeric" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	required="yes">
        <cfargument name="SScodigo" 	type="string" 	required="yes">
        <cfargument name="SRcodigo" 	type="string" 	required="yes">
        <cfargument name="Conexion" 	type="string" 	required="no" default="asp">
        
        
        <cfquery name="rsRoles" datasource="#Arguments.Conexion#">
        	select count(1) as siExiste
            from UsuarioRol
            where Usucodigo = #Arguments.Usucodigo#
            	  and Ecodigo	=  #Arguments.Ecodigo#
                  and SScodigo	= '#Arguments.SScodigo#'
                  and SRcodigo	= '#Arguments.SRcodigo#'
        </cfquery>
        <cfreturn rsRoles.siExiste EQ 0>	  
    </cffunction>
    <!---===============Carga los Roles del Usuario en session=================--->
    <cffunction name="CargarRolesSession" access="public" hint="Carga los Roles del Usuario en session">
		<cfargument name="Usucodigo" 	type="numeric" 	required="no">
        <cfif isdefined('session.Usucodigo') and Not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
   		<cfquery name="rs" datasource="asp">
			select RTRIM(SRcodigo) SRcodigo
             from UsuarioRol 
            where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
        <cfset session.Roles = ValueList(rs.SRcodigo)>
	</cffunction>
    <!---=============Verifica si un Empleado tienen un Rol====================--->
     <cffunction name="VerificaRol" access="public" returntype="boolean" hint="Verifica si un Empleado tienen un Rol">
		<cfargument name="SRcodigo" 	type="string" 	required="yes">
        <cfargument name="Usucodigo" 	type="numeric" 	required="no">
        <cfif isdefined('session.Usucodigo') and Not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('session.Roles')>
        	<cfset CargarRolesSession()>
        </cfif>
        <cfreturn IIF(LISTFIND(session.roles,Arguments.SRcodigo) GT 0,TRUE,FALSE)>
     </cffunction>

    <!--- Funcion que valida si el rol a asignar sobre un usuario para un sistema de una empresa ya existe --->
    <cffunction name="findRolUsers" access="public" returntype="boolean" hint="Valida si el rol a asignar sobre un usuario ya existe">
        <cfargument name="Usucodigo" type="numeric" required="true"/>
        <cfargument name="Ecodigo"   type="numeric" required="true"/>
        <cfargument name="SScodigo"  type="string"  required="true"/>
        <cfargument name="SRcodigo"  type="string"  required="true"/>
        <cfargument name="Conexion"  type="string"  required="no" default="asp"/>

        <cfquery name="rsFindRolUser" datasource="#Arguments.Conexion#">
            Select count(1) as exist
            from UsuarioRol
            where Usucodigo = #Arguments.Usucodigo# 
            <cfif Arguments.Ecodigo neq -1> 
                and Ecodigo = #Arguments.Ecodigo# 
            </cfif>
            <cfif Arguments.SScodigo neq "" and Arguments.SRcodigo neq "">
                and SScodigo = '#Arguments.SScodigo#'
                and SRcodigo = '#Arguments.SRcodigo#'
            </cfif>  
        </cfquery>

        <cfreturn rsFindRolUser.exist neq 0>
    </cffunction>

    <!--- Funcion que agrega los roles seleccionados a los usuarios escogidos sobre sistemas en las empresas indicadas --->
    <cffunction name="addRolUser" access="public" hint="Asigna roles a usuarios sobre sistemas en las empresas indicadas">
        <cfargument name="Usucodigo" type="numeric" required="true"/>
        <cfargument name="Ecodigo"   type="numeric" required="true"/>
        <cfargument name="SScodigo"  type="string"  required="true"/>
        <cfargument name="SRcodigo"  type="string"  required="true"/>
        <cfargument name="Conexion"  type="string"  required="no" default="asp"/>

        <cftransaction>
            <cfquery name="rsInsertRol" datasource="#Arguments.Conexion#">
                insert into UsuarioRol (Usucodigo,Ecodigo,SScodigo,SRcodigo) values(#Arguments.Usucodigo#,#Arguments.Ecodigo#,'#Arguments.SScodigo#','#Arguments.SRcodigo#')
            </cfquery>
        </cftransaction>
    </cffunction>

    <!--- Funcion que elimina los roles vinculados a los usuarios escogidos de sistemas sobre las empresas relacionadas --->
    <cffunction name="delRolUser" access="public" hint="Elimina roles de usuarios sobre sistemas de las empresas relacionadas">
        <cfargument name="Usucodigo" type="numeric" required="true"/>
        <cfargument name="Ecodigo"   type="numeric" required="true"/>
        <cfargument name="SScodigo"  type="string"  required="true"/>
        <cfargument name="SRcodigo"  type="string"  required="true"/>
        <cfargument name="Conexion"  type="string"  required="no" default="asp"/>

        <cftransaction>
            <cfquery name="rsDelRol" datasource="#Arguments.Conexion#">
                delete from UsuarioRol where Usucodigo = #Arguments.Usucodigo# 
                <cfif Arguments.Ecodigo neq -1>         
                    and Ecodigo = #Arguments.Ecodigo#
                </cfif> 
                <cfif Arguments.SScodigo neq "" and Arguments.SRcodigo neq "">
                    and SScodigo = '#Arguments.SScodigo#' and SRcodigo = '#Arguments.SRcodigo#'
                </cfif>     
            </cfquery>
        </cftransaction>
    </cffunction>

    <!---=============Obtiene los roles para la generación de un nuevo usuario ====================--->
     <cffunction name="getRolesNuevoUsuario" access="public" returntype="array" hint="Obtiene los roles para la generación de un nuevo usuario">
            <cfargument name="rol" type="string" required="false"/>

            <cfset arrayRoles=arrayNew(1)>

            <cfquery name="rsDataNuevoUsuario" datasource="asp">
                select SScodigo,SRcodigo,SRUNtipo
                from SRolesUsuarioNuevo
                where 1=1
                <cfif isDefined("arguments.rol") and trim(ucase(arguments.rol)) eq 'AUTO'>
                    and SRUNtipo = 1
                </cfif>
            </cfquery>

            <cfloop query="rsDataNuevoUsuario">
                <cfset roles=structNew()>
                <cfset roles.SScodigo = rsDataNuevoUsuario.SScodigo>
                <cfset roles.SRcodigo = rsDataNuevoUsuario.SRcodigo>
                <cfset roles.SRUNtipo = rsDataNuevoUsuario.SRUNtipo>
                <cfset arrayAppend(arrayRoles, roles)>
            </cfloop> 

            <!---- valor por defecto para autogestion---->
            <cfif !arrayLen(arrayRoles) and isDefined("arguments.rol") and trim(ucase(arguments.rol)) eq 'AUTO'>
                <cfset roles=structNew()>
                <cfset roles.SScodigo = 'RH'>
                <cfset roles.SRcodigo = 'AUTO'>
                <cfset roles.SRUNtipo = 1>
                <cfset arrayAppend(arrayRoles, roles)>
            </cfif>    

            <cfreturn arrayRoles>
    </cffunction>

</cfcomponent>