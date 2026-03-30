
<cfcomponent>
	<cffunction name="AltaUsuarioCuentaE" access="public" returntype="numeric" hint="Agregar un nuevo Usuario a la cuenta Empresa">
		<cfargument name="CEcodigo" 		type="numeric" 	required="yes">
        <cfargument name="datos_personales" type="numeric" 	required="no">
        <cfargument name="LOCIdioma" 		type="string"	required="yes">
        <cfargument name="expira" 			type="any"		required="no" default="#createDate(6100,01,01)#">
        <cfargument name="user" 			type="string"	required="yes">
        <cfargument name="enviar_password" 	type="boolean"	required="no" default="true">
        <cfargument name="Conexion" 		type="string"	required="no" default="asp">
        <cfargument name="TransaccionAtiva" type="boolean"  required="no" default="false" >
        
        
        <cfinvoke component="asp.Componentes.Usuarios" method="ValidarUsuario" returnvariable="LVarUsucodigo">
        	<cfinvokeargument name="CEcodigo" value="#Arguments.CEcodigo#">
            <cfinvokeargument name="Usulogin" value="#Arguments.user#">
            <cfinvokeargument name="Conexion" value="#Arguments.Conexion#">
        </cfinvoke>
        <cfif #LVarUsucodigo# EQ 0>
            <cf_direccion action="readform" name="data2" Conexion="#Arguments.Conexion#">
            <cf_direccion action="insert" name="data2" data="#data2#" Conexion="#Arguments.Conexion#">
    
    
            <!--- Inserta el usuario, le asocia la direccion y los datos personales --->
            <cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
    
            <cfset usuario = sec.crearUsuario(Arguments.CEcodigo, data2.id_direccion, Arguments.datos_personales, Arguments.LOCIdioma, 
                Arguments.expira, Arguments.user, Arguments.enviar_password, Arguments.Conexion,  Arguments.TransaccionAtiva)>
            
    <!---        <cfset usuario = sec.crearUsuario(Session.Progreso.CEcodigo, data2.id_direccion, data1.datos_personales, form.LOCIdioma, expira, user, enviar_password)>
    --->		<cfif isdefined("Form.rdGen") and Form.rdGen EQ "2">
                <cfset sec.renombrarUsuario(usuario, user, form.password)>
                <!--- Esto se tiene que dejar, ya que si el dueño de pso sabe el password de fulanito es un problema de seguridad, este update hace que apenas se firme el usuario
                    le pida cambio de contraseña
                 --->
                <cfquery datasource="asp">
                    update UsuarioPassword
                       set PasswordSet = <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(1999,01,01)#">
                     where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario#">
                </cfquery>
            <cfelseif isdefined("Form.rdGen") and Form.rdGen EQ "3">
                <cfset sec.renombrarUsuario(usuario, user, "")>
                <cfset sec.generarPassword( usuario, true)>
            </cfif>
           
            <cfreturn usuario>
        
        <cfelse>
        	<cfreturn LVarUsucodigo>
        </cfif>
	</cffunction>
    
    
    <cffunction name="ValidarUsuario" access="public" returntype="numeric" hint="Verifica si existe el Usuario a la cuenta Empresa">
		<cfargument name="CEcodigo"  type="numeric" 	required="yes">
        <cfargument name="Usulogin"	 type="string"	 	required="yes">
        <cfargument name="Conexion"	 type="string"	 	required="no" default="asp">
        
        
        <cfquery name="rsUsucodigo" datasource="#Arguments.Conexion#">
        	select Usucodigo
                from Usuario
                where CEcodigo = #Arguments.CEcodigo#
                and Usulogin =  '#Arguments.Usulogin#'
        </cfquery>
        <cfif isdefined('rsUsucodigo') and rsUsucodigo.RecordCount GT 0>
        	<cfreturn  rsUsucodigo.Usucodigo >
        <cfelse>
        	<cfreturn  0>
        </cfif>
    </cffunction>
</cfcomponent>







