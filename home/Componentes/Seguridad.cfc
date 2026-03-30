
<!---
 * Esta interfaz muestra los metodos disponibles para la
 * seguridad del portal.
 *
 * Esta interfaz tendrá una implementación distinta según la
 * capa de seguridad que se utilice (EP / LDAP / NT / etc)


  Metodos:                        Parámetros

  	boolean crearUsuario          ( CEcodigo, id_direccion, datos_personales, idioma, expiracion, Usulogin, notificar_por_email )
		Cualquier usuario lo puede invocar para cambiar su propia contraseña

  	boolean cambiarPassword       ( password_viejo, password_nuevo )
		Cualquier usuario lo puede invocar para cambiar su propia contraseña
		
  	boolean generarPassword       ( Usucodigo )
		Pone una contraseña aleatoria y la envía por correo
		Solamente sys.pso lo puede invocar en una sesión autenticada
	
	boolean renombrarUsuario      ( Usucodigo, nuevo_login, nuevo_password )
		Solamente se puede invocar para un usuario temporal si
		se está autenticado como pso
	
	boolean enviarPassword        ( Usucodigo, password )
		Envia un correo al usuario informando su nuevo password
	
	boolean cambiarUsuario        ( nuevo_login, nuevo_password )
		Solamente se puede invocar si se está autenticado como un usuario temporal
		
	query infoUsuario			  ( CEcodigo, uid, Usucodigo )
	
  	autenticar                    ( CEcodigo, uid, password )
  	autenticarUsucodigo           ( Usucodigo, password )
		Autentica un usuario con una contraseña.
		
	boolean insUsuarioRef (Usucodigo, Ecodigo, Tabla, referencia)
	boolean delUsuarioRef (Usucodigo, Ecodigo, Tabla)
	query getUsuarioByCod (Usucodigo, Ecodigo, Tabla)
	query getUsuarioByRef (referencia, Ecodigo, Tabla)
		
	CEcodigo buscarAliaslogin(CEaliaslogin)
		El CEaliaslogin se utiliza solamente si no se puede determinar por
		el dominio especificado en el HTTP Header "Host".
		Si no encuentra nada, regresa 1
	
	privados:
		boolean _CAMBIA_PASSWORD_BACKEND(usucodigo,newPasswd)
		boolean _AUTENTICAR_BACKEND(usucodigo,password)

--->

