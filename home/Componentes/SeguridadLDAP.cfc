<!---
	Ver documentación para Seguridad.cfc
--->
<cfcomponent extends="Seguridad">

	<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>

		<!---
			posibles usuarios administradores en un servidor iPlanet:
					uid=admin, ou=Administrators, ou=TopologyManagement, o=NetscapeRoot
					cn=Directory Manager
			cada uno tiene su propia contraseña, que se define al instalar el producto.
		--->

	<cfset This.ldapServer = Politicas.trae_parametro_global("ldap.server")>
	<cfset This.ldapDominio = Politicas.trae_parametro_global("ldap.dominio")>
	<cfset This.ldapPort = Politicas.trae_parametro_global("ldap.port")>
	<cfset This.ldapBaseDN = Politicas.trae_parametro_global("ldap.baseDN")>
	<cfset This.ldapAdminUserDN = Politicas.trae_parametro_global("ldap.adminDN")>
	<!--- Bernal 30/06/15 Desencripta el password para LDAP con base 64 pues en la base de datos se guarda 
	encriptado pero a la hora de pasarlo por el  cfldap daba problemas--->
	<cfset This.ldapAdminPassword = ToString( ToBinary(Politicas.trae_parametro_global("ldap.adminPass")))>
	
	<cffunction name="_CAMBIA_PASSWORD_BACKEND" access="package" returntype="boolean" output="false">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="nuevo_password" type="string"  required="true">
				
		<cfquery datasource="asp" name="password_query">
			select Usulogin, CEcodigo
			from Usuario
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>

		<cfif password_query.RecordCount NEQ 1>
			<cflog file="seguridad" text="Cambiar Password fallido para #Arguments.Usucodigo#. Usucodigo no encontrado">
			<cfreturn false>
		</cfif>
		
		<cfset bindquery=false>
		<cflog file="seguridad" text="ldap.passwd: Usulogin=#password_query.Usulogin#">

		<cfset dominio = '' >
        <cfif len(trim(This.ldapDominio)) gt 0 >	<!--- Windows Active Directory --->
			<cfset dominio = '@#trim(This.ldapDominio)#' >
        </cfif>
        <cfset uid = trim(password_query.Usulogin) & dominio >
        
		<cfset target_user = __find_user(uid)>

       
		<cfif target_user.RecordCount>
			<cftry>
				<cfldap 
					 server="#This.ldapServer#"
					 action="modify"
					 attributes="userpassword=#Arguments.nuevo_password#"
					 dn="#target_user.dn#"
					 username="#This.ldapAdminUserDN#"
					 password="#This.ldapAdminPassword#">

				<cfreturn true>

				<cfcatch type="any">
					<cflog file="seguridad" text="ldap.passwd: caught #cfcatch.Message# #cfcatch.Detail#">
				</cfcatch>
			</cftry>
		</cfif>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="_AUTENTICAR_BACKEND" access="package" returntype="boolean" output="false">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="passwordtext"  type="string"  required="true">

		<cfquery datasource="asp" name="password_query">
			select Usulogin, CEcodigo
			from Usuario
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
		<cfif password_query.RecordCount NEQ 1>
			<cflog file="seguridad" text="Autenticar fallido para #Arguments.Usucodigo#. Usucodigo no encontrado">
			<cfreturn false>
		</cfif>
		
		<cfset bindquery = false>
		<cflog file="seguridad" text="ldap.auth: Usulogin=#password_query.Usulogin#">
		<cfset finduser = true >	 

		<cfset ldapFilter = 'uid=#password_query.Usulogin#' >	<!--- Iplanet --->
		<cfif len(trim(This.ldapDominio)) gt 0 >	<!--- Windows Active Directory --->
			<cfset ldapFilter = 'userPrincipalName=#trim(password_query.Usulogin)#@#trim(this.ldapDominio)#' >
		</cfif>

		<cftry>
			<cfset dominio = '' >
			<cfif len(trim(This.ldapDominio)) gt 0 >	<!--- Windows Active Directory --->
				<cfset dominio = '@#trim(This.ldapDominio)#' >
			</cfif>
			<cfset uid = trim(password_query.Usulogin) & dominio >
			
			<cfset finduser = __find_user(uid)>
			
			<cfcatch type="any">
				<cflog file="seguridad" text="ldap.auth: caught #cfcatch.Message# #cfcatch.Detail#">
			</cfcatch>
		</cftry>					
        	
		<cfif isdefined("finduser.RecordCount") And finduser.RecordCount>
			<cftry>
				<cfldap 
					 server="#This.ldapServer#"
					 action="query"
					 name="bindquery"
					 start="#This.ldapBaseDN#"
					 filter="#ldapfilter#"
					 attributes="dn,uid,cn,givenName,sn,mail,telephonenumber,fax"
					 username="#finduser.dn#"
					 password="#arguments.passwordtext#">
		
				<cflog file="seguridad" text="ldap.auth: bindquery.dn=#bindquery.dn#">
				<cfcatch type="any">
					<cflog file="seguridad" text="ldap.auth: caught: #cfcatch.Message# #cfcatch.Detail#">
				</cfcatch>
			</cftry>
		</cfif>
		<cfif IsDefined('bindquery') And IsQuery(bindquery) And bindquery.RecordCount EQ 1>
			<cflog file="seguridad" text="ldap.auth: return true">
			<cfreturn true>
		<cfelse>
			<cflog file="seguridad" text="ldap.auth: return false">
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="_BLOQUEA_PASSWORD_BACKEND" access="package" output="false">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
		
		<cfset ret = This._CAMBIA_PASSWORD_BACKEND(Arguments.Usucodigo,  This.__randomString(255))>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="__find_user" returntype="query">
		<cfargument name="uid" type="string">
		
			<cfif len(trim(This.ldapDominio)) gt 0>	<!--- Windows Active Directory --->
				<cfldap	server="#This.ldapServer#"
						action="query"
						name="finduserQuery"
						start="#This.ldapBaseDN#" 
						filter="userPrincipalName=#trim(arguments.uid)#"
						attributes="dn"
						username="#This.ldapAdminUserDN#"		<!--- usuario administrador debe venir antecedido del dominio ej: dominio\usuario (por ser capturado en pantalla) --->
						password="#This.ldapAdminPassword#" >
	
			<cfelse>	<!--- Iplanet --->
				<cfldap	server="#This.ldapServer#"
						action="query"
						name="finduserQuery"
						start="#This.ldapBaseDN#"
						filter="uid=#arguments.uid#"
						attributes="dn">
			</cfif>
			 
		<cflog file="ldap" text="finduser(#arguments.uid#)=#finduserQuery.dn#">
		<cfreturn finduserQuery>
	</cffunction>

</cfcomponent>
