<cfcomponent extends="Seguridad" output="false">

	<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
	
	<cffunction name="_CAMBIA_PASSWORD_BACKEND" access="package" returntype="boolean" output="false">
		<cfthrow message="Cambio de Password no implementado, por favor realice la accion desde la plataforma de google">
		<cfreturn false>
	</cffunction>
	
	<cffunction name="_AUTENTICAR_BACKEND" access="package" returntype="boolean" output="false">
		<cfargument name="Usucodigo" 	 type="numeric" required="true">
		<cfargument name="passwordtext"  type="string"  required="true">

		<cfif StructIsEmpty(getOauthData())>
			<cflog file="seguridad" text="No se han parametrizado las credenciales Google, verifica politicas del portal">
			<cfreturn false>
		</cfif>
		
		<cfquery datasource="asp" name="password_query">
			select a.Usulogin, a.CEcodigo, Coalesce(b.Pemail1,b.Pemail2,a.Usulogin) Email
			from Usuario a
				inner join DatosPersonales b
					on a.datos_personales = b.datos_personales
			where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
		<cfif password_query.RecordCount NEQ 1>
			<cflog file="seguridad" text="Autenticar fallido para #Arguments.Usucodigo#. Usucodigo no encontrado">
			<cfreturn false>
		</cfif>

		<cfset result = validateResult(password_query.Email,arguments.passwordtext)>
		 
		<cfif result.status>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>		
	</cffunction>

	<cffunction name="_BLOQUEA_PASSWORD_BACKEND" access="package" output="false">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
			<cfthrow message="Bloqueo de Usuario no implementado, por favor realiza la accion sobre la plataforma de google">
		<cfreturn false>
	</cffunction>



	<!--------- se agregan las funciones para el logeo mediante Oauth 2.0---------->

	<!---- genera el url del proceso de logeo de google---->
	<cffunction name="generateAuthURL" returntype="String" output="false">
		<cfargument type="string" name="state">

		<cfset data= getOauthData()>
		
		<cfreturn "https://accounts.google.com/o/oauth2/auth?" & 
				 "client_id=#data.clientid#" & 
     			 "&redirect_uri=#data.callback#" &
				 "&scope=https://www.googleapis.com/auth/userinfo.email&response_type=code" & 
				 "&state=#arguments.state#"> 
	</cffunction>

	<!---- obtiene informacion del perfil----->
	<cffunction name="getProfile" output="false">
		<cfargument type="string" name="accesstoken">
		<cfset var h = new com.adobe.coldfusion.http()>
		<cfset h.setURL("https://www.googleapis.com/oauth2/v1/userinfo")>
		<cfset h.setMethod("get")>
		<cfset h.addParam(type="header",name="Authorization",value="OAuth #accesstoken#")>
		<cfset h.addParam(type="header",name="GData-Version",value="3")>
		<cfset h.setResolveURL(true)>
		<cfset var result = h.send().getPrefix()>
		<cfreturn deserializeJSON(result.filecontent.toString())>
	</cffunction>

	<!---- funcion de validacion del logeo---->
	<cffunction name="validateResult" output="false">
		<cfargument name="Usucodigo" type="string">
		<cfargument name="code" type="string">

	
		<cfset var token = getGoogleToken(code)>

		<cfif structKeyExists(token, "error")>
			<cfset result.status = false>
			<cfset result.message = token.error>
			<cfreturn result>
		</cfif>

		<cfif structKeyExists(token, "error")>
			<cfset result.status = false>
			<cfset result.message = token.error>
			<cfreturn result>
		</cfif>

		<cfif ucase(trim(token.email)) neq ucase(trim(arguments.Usucodigo))>
			<cfset result.status = false>
			<cfset result.message = 'El correo no es válido'>
			<cfreturn result>
		</cfif>
		
		<cfset result.status = true>
		<cfset result.token = token> 

		<cfreturn result>

	</cffunction>
	 
	<cffunction access="private" name="getGoogleToken" output="false">
		<cfargument name="code" type="string">

 		<cfset data= getOauthData()>

		<cfset var postBody = "access_token=" & UrlEncodedFormat(arguments.code)> 
			<cfset var h = new com.adobe.coldfusion.http()>
			<cfset h.setURL("https://www.googleapis.com/oauth2/v1/tokeninfo")>
			<cfset h.setMethod("post")>
			<cfset h.addParam(type="header",name="Content-Type",value="application/x-www-form-urlencoded")>
			<cfset h.addParam(type="body",value="#postBody#")>
			<cfset h.setResolveURL(true)>
			<cfset var result = h.send().getPrefix()>
			<cfreturn deserializeJSON(result.filecontent.toString())>
	</cffunction>

	<cffunction name="getOauthData" returntype="Struct" output="false">
		<cfset data= structNew()>
			<cfif isdefined("Application.Politicas_PGlobal.auth.google.clienteid") and len(trim(Application.Politicas_PGlobal.auth.google.clienteid))>
				<cfset data.clientid=Application.Politicas_PGlobal.auth.google.clienteid>
		        <cfset data.clientsecret=Application.Politicas_PGlobal.auth.google.clienteid>
		        <cfset data.callback=Application.Politicas_PGlobal.auth.google.clienteid>
			</cfif>
		<cfreturn data>
	</cffunction>


	<cffunction name="validateCredentials" output="true">
		<cfargument name="auth_clienteid" type="string">
		<cfargument name="auth_clientsecret" type="string">
		<cfargument name="auth_callback" type="string">

		<!------- se validan las credenciales----->
		<cfset var postBody = "code=" & GetTickCount()>
		<cfset postBody &= "&client_id=" & auth_clienteid>
		<cfset postBody &= "&client_secret=" & auth_clientsecret>
		<cfset postBody &= "&redirect_uri="&auth_callback>
		<cfset postBody &= "&grant_type=authorization_code"> 
		<cfset var h = new com.adobe.coldfusion.http()>
		<cfset h.setURL("https://accounts.google.com/o/oauth2/token")>
		<cfset h.setMethod("post")>
		<cfset h.addParam(type="header",name="Content-Type",value="application/x-www-form-urlencoded")>
		<cfset h.addParam(type="body",value="#postBody#")>
		<cfset h.setResolveURL(true)>
		<cfset result = h.send().getPrefix()>
		<cfset result=deserializeJSON(result.filecontent.toString())>
		<cfif result.error neq 'invalid_grant'>
	 		<cfif isDefined("result.error_description")>
	 			<cfreturn result.error_description>
	 		<cfelse>
	 			<cfreturn result.error>	
	 		</cfif>
		</cfif>
		<!---- en el caso que las credenciales sean válida se agregan a la tabla de Plista para su uso posterior en las politicas del portal---->
		<cfquery datasource="asp">
			insert into PLista (parametro, pnombre, es_global, es_cuenta, es_usuario, predeterminado,BMfecha,BMUsucodigo)
			select 'auth.google.clienteid', 'clienteid para oauth2 de Google',1,1,1,'0', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> ,1
			 from dual where (select count(1)
							   from PLista
							  where parametro = 'auth.google.clienteid') = 0
		</cfquery>
		<cfquery datasource="asp">
			insert into PLista (parametro, pnombre, es_global, es_cuenta, es_usuario, predeterminado,BMfecha,BMUsucodigo)
			select 'auth.google.clientsecret', 'clientsecret para oauth2 de Google',1,1,1,'0', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> ,1
			 from dual where (select count(1)
							   from PLista
							  where parametro = 'auth.google.clientsecret') = 0
		</cfquery>
		<cfquery datasource="asp">
			insert into PLista (parametro, pnombre, es_global, es_cuenta, es_usuario, predeterminado,BMfecha,BMUsucodigo)
			select 'auth.google.callback', 'callback para oauth2 de Google',1,1,1,'0', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> ,1
			 from dual where (select count(1)
							   from PLista
							  where parametro = 'auth.google.callback') = 0
		</cfquery>
		<!----- fin del ingreso en la tabla de Plistas----->

		<cfreturn ''>
	</cffunction>


</cfcomponent>