<cfcomponent>
	
    <cfif isdefined("session.dsn") and #session.dsn# EQ 'Cloud'>
    	<cfset Arguments.Conexion = 'minisif'>
    <cfelse>
    	<cfset Arguments.Conexion = 'asp'>
    </cfif>
	<cfset This.MetodosValidosCode = 'asp,ldap'>

	<!--- este bloque debería guardarse en cache o en session --->
		<cfinvoke component="Politicas" method="trae_parametro_global" parametro="auth.orden" Conexion ="#Arguments.Conexion#"
			returnvariable="ret"/>
		<cfif ret is '0'><cfset ret = 'asp'></cfif>
		<cfset This.PoliticaAuthOrden = ret>
	
		<cfinvoke component="Politicas" method="trae_parametro_global" parametro="auth.nuevo"  Conexion ="#Arguments.Conexion#"
			returnvariable="ret"/>
		<cfset This.PoliticaAuthNuevo = ret>
	<!--- /este bloque debería guardarse en cache o en session --->
	

	<cffunction name="init">
		<cfreturn This>
	</cffunction>

	<cffunction name="cambiarPassword" access="public" returntype="boolean" output="false" displayname="Cambiar Password" hint="Cambia la contraseña del usuario autenticado">
		<cfargument name="password_viejo" type="string" required="yes">
		<cfargument name="password_nuevo" type="string" required="yes">
		
        <cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="dataPoliticas" CEcodigo="#session.CEcodigo#"/>
		<cfset return_value = false>
		<cfif IsDefined("session.Usucodigo")  And IsDefined("session.AUTHBACKEND")>
			<cfset BACKEND = this.AUTHLOOP_AUTENTICAR(session.Usucodigo,arguments.password_viejo)>
			<cfif Len(BACKEND)>
				<cfset return_value = Len(this.AUTHLOOP_CAMBIA_PASSWORD(session.Usucodigo,arguments.password_nuevo, session.AUTHBACKEND)) NEQ 0>
			<cfelse>
				<cfset This.login_incorrecto(session.CEcodigo, session.Usucodigo, 
					session.usuario, 'CambiarPassword: Usuario / password anterior incorrectos')>
			</cfif>
		</cfif>
		<cfreturn return_value>
	</cffunction>
    <!---funcion nueva que busca los password historicos--->
   	<cffunction name="verificaPasswordHist" access="public" returntype="boolean" output="false" displayname="Valida Password Historicos" hint="Valida con Historicos que no existe la contraseña">
		<cfargument name="password_nuevo" 	type="string" required="yes">
        <cfargument name="password_viejo" 	type="string" required="yes">
        <cfargument name="validar" 			type="numeric" required="yes">
		<cfset return_val = false>
        
        <!---Comparo con el actual--->
        <cfquery datasource="asp" name="password_query">
			select
				a.Hash, a.HashMethod, a.PasswordSalt,
				b.Usulogin, b.CEcodigo, a.AllowedAccess
			from UsuarioPassword a, Usuario b
			where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			  and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		</cfquery>
         
       <cfinvoke component="Hash" method="hashPassword" returnvariable="new_hash"
			hashMethod="MD5"
			passwd="#Arguments.password_nuevo#"
			uid="#password_query.Usulogin#"
			CEcodigo="#password_query.CEcodigo#"
			passwdSalt="#password_query.PasswordSalt#" />
            
            <!---Realizo la consulta--->
            <cfif new_hash eq password_query.Hash>
            	<cflog file="seguridad" text="Su password NO puede ser el mismo que los #validar# anteriores.">
				<cfreturn false>
            </cfif> 
      
            <cfset validar = validar - 1>
            <cfif validar gt 0>
            	    <!---Obtengo en historicos --->
                    <cfquery datasource="asp" name="password_history">
                        select
                            a.Hash, a.HashMethod, a.PasswordSalt,
                            b.Usulogin, b.CEcodigo, a.numero
                        from UsuarioPasswordHist a, Usuario b
                        where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                          and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                           and a.numero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#validar#"> 
                    </cfquery>

                    <cfif password_history.recordcount gt 0>
                        <cfloop query="password_history">
                                   <cfinvoke component="Hash" method="hashPassword" returnvariable="new_hash"
                                    hashMethod="MD5"
                                    passwd="#Arguments.password_nuevo#"
                                    uid="#password_history.Usulogin#"
                                    CEcodigo="#password_history.CEcodigo#"
                                    passwdSalt="#password_history.PasswordSalt#" />
                                
                                <!---Realizo la consulta--->
                                <cfif new_hash eq password_history.Hash>
                                    <cflog file="seguridad" text="Su password NO puede ser el mismo que los #validar# anteriores.">
                                    <cfreturn false>
                                </cfif> 
                            
                        </cfloop>
                    </cfif>
            </cfif> 
            
            <cfreturn true>
                  
   </cffunction>

	<cffunction name="generarPassword" access="public" returntype="boolean" output="false" displayname="Generar Password"
		hint="Generar y enviar una nueva contraseña por correo para el usuario especificado.<br>
			  Esta es una función diseñada para <strong>pso</strong> o el administrador de la cuenta empresarial,
			  y debe usarse con cuidado ya que esto no se está validando.<br>
			  Específicamente, no se debe permitir el acceso directo mediante URL/WebService a este método por el usuario">
		<cfargument name="Usucodigo" type="numeric" required="yes">
		<cfargument name="notificar_por_email" type="boolean" required="yes">
        <cfargument name="Conexion" type="string" required="no" default="asp">
        
		
		<cfset var valid_password_chars = "bcdfgkmnpqrstvwx234789">
		<cfset var nuevo_password = this.__randomString(6, valid_password_chars)>
		<cfset var return_status = false>
		<cfif Arguments.Usucodigo EQ 1>
			<cfreturn false>
		</cfif>
		<cfset return_status = Len(this.AUTHLOOP_CAMBIA_PASSWORD(arguments.Usucodigo, nuevo_password, Arguments.Conexion )) NEQ 0>
		<cfif Arguments.notificar_por_email>
			<cfset This.enviarPassword(Arguments.Usucodigo, nuevo_password, Arguments.Conexion )>
		</cfif>
		<cfreturn return_status>
	</cffunction>
	
	<cffunction name="renombrarUsuario" access="public" returntype="boolean" output="false" displayname="Renombrar un usuario"
		hint="Realiza el cambio de login para un usuario.<br>
			  Esta es una función diseñada para <strong>pso</strong> o el administrador de la cuenta empresarial,
			  y debe usarse con cuidado ya que esto no se está validando.<br>
			  Específicamente, no se debe permitir el acceso directo mediante URL/WebService a este método por el usuario">
		<cfargument name="Usucodigo"       type="numeric" required="yes">
		<cfargument name="nuevo_login"     type="string"  required="yes">
		<cfargument name="nuevo_password"  type="string"  required="yes">
		
		<cfif Arguments.Usucodigo EQ 1>
			<cfreturn false>
		</cfif>
		<cfif Len(Trim(Arguments.nuevo_login)) NEQ 0>
			<cfif Not this.__renombraUsuario (Arguments.Usucodigo, Arguments.nuevo_login)>
				<cfreturn false>
			</cfif>
		</cfif>
		<cfif Len(Arguments.nuevo_password) GT 0>
			<cfset retval = Len(this.AUTHLOOP_CAMBIA_PASSWORD (Arguments.Usucodigo, Arguments.nuevo_password)) NEQ 0>
			<cfreturn retval>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="cambiarUsuario" access="public" returntype="boolean" output="false" displayname="Selecciona un usuario definitivo"
		hint="Realiza el cambio de login temporal por uno definitivo para el usuario autenticado.<br>
			  Esta función realiza el cambio de login y el de password de manera conjunta.">
		<cfargument name="nuevo_login"     type="string"  required="yes">
		<cfargument name="nuevo_password"  type="string"  required="yes">
		
		<cfset var return_status = false>
		<cfif Not  IsDefined("session.Usucodigo") Or Not IsDefined("session.AUTHBACKEND")>
			<cfreturn false>
		</cfif>
		<cfif session.logoninfo.Utemporal NEQ 1>
			<cfreturn false>
		</cfif>
		<cfif session.Usucodigo EQ 1>
			<cfreturn false>
		</cfif>
		<cfif Len(Arguments.nuevo_password) EQ 0>
			<cfreturn false>
		</cfif>
		<cfif Not this.__renombraUsuario (session.Usucodigo, Arguments.nuevo_login)>
			<cfreturn false>
		</cfif>
		<cfset session.Usulogin = Arguments.nuevo_login>
		<cfset ret = Len(this.AUTHLOOP_CAMBIA_PASSWORD (session.Usucodigo, Arguments.nuevo_password,'asp',session.AUTHBACKEND)) NEQ 0>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="infoUsuario" access="public" returntype="query" output="false" displayname="Obtiene informacion del usuario">
		<cfargument name="CEcodigo"  type="string" required="no" default="">
		<cfargument name="uid"       type="string" required="no" default="">
		<cfargument name="Usucodigo" type="numeric" required="no" default="0">
        <cfargument name="Conexion"  type="string" required="no" default="asp">

        
		<cfset var ret_struct = StructNew()>
		<cfset var where = "cuenta: #Arguments.CEcodigo#, uid: #Arguments.uid#, Usucodigo: #Arguments.Usucodigo#">
		<cfif Len(Arguments.CEcodigo) EQ 0>
			<cfset Arguments.CEcodigo = 1>
		</cfif>

		<cfquery datasource="#Arguments.Conexion#" name="__infousuario_query">
			select
				CEcodigo, Usucodigo, Uestado, Usulogin,
				Utemporal, id_direccion, datos_personales				
			from Usuario
			<cfif Len(Arguments.uid) NEQ 0>
				<cfset where = "CEcodigo = #Arguments.CEcodigo#, uid = #Arguments.uid#">
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
				  and Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.uid#">
			<cfelseif Arguments.Usucodigo NEQ 0>
				<cfset where = "Usucodigo = #Arguments.Usucodigo#">
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			<cfelse>
				<cfthrow message="Seguridad.infoUsuario(#Arguments.CEcodigo#,'#Arguments.uid#',#Arguments.Usucodigo#): Debe especificar CEcodigo/uid o Usucodigo">
			</cfif>
		</cfquery>
		<cfif __infousuario_query.RecordCount EQ 0>
			<cflog file="seguridad" text="No se encontró el perfil del usuario: #where#.">
		<cfelseif __infousuario_query.Uestado NEQ 1>
			<cflog file="seguridad" text="Usuario no está activo #Arguments.CEcodigo#, uid: #Arguments.uid#, Usucodigo: #Arguments.Usucodigo# (Uestado = #__infousuario_query.Uestado#)">
		</cfif>
		<cfreturn __infousuario_query>
	</cffunction>
	
	<cffunction name="autenticar" access="public" returntype="string" output="false" displayname="Autenticar usuario y password para cuenta empresarial"
		hint="Valida la información de conexión (usuario y password) dentro del contexto de una cuenta empresarial.
			  La cuenta empresarial se especifica mediante el alias (CuentaEmpresarial.CEaliaslogin), que es el tercer
			  campo de captura que aparece en algunas ventanas de login.<br>
			  Regresa el nombre del mecanismo de autenticación que aceptó al usuario.<br>
			  <br>Ejemplo:<br><br><code>
			  &nbsp;&nbsp;Usuario:&nbsp;&nbsp;&nbsp;&nbsp;****<br>
			  &nbsp;&nbsp;Contraseña:&nbsp;****<br>
			  &nbsp;&nbsp;<strong>Empresa</strong>:&nbsp;&nbsp;&nbsp;&nbsp;****</code>
			  ">
		<cfargument name="CEcodigo"  type="numeric" required="yes">
		<cfargument name="uid"       type="string" required="yes">
		<cfargument name="password"  type="string" required="yes">
		
		<cfset var user_info = infoUsuario(Arguments.CEcodigo, Arguments.uid)>
		<cfif Len(user_info.Usucodigo) EQ 0>
			<cflog file="seguridad" text="Usuario no autenticado; CEcodigo: #Arguments.CEcodigo#, uid: #Arguments.uid#: Usuario no existe">
			<cfset This.login_incorrecto(Arguments.CEcodigo, "",
				Arguments.uid, 'Usuario no existe')>
		<cfelseif user_info.Uestado NEQ 1>
			<cflog file="seguridad" text="Usuario no autenticado; CEcodigo: #Arguments.CEcodigo#, uid: #Arguments.uid#: Usuario no está activo (Uestado = #user_info.Uestado#)">
			<cfset This.login_incorrecto(Arguments.CEcodigo, user_info.Usucodigo,
				Arguments.uid, 'Usuario no está activo (Uestado = #user_info.Uestado#)')>
		<cfelseif This.__UsuarioBloqueado(user_info.Usucodigo)>
			<cflog file="seguridad" text="Usuario está autenticado; CEcodigo: #Arguments.CEcodigo#, uid: #Arguments.uid#: Usuario está bloqueado (UsuarioBloqueo)">
			<cfset This.login_incorrecto(Arguments.CEcodigo, user_info.Usucodigo,
				Arguments.uid, 'Usuario está bloqueado (UsuarioBloqueo)')>
		<cfelse>
			<cfset backend = This.AUTHLOOP_AUTENTICAR(user_info.Usucodigo, Arguments.password)>
			<cfif Len(backend)>
				<cfreturn backend>
			<cfelse>
				<cfset This.login_incorrecto(Arguments.CEcodigo, user_info.Usucodigo,
					Arguments.uid, 'Usuario / password incorrectos')>
			</cfif>
		</cfif>
		<cfreturn ''>
	</cffunction>
	
	<cffunction name="autenticarUsucodigo" access="public" returntype="string" output="false" displayname="Autenticar usuario y password para cuenta empresarial"
		hint="Valida la información de conexión (usuario y password) para un usuario específico.
			  La cuenta empresarial no se especifica porque viene implícita en el Usucodigo<br>
			  Regresa el nombre del mecanismo de autenticación que aceptó al usuario.<br>
			  ">
		<cfargument name="Usucodigo"  type="numeric" required="yes">
		<cfargument name="password"  type="string" required="yes">
		
		<cfset var user_info = ''>
		<cfif Arguments.Usucodigo Is 0>
			<cflog file="seguridad" text="Usuario no autenticado; Usucodigo: 0: Usuario no existe">
			<cfset This.login_incorrecto("", Arguments.Usucodigo, "", 'Usucodigo 0 no es valido')>
			<cfreturn ''>
		</cfif>
		
		<cfset user_info = infoUsuario ( "", "", Arguments.Usucodigo ) >
		<cfif Len(user_info.Usucodigo) EQ 0>
			<cflog file="seguridad" text="Usuario no autenticado; Usucodigo: #Arguments.Usucodigo#: Usuario no existe">
			<cfset This.login_incorrecto("", Arguments.Usucodigo,
				"", 'Usuario no existe')>
		<cfelseif user_info.Uestado NEQ 1>
			<cflog file="seguridad" text="Usuario no autenticado; Usucodigo: #Arguments.Usucodigo#: Usuario no está activo (Uestado = #user_info.Uestado#)">
			<cfset This.login_incorrecto(user_info.CEcodigo, user_info.Usucodigo,
				user_info.Usulogin, 'Usuario no está activo (Uestado = #user_info.Uestado#)')>
		<cfelseif This.__UsuarioBloqueado(user_info.Usucodigo)>
			<cflog file="seguridad" text="Usuario está autenticado; Usucodigo: #Arguments.Usucodigo#: Usuario está bloqueado (UsuarioBloqueo)">
			<cfset This.login_incorrecto(user_info.CEcodigo, user_info.Usucodigo,
				user_info.Usulogin, 'Usuario está bloqueado (UsuarioBloqueo)')>
		<cfelse>
			<cfset backend = This.AUTHLOOP_AUTENTICAR(user_info.Usucodigo, Arguments.password)>
			<cfif Len(backend)>
				<cfreturn backend>
			<cfelse>
				<cfset This.login_incorrecto(user_info.CEcodigo, user_info.Usucodigo,
					user_info.Usulogin, 'Usuario / password incorrectos')>
			</cfif>
		</cfif>
		<cfreturn ''>
	</cffunction>
	
	<cffunction name="random_login" access="public" returntype="string" output="false" displayname="Generar login aleatorio">
	
		<cfset var cta = ''><!--- varchar 10 --->
		<cfset var ulogin = ''><!--- varchar 30 --->
		<cfset var uid = ''><!--- numeric 18 --->
		<cfset var d = Now()>
		<cfset var new_login = ''>
		<cfloop condition="true">
			<cfset new_login = 
				Chr(Rand()*26 + 97) &
				Chr(Rand()*26 + 97) &
				Chr(Rand()*26 + 97) &
				Chr(Rand()*26 + 97) &
				Chr(Rand()*26 + 97) & '-' &
				Chr(Rand()* 8 + 50) &
				Chr(Rand()* 8 + 50)>
			<cfquery datasource="asp" name="buscarlogin">
				select Usulogin
				from Usuario
				where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_login#">
			</cfquery>
			<cfif buscarlogin.RecordCount is 0>
				<cfreturn new_login>
			</cfif>
		</cfloop>

	</cffunction>
	
	<cffunction name="crearUsuario" access="public" returntype="numeric" output="true" displayname="Crear usuario nuevo"
		hint="Crea un usuario en la cuenta empresarial especificada.<br><br>
				Esta función está diseñada para crear usuarios finales de las aplicaciones 
				(eg. como empleados de RH, feligreses, etc.)<br>
				No permite crear usuario administradores o inactivos por este medio<br>
				Si no se especifica un login, o este está vacío, el sistema generará un usuario temporal">
		<cfargument name="CEcodigo"         type="numeric" required="yes">
		<cfargument name="id_direccion"     type="numeric" required="yes">
		<cfargument name="datos_personales" type="numeric" required="yes">
		<cfargument name="idioma" 			type="string"  required="yes">
		<cfargument name="expiracion" 		type="date"	   required="yes">
		<cfargument name="Usulogin"         type="string"  required="yes">
		<cfargument name="notificar_por_email"  type="boolean" required="yes">
        <cfargument name="Conexion"         type="string"  required="no" default="asp">
        <cfargument name="TransaccionAtiva" type="boolean"  required="no" default="false" >
		

		<cfif Not IsDefined("session.Usucodigo")>
			<cfreturn 0>
		</cfif>
		<cfif Len(Trim(Arguments.Usulogin)) EQ 0 Or Arguments.Usulogin EQ '*'>
			<cfset Usulogin_real = This.random_login()>
		<cfelse>
			<cfset Usulogin_real = Arguments.Usulogin>
		</cfif>
		<cfif Len(Trim(Arguments.expiracion)) EQ 0>
			<cfset Arguments.expiracion = ParseDateTime('01/01/6100', 'dd/mm/yyyy')>
		</cfif>
        
		<cfif Arguments.TransaccionAtiva >
        	<cfset crearUsuarioInsert(Arguments)>
        <cfelse>
            <cftransaction>
             <cfset crearUsuarioInsert(Arguments)>
            </cftransaction>
        </cfif> 

		<cfif listFindNoCase(Application.politicas_pglobal.auth.orden,'google',',') EQ 0>
			<cfset This.generarPassword( nuevo_usuario.identity, Arguments.notificar_por_email, Arguments.Conexion )>
		</cfif>
        
        <cfreturn nuevo_usuario.identity>
	</cffunction>
    
    <cffunction name="crearUsuarioInsert" access="private"> 
    <cfargument name="Arguments" type="any"  required="no">
        <cfquery datasource="#Arguments.Conexion#" name="nuevo_usuario">
            insert into Usuario (CEcodigo, id_direccion, datos_personales, Usulogin, Utemporal, LOCIdioma, Ufdesde, Ufhasta, BMUsucodigo, BMfecha)
            values (
                <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.CEcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.id_direccion#">,
                <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.datos_personales#">,
                <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Trim(Usulogin_real)#">,
                <cfqueryparam cfsqltype="cf_sql_bit"       value="#Arguments.Usulogin EQ '*'#">,
                <cfqueryparam cfsqltype="cf_sql_char" 	   value="#Arguments.idioma#" null="#Len(Trim(Arguments.idioma)) EQ 0#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
                <cfqueryparam cfsqltype="cf_sql_date"      value="#Arguments.expiracion#">,
                <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
            )
            <cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>	
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="nuevo_usuario">
    </cffunction>
    
	
	<cffunction name="insUsuarioRef" access="public" returntype="boolean" output="false" displayname="Insertar Referencia de Usuario">
		<cfargument name="Usucodigo"	type="numeric"	required="yes">
		<cfargument name="Ecodigo"		type="numeric"	required="yes">
		<cfargument name="Tabla"		type="string"	required="yes">
		<cfargument name="referencia"	type="string"	required="yes">
		
		<cfquery name="checkTabla" datasource="asp">
			select 1
			from STablas
			where STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tabla#">
		</cfquery>

		<cfif checkTabla.recordCount is 0>
			<cflog file="seguridad" text="El argumento Tabla: #Arguments.Tabla# no existe.">
			<cfthrow message="No se ha parametrizado la tabla #HTMLEditFormat(Arguments.Tabla)# en el portal.">
		</cfif>
		<cfquery datasource="asp" name="exists1">
			select 1
			from UsuarioReferencia
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tabla#">
		</cfquery>
		<cfquery datasource="asp" name="exists2">
			select 1
			from UsuarioReferencia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tabla#">
			  and llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.referencia#">
		</cfquery>
		<cfif exists1.RecordCount Is 0 and exists2.RecordCount Is 0>
			<cfquery datasource="asp">
				insert into UsuarioReferencia(Usucodigo, Ecodigo, STabla, llave, BMUsucodigo, BMfecha)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tabla#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.referencia#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">	)
			</cfquery>
			<cfreturn true>
		<cfelse>
			<cflog file="seguridad" text="La referencia del usuario no se inserto porque ya existe.">
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="delUsuarioRef" access="public" output="false" displayname="Eliminar Referencia de Usuario">
		<cfargument name="Usucodigo"	type="numeric"	required="yes">
		<cfargument name="Ecodigo"		type="numeric"	required="yes">
		<cfargument name="Tabla"		type="string"	required="yes">
		
		<cfquery name="borrar_referencia" datasource="asp">
			delete UsuarioReferencia
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tabla#">
		</cfquery>
	</cffunction>

	<cffunction name="getUsuarioByCodNoEmp" access="public" returntype="query" output="false" displayname="Obtiene Referencia por Usucodigo">
		<cfargument name="Usucodigo"	type="numeric"	required="yes"	default="">
		<cfargument name="Tabla"		type="string"	required="yes"	default="">

		<cfset var where = "Usucodigo: #Arguments.Usucodigo#, Tabla: #Arguments.Tabla#">
        
        <cf_dbdatabase table="Usuario" datasource="asp" returnvariable="LvarUsuario">
        <cf_dbdatabase table="UsuarioReferencia" datasource="asp" returnvariable="LvarUsuarioReferencia">
        <cf_dbdatabase table="DatosPersonales" datasource="asp" returnvariable="LvarDatosPersonales">
		<cfquery datasource="#session.DSN#" name="__infousuario_query">
			select distinct b.llave,c.Pnombre, c.Papellido1, c.Papellido2
			from #LvarUsuario# a, #LvarUsuarioReferencia# b, #LvarDatosPersonales# c
			where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			and a.Usucodigo = b.Usucodigo
			and b.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tabla#">
			and a.datos_personales = c.datos_personales
		</cfquery>
		<!--- <cf_dump var="#__infousuario_query#"> --->
		<cfif __infousuario_query.RecordCount EQ 0>
			<!---
				Usuario no encontrado, pero no sale en el log porque 
				esto dificulta el monitoreo de los servidores de producción
			<cflog file="seguridad" text="Usuario no encontrado: #where#.">
			--->
		</cfif>
		<cfreturn __infousuario_query>
	</cffunction>
	
	<cffunction name="getUsuarioByCod" access="public" returntype="query" output="false" displayname="Obtiene Referencia por Usucodigo">
		<cfargument name="Usucodigo"	type="numeric"	required="yes"	default="">
		<cfargument name="Ecodigo"		type="numeric"	required="yes"	default=""><!--- session.EcodigoSDC --->
		<cfargument name="Tabla"		type="string"	required="yes"	default="">

		<cfset var where = "Usucodigo: #Arguments.Usucodigo#, Ecodigo: #Arguments.Ecodigo#, Tabla: #Arguments.Tabla#">
        
        <cf_dbdatabase table="Usuario" datasource="asp" returnvariable="LvarUsuario">
        <cf_dbdatabase table="UsuarioReferencia" datasource="asp" returnvariable="LvarUsuarioReferencia">
        <cf_dbdatabase table="DatosPersonales" datasource="asp" returnvariable="LvarDatosPersonales">
        <cf_dbdatabase table="Direcciones" datasource="asp" returnvariable="LvarDirecciones">
        
		<cfquery datasource="#session.DSN#" name="__infousuario_query">
			select a.CEcodigo, 
				   a.Usucodigo, 
				   a.Uestado, 
				   a.Usulogin, 
				   a.Utemporal, 
				   (case when a.Uestado = 0 then 0 when a.Uestado = 1 and a.Utemporal = 1 then 1 when a.Uestado = 1 and a.Utemporal = 0 then 2 else 0 end) as Estado,
				   a.id_direccion, 
				   a.datos_personales,
				   b.llave,
				   b.llave as num_referencia,
				   c.Pid, c.Pnombre, c.Papellido1, c.Papellido2, 
				   c.Pnacimiento, c.Psexo, 
				   c.Pcasa, c.Poficina, c.Pcelular, c.Pfax, c.Ppagertel, c.Ppagernum, 
				   c.Pemail1, c.Pemail2, c.Pweb,
				   d.Ppais, d.atencion, d.direccion1, d.direccion2, d.ciudad, d.estado, d.codPostal
			from #LvarUsuario# a, #LvarUsuarioReferencia# b, #LvarDatosPersonales# c, #LvarDirecciones# d
			where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			and a.Usucodigo = b.Usucodigo
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			and b.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tabla#">
			and a.datos_personales = c.datos_personales
			and a.id_direccion = d.id_direccion
		</cfquery>
		<cfif __infousuario_query.RecordCount EQ 0>
			<!---
				Usuario no encontrado, pero no sale en el log porque 
				esto dificulta el monitoreo de los servidores de producción
			<cflog file="seguridad" text="Usuario no encontrado: #where#.">
			--->
		</cfif>
		<cfreturn __infousuario_query>
	</cffunction>
	
	
	

	<cffunction name="getUsuarioByRef" access="public" returntype="query" output="false" displayname="Obtiene Referencia por Referencia">
		<cfargument name="referencia"	type="string"	required="yes"	default="">
		<cfargument name="Ecodigo"		type="numeric"	required="yes"	default="">
		<cfargument name="Tabla"		type="string"	required="yes"	default="">
		<cfargument name="conexion"		type="string"	required="no"	default="asp">

		<cfset var where = "referencia: #Arguments.referencia#, Ecodigo: #Arguments.Ecodigo#, Tabla: #Arguments.Tabla#">
		<cfquery datasource="#arguments.conexion#" name="__infousuario_query">
			select a.CEcodigo, 
				   a.Usucodigo, 
				   a.Uestado, 
				   a.Usulogin, 
				   a.Utemporal, 
				   (case when a.Uestado = 0 then 0 when a.Uestado = 1 and a.Utemporal = 1 then 1 when a.Uestado = 1 and a.Utemporal = 0 then 2 else 0 end) as Estado,
				   a.id_direccion, 
				   a.datos_personales,
				   b.llave,
				   b.llave as num_referencia,
				   c.Pid, c.Pnombre, c.Papellido1, c.Papellido2, 
				   c.Pnacimiento, c.Psexo, 
				   c.Pcasa, c.Poficina, c.Pcelular, c.Pfax, c.Ppagertel, c.Ppagernum, 
				   c.Pemail1, c.Pemail2, c.Pweb,
				   d.Ppais, d.atencion, d.direccion1, d.direccion2, d.ciudad, d.estado, d.codPostal
			from UsuarioReferencia b, Usuario a, DatosPersonales c, Direcciones d
			where b.llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.referencia#">
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			and b.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tabla#">
			and a.Usucodigo = b.Usucodigo
			and a.datos_personales = c.datos_personales
			and a.id_direccion = d.id_direccion
		</cfquery>
		<cfif __infousuario_query.RecordCount EQ 0>
			<!---
				Usuario no encontrado, pero no sale en el log porque 
				esto dificulta el monitoreo de los servidores de producción
			<cflog file="seguridad" text="Usuario no encontrado: #where#.">
			--->
		</cfif>
		<cfreturn __infousuario_query>
	</cffunction>

	<cffunction name="insUsuarioRol"  access="public" returntype="boolean" output="false" displayname="Inserta un Rol a un Usuario">
		<cfargument name="Usucodigo"	type="numeric"	required="yes"	default="">
		<cfargument name="Ecodigo"		type="numeric"	required="yes"	default="">
		<cfargument name="SScodigo"		type="string"	required="yes"	default="">
		<cfargument name="SRcodigo"		type="string"	required="yes"	default="">
        <cfargument name="TransaccionAtiva"		type="boolean"	required="yes"	default="false">

		<cfquery name="checkTabla" datasource="asp">
			select 1
			from SRoles
			where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SScodigo#">
			and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SRcodigo#">
		</cfquery>
		<cfif checkTabla.RecordCount is 0>
			<cflog file="seguridad" text="El Rol #Arguments.SRcodigo# en el Sistema #Arguments.SScodigo# no existe.">
			<cfthrow message="No se ha parametrizado el SRcodigo #HTMLEditFormat(Arguments.SRcodigo)# en el portal.">
		</cfif>
		<cfquery datasource="asp" name="exists1">
			select 1
			from UsuarioRol
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SScodigo#">
			and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SRcodigo#">
		</cfquery>
		<cfif exists1.RecordCount Is 0>
			<cfquery name="insertar_rol" datasource="asp">
				insert into UsuarioRol(Usucodigo, Ecodigo, SScodigo, SRcodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SScodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SRcodigo#">
				)
			</cfquery>
			<cfinvoke component="MantenimientoUsuarioProcesos" method="actualizar">
				<cfinvokeargument name="Usucodigo" value="#Arguments.Usucodigo#">
				<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#">
				<cfinvokeargument name="SScodigo" value="#Arguments.SScodigo#">
                <cfinvokeargument name="TransaccionAtiva" value="#Arguments.TransaccionAtiva#">
			</cfinvoke>
			<cfreturn true>
		<cfelse>
			<cflog file="seguridad" text="El rol del usuario no se insertó porque ya existe.">
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="delUsuarioRol" access="public" output="false" displayname="Eliminar Referencia de Usuario">
		<cfargument name="Usucodigo"	type="numeric"	required="yes"	default="">
		<cfargument name="Ecodigo"		type="numeric"	required="yes"	default="">
		<cfargument name="SScodigo"		type="string"	required="yes"	default="">
		<cfargument name="SRcodigo"		type="string"	required="yes"	default="">
		
		<cfquery name="borrar_rol" datasource="asp">
			delete UsuarioRol
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SScodigo#">
			and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SRcodigo#">
		</cfquery>
	</cffunction>

	<cffunction name="enviarPassword" access="public" returntype="boolean" output="true">
		<cfargument name="Usucodigo" 		type="numeric" 	required="yes">
		<cfargument name="password"  		type="string"  	required="yes">
	    <cfargument name="Conexion"  		type="string"  	required="no">
		<cfargument name="incluir_login"  	type="boolean"  required="no" default="yes">
        
		<cfset var hostname = "localhost">
		<cfif IsDefined("Caller.session.sitio.host") and Len(session.sitio.host) GT 0>
			<cfset hostname = Caller.session.sitio.host>
		<cfelseif IsDefined("session.sitio.host") and Len(session.sitio.host) GT 0>
			<cfset hostname = session.sitio.host>
		</cfif>
		<cfset _user_info = This.infoUsuario('','',Arguments.Usucodigo,Arguments.Conexion)>
		<cfif _user_info.RecordCount EQ 0>
			<cflog file="seguridad" text="No se envia el password para el usuario no existente #Arguments.Usucodigo#">
			<cfreturn false>
		</cfif>
		<cf_datospersonales action="select" key="#_user_info.datos_personales#" name="_user_datos_personales" datasource="#Arguments.Conexion#">

		<cfsavecontent variable="_mail_body">
			<cfset _password = Arguments.password>
			<cfset _incluir_login = Arguments.incluir_login>
			<cfinclude template="mailbody.cfm">
			<cfset _password = "">
		</cfsavecontent>

		<cfinvoke component="home.Componentes.Politicas" method="trae_parametro_global" returnvariable="mail_cambiar">
			<cfinvokeargument name="parametro" value="pass.mail.cambiar">
		</cfinvoke>
	
		<cfif mail_cambiar EQ "1">
			<cfquery datasource="#Arguments.Conexion#">
				update UsuarioPassword
				   set PasswordSet = <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(1999,01,01)#">
				 where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			</cfquery>
		</cfif>
		
		<cfset FromEmail = "Seguridad@soin.co.cr">
		<cfquery name="CuentaPortal"  datasource="asp">
			Select valor
			from  PGlobal
			Where parametro='correo.cuenta'
		</cfquery>
		<cfif isdefined ('CuentaPortal') and CuentaPortal.Recordcount GT 0>
			<cfset FromEmail=CuentaPortal.valor>
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#">
			insert into SMTPQueue (
				SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FromEmail#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#_user_datos_personales.email1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Nueva contraseña">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#_mail_body#">, 1)
		</cfquery>
		<cflog file="seguridad" text="Password enviado para usuario #Arguments.Usucodigo# - #_user_info.Usulogin#">
		<cfreturn true>
	</cffunction>
	
	<!---
		esta funcion solamente se va a utilizar cuando haya que hacer autenticación entre distitos dominios


  	reautenticar                  ( CEcodigo, uid, ticket )
		Valida un ticket de re autenticación para una sola vez
		La cuenta (aka alias_login) se utiliza solamente si no se puede determinar por
		el dominio especificado en el HTTP Header "Host".
	
  	getTicket                     ( )
		Obtiene un ticket de autenticación


	<cffunction name="reautenticar" access="public" returntype="boolean" output="false">
		<cfargument name="TicketID"  type="string" required="yes">
		<cfargument name="ticket"    type="string" required="yes">
		
		SELECT TicketData, TicketExpires
		FROM UsuarioTicket
		WHERE TicketID = #TicketID#
		  AND getdate() <= TicketExpires
		
		<cfset var TicketData      = QUERY.TicketData>
		<cfset var TicketExpires   = QUERY.TicketExpires>
		<cfreturn ticket is __ticketHash(session.Usucodigo, TicketData, TicketExpires, Arguments.TicketID)>
	</cffunction>
	--->

	<!---
		esta funcion solamente se va a utilizar cuando haya que hacer autenticación entre distitos dominios
	<cffunction name="getTicket" access="public" returntype="string" output="false">
		<!--- generar nuevo ticket y guardar en base de datos --->
		<cfset var TicketData      = Hash( Now() & Rand() * 100000 )>
		<cfset var TicketExpires   = DateAdd( "n", 1, Now() )>
		<cfset var TicketID        = "226">
		<cfreturn __ticketHash(session.Usucodigo, TicketData, TicketExpires, TicketID)>
	</cffunction>
	--->

	<!---------------------------->
	<!--- funciones auxiliares --->
	<!---------------------------->
	<!---
		esta funcion solamente se va a utilizar cuando haya que hacer autenticación entre distitos dominios
	<cffunction name="__ticketHash" access="package" returntype="string" output="false">
		<cfargument name="Usucodigo" type="string" required="yes">
		<cfargument name="TicketData" type="string" required="yes">
		<cfargument name="TicketExpires" type="string" required="yes">
		<cfargument name="TicketID" type="string" required="yes">
		
		<cfset var ticket = Arguments.Usucodigo  & ',' &
							LCase(Arguments.TicketData) & ',' &
							DateFormat(Arguments.TicketExpires,'yyyymmdd') &
							TimeFormat(Arguments.TicketExpires,'HHMMSS')   & ',' &
							Arguments.TicketID>
		<cfreturn LCase(Hash('1' & ticket)) & LCase(Hash('2' & ticket) )>
	</cffunction>
	--->
	
	<cffunction name="__UsuarioBloqueado">
		<cfargument name="Usucodigo"   type="numeric" required="true">
		
		<cfquery datasource="aspmonitor" name="bloqueos">
			select count(1) bloqueado
			from UsuarioBloqueo
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			  and bloqueo > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			  and desbloqueado = 0
		</cfquery> 
		<cfreturn bloqueos.bloqueado neq 0>
	</cffunction>
	
	<cffunction name="__renombraUsuario" access="package" returntype="boolean" output="false" displayname="USO INTERNO"
		hint="USO INTERNO.<br>Actualiza el login en la tabla de usuarios">
		<cfargument name="Usucodigo"   type="numeric" required="true">
		<cfargument name="nuevo_login" type="string"  required="true">
		<cfquery datasource="asp" name="_rename_check">
			select dupl.Usucodigo
			from Usuario este, Usuario dupl
			where este.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			  and dupl.Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nuevo_login#">
			  and dupl.Usucodigo != este.Usucodigo
			  and dupl.CEcodigo = este.CEcodigo
		</cfquery>
		<cfif _rename_check.RecordCount GT 0>
			<cflog file="seguridad" text="No se puede renombrar el usuario con Usucodigo = #Usucodigo# a #nuevo_login# porque este ya pertenece a #ValueList(_rename_check.Usucodigo)#"/>
			<cfreturn false>
		</cfif>
		<cfquery datasource="asp">
			update Usuario
			set Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nuevo_login#">,
			    Utemporal = 0
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="buscarAliasLogin" access="public" returntype="numeric" output="false" displayname="USO INTERNO"
		hint="USO INTERNO.<br>Obtiene el CEcodigo a partir del CEaliaslogin">
		<cfargument name="CEaliaslogin"   type="string" required="true">
		
		<cfif IsDefined("session.sitio.CEcodigo") and Len(session.sitio.CEcodigo) NEQ 0 and session.sitio.CEcodigo NEQ 0>
			<cfreturn session.sitio.CEcodigo>
		</cfif>
		<cfif Len(Trim(Arguments.CEaliaslogin)) EQ 0>
			<cfreturn 1>
		</cfif>
		<cfquery datasource="asp" name="__getCE_alias_query">
			select CEcodigo
			from CuentaEmpresarial
			where ltrim(rtrim(lower(CEaliaslogin))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase( Trim( Arguments.CEaliaslogin ))#">
		</cfquery>
		<cfif __getCE_alias_query.RecordCount EQ 1>
			<cfreturn __getCE_alias_query.CEcodigo>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>

	<cffunction name="buscarUsuarioGlobal" access="public" returntype="numeric" output="false" displayname="USO INTERNO"
		hint="USO INTERNO.<br>Obtiene el CEcodigo a partir del CEaliaslogin">
		<cfargument name="CEaliaslogin"   type="string" required="true">
		<cfargument name="uid"            type="string" required="true">
		
		<cfset var CEcodigo = "">
		<cfif IsDefined("session.sitio.CEcodigo") and Len(session.sitio.CEcodigo) NEQ 0 and session.sitio.CEcodigo NEQ 0 and Arguments.uid NEQ 'pso'>
				<cfset CEcodigo = session.sitio.CEcodigo>
		</cfif>
		<cfquery datasource="asp" name="__buscar_usuario">
			select u.Usucodigo
			from Usuario u
				join CuentaEmpresarial c
					on u.CEcodigo = c.CEcodigo
			where u.Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.uid#">
			<cfif Len(CEcodigo)>
			  and u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CEcodigo#">
			<cfelseif Arguments.CEaliaslogin Is '*'>
			<cfelseif Len(Trim(Arguments.CEaliaslogin))>
			  and ltrim(rtrim(lower(CEaliaslogin))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase( Trim( Arguments.CEaliaslogin ))#">
			<cfelse>
			  and (CEaliaslogin in ('', ' ') or ltrim(rtrim(CEaliaslogin)) in ('', ' ') or CEaliaslogin is null)
			</cfif>
			order by u.Usucodigo asc
		</cfquery>
		<cfif __buscar_usuario.RecordCount EQ 1>
			<cfreturn __buscar_usuario.Usucodigo>
		<cfelseif __buscar_usuario.RecordCount GT 1>
			<cflog file="seguridad" text="Hay más de un usuario con el login #Arguments.uid#, y son (#ValueList (__buscar_usuario.Usucodigo)#).  Se selecciona el primero de ellos.">
			<cfreturn __buscar_usuario.Usucodigo>
		<cfelse>
			<!--- no existe un usuario con ese codigo --->
			<cflog file="seguridad" text="buscarUsuarioGlobal: Usuario no existe: aliaslogin: #Arguments.CEaliaslogin#, login: #Arguments.uid#">
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="__randomString" access="public" returntype="string" output="false">
		<cfargument name="size" type="numeric" required="yes">
		<cfargument name="validChars" type="string" required="no"
			default="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789">
		
		<cfset var SALT_DIGITS = validChars.toCharArray()>
		<cfset ch = "">
		<cfloop from="1" to="#Arguments.size#" index="n">
			<cfset ch = ch & SALT_DIGITS[Rand() * ArrayLen(SALT_DIGITS) + 1] >
		</cfloop>
	  	<cfreturn ch>
	</cffunction>
	
	<cffunction name="login_incorrecto">
		<cfargument name="CEcodigo"      required="yes">
		<cfargument name="Usucodigo"     required="yes">
		<cfargument name="uid"           required="yes">
		<cfargument name="razon"         required="yes">
		
		<cfset LIcontador = 1>
		<cfset LIbloqueo  = "">
		<cfif Len(Arguments.Usucodigo) and Len(Arguments.CEcodigo)>
			<!--- Tenemos identificado el usuario. Primero hay que buscar el contador, para irlo incrementando --->
			<cfset Politicas = CreateObject("component", "Politicas")>
			<cfset sesion_bloqueo_cant     = Politicas.trae_parametro_usuario("sesion.bloqueo.cant",     Arguments.Usucodigo)>
			<cfset sesion_bloqueo_duracion = Politicas.trae_parametro_usuario("sesion.bloqueo.duracion", Arguments.Usucodigo)>
			<cfset sesion_bloqueo_periodo  = Politicas.trae_parametro_usuario("sesion.bloqueo.periodo",  Arguments.Usucodigo)>
			<cfif sesion_bloqueo_periodo>
				<cfquery datasource="aspmonitor" name="LIcontador_anterior">
					select max (LIcontador) as LIcontador
					from LoginIncorrecto
					where LIcuando  > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n', -sesion_bloqueo_periodo, Now())#">
					  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.Usucodigo#">
					  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.CEcodigo#">
					  and LIcontador is not null
				</cfquery>
				<cfif Len(LIcontador_anterior.LIcontador)>
					<cfset LIcontador = LIcontador_anterior.LIcontador + 1>
				</cfif>
				<cfif LIcontador GE sesion_bloqueo_cant>
					<!--- bloquear cuenta --->
					<cfset razon = 'El usuario ha fallado en su ingreso ' & LIcontador & ' veces'>
					<cfif sesion_bloqueo_duracion>
						<cfset LIbloqueo = DateAdd('n', sesion_bloqueo_duracion, Now())>
						<cfset razon = razon & ', bloqueado hasta ' & 
							DateFormat(LIbloqueo,'dd-mm-yyyy') & ' ' & TimeFormat(LIbloqueo,'hh:mm:ss')>
					<cfelse>
						<cfset LIbloqueo = Now()>
						<cfset razon = razon & ', contraseña desactivada y se requiere reactivación (recordar contraseña)'>
						<cfset this.AUTHLOOP_BLOQUEA_PASSWORD (arguments.Usucodigo)>
					</cfif>
					<cfquery datasource="aspmonitor" name="existe">
						select bloqueo
						from UsuarioBloqueo
						where bloqueo   > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
						  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
						  and desbloqueado = 0
					</cfquery>
					<cfif Len(existe.bloqueo)>
						<cfquery datasource="aspmonitor">
							update UsuarioBloqueo
							set bloqueo = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LIbloqueo#">,
								razon   = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#razon#">
							where bloqueo   = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#existe.bloqueo#">
							  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.Usucodigo#">
							  and CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.CEcodigo#">
							  and desbloqueado = 0
						</cfquery>
					<cfelse>
						<cfquery datasource="aspmonitor">
							insert into UsuarioBloqueo (Usucodigo, bloqueo, CEcodigo, fecha, razon, desbloqueado)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LIbloqueo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#razon#">, 0)
						</cfquery>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
		<cfquery datasource="aspmonitor">
			insert into LoginIncorrecto (LIcuando, LIip, CEcodigo, Usucodigo, LIalias, LIlogin, LIrazon, LIcontador, LIbloqueo)
			values (
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#session.sitio.ip#" len="15">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.CEcodigo#"  null="#Len(Trim(Arguments.CEcodigo))  EQ 0#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Usucodigo#" null="#Len(Trim(Arguments.Usucodigo)) EQ 0#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value=" ">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.uid#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.razon#" len="255">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#LIcontador#" len="40">,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Libloqueo#" null="#Len(Trim(Libloqueo)) EQ 0#">)
		</cfquery>
	</cffunction>

	<!------------------------------------>
	<!--- iteradores sobre los backend --->
	<!------------------------------------>

	<cffunction name="AUTHLOOP_CAMBIA_PASSWORD" access="package" output="false" returntype="string"
			displayname="Itera sobre los backend validos, regresa el que funcionó">
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="nuevo_password" type="string"  required="true">
        <cfargument name="Conexion" type="string"  required="no" default="asp">
		<cfargument name="backend_list" type="string" default="#This.PoliticaAuthOrden#">
		  
		<cfloop list="#Arguments.backend_list#" index="backend">
			<cfinvoke component="Seguridad#UCase(backend)#" method="_CAMBIA_PASSWORD_BACKEND"
				Usucodigo="#Arguments.Usucodigo#"
				nuevo_password="#Arguments.nuevo_password#"
                Conexion ="#Arguments.Conexion#"
				returnvariable="retval"/>
			<cfif retval>
				<cfreturn backend>
			</cfif>
		</cfloop>
		<cfreturn ''>
		
	</cffunction>

	<cffunction name="AUTHLOOP_AUTENTICAR" access="package" output="false" returntype="string" displayname="Itera sobre los backend validos, regresa el que funcionó">
		<cfargument name="Usucodigo" 	type="numeric" 	required="true">
		<cfargument name="password"  	type="string"  	required="true">
		<cfargument name="backend_list" type="string" 	default="#This.PoliticaAuthOrden#">
		
		<cfloop list="#Arguments.backend_list#" index="backend">
			<cfinvoke component="Seguridad#UCase(backend)#" method="_AUTENTICAR_BACKEND"
				Usucodigo="#Arguments.Usucodigo#"
				passwordtext="#Arguments.password#"
				returnvariable="retval"/>
			<cfif retval>
				<cfreturn backend>
			</cfif>
		</cfloop>
		<cfreturn ''>

	</cffunction>

	<cffunction name="AUTHLOOP_BLOQUEA_PASSWORD" access="package" output="false" returntype="string"
			displayname="Itera sobre los backend validos, regresa el que funcionó">
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="backend_list" type="string" default="#This.PoliticaAuthOrden#">
		
		<cfloop list="#Arguments.backend_list#" index="backend">
			<cfinvoke component="Seguridad#UCase(backend)#" method="_BLOQUEA_PASSWORD_BACKEND"
				Usucodigo="#Arguments.Usucodigo#"
				returnvariable="retval"/>
			<cfif IsDefined('retval') And retval>
				<cfreturn backend>
			</cfif>
		</cfloop>
		<cfreturn ''>
		
	</cffunction>

	<!------------------------------------>
	<!--- implementar a partir de aquí --->
	<!------------------------------------>

	<cffunction name="_CAMBIA_PASSWORD_BACKEND" access="package" returntype="boolean" output="false" displayname="IMPLEMENTACIÓN DE LA SEGURIDAD"
		hint="IMPLEMENTACIÓN DE LA SEGURIDAD.<br>Asigna una contraseña a un usuario">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="nuevo_password" type="string"  required="true">
		<cfthrow message="No se debe invocar el componente 'Seguridad' directamente">
	</cffunction>

	<cffunction name="_AUTENTICAR_BACKEND" access="package" returntype="boolean" output="false" displayname="IMPLEMENTACIÓN DE LA SEGURIDAD"
		hint="IMPLEMENTACIÓN DE LA SEGURIDAD.<br>Valida la contraseña para un usuario">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="password"  type="string"  required="true">
		<cfthrow message="No se debe invocar el componente 'Seguridad' directamente">
	</cffunction>

	<cffunction name="_BLOQUEA_PASSWORD_BACKEND" access="package" output="false" displayname="IMPLEMENTACIÓN DE LA SEGURIDAD"
		hint="IMPLEMENTACIÓN DE LA SEGURIDAD.<br>Bloquea la contraseña de un usuario">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfthrow message="No se debe invocar el componente 'Seguridad' directamente">
	</cffunction>
</cfcomponent>

