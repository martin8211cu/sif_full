
<!---
	Ver documentación para Seguridad.cfc
--->
<cfcomponent extends="Seguridad">

	<cfset This.HashMethod = "MD5">

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
		<cfset new_salt = This.__randomString(128)>
		<cfinvoke component="Hash" method="hashPassword" returnvariable="new_hash"
			hashMethod="#This.HashMethod#"
			passwd="#Arguments.nuevo_password#"
			uid="#password_query.Usulogin#"
			CEcodigo="#password_query.CEcodigo#"
			passwdSalt="#new_salt#" />
			
		<cfquery datasource="asp" name="findPassw">
			Select 1
			from UsuarioPassword
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
		<cfquery datasource="asp" name="password_query">
			<cfif isdefined('findPassw') and findPassw.recordCount GT 0>
				update UsuarioPassword
				set Hash 		  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#new_hash#" len="128">,
					HashMethod	  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#This.HashMethod#" len="8">,
					PasswordSalt  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#new_salt#" len="128">,
					PasswordSet   = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
					Usulogin 	  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#password_query.Usulogin#" len="50">,
					AllowedAccess = 1
				where Usucodigo   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Usucodigo#">
			<cfelse>
				insert INTO UsuarioPassword (Usucodigo, Usulogin, Hash, HashMethod, PasswordSalt, PasswordSet, AllowedAccess)
				values (
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 value="#Arguments.Usucodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#password_query.Usulogin#" len="50">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#new_hash#"	len="128">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#This.HashMethod#" len="8">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 value="#new_salt#" len="128">,
					<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">, 1)
			</cfif>
		</cfquery>		
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="_AUTENTICAR_BACKEND" access="package" returntype="boolean" output="false">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="passwordtext"  type="string"  required="true">

		<cfquery datasource="asp" name="password_query">
			select
				a.Hash, a.HashMethod, a.PasswordSalt,
				b.Usulogin, b.CEcodigo, a.AllowedAccess
			from UsuarioPassword a, Usuario b
			where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			  and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
		<cfif password_query.RecordCount NEQ 1>
			<cflog file="seguridad" text="Autenticar fallido para #Arguments.Usucodigo#. Usucodigo no encontrado">
			<cfreturn false>
		</cfif>
		<cfif password_query.AllowedAccess NEQ 1>
			<cflog file="seguridad" text="Autenticar fallido para #Arguments.Usucodigo#. AllowedAccess = #password_query.AllowedAccess#">
			<cfreturn false>
		</cfif>
		
		<cfinvoke component="Hash" method="hashPassword" returnvariable="hash1"
			hashMethod="#password_query.HashMethod#"
			passwd="#Arguments.passwordtext#"
			uid="#password_query.Usulogin#"
			CEcodigo="#password_query.CEcodigo#"
			passwdSalt="#password_query.PasswordSalt#" />

		<cfif hash1 EQ password_query.Hash>
			<cfreturn true>
		<cfelse>
			<cflog file="seguridad" text="Autenticar fallido para #Arguments.Usucodigo# (#password_query.Usulogin#). #hash1# != #password_query.Hash#">
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="_BLOQUEA_PASSWORD_BACKEND" access="package" output="false">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
		
		<cfquery datasource="asp">
			update UsuarioPassword 
			set AllowedAccess = 0
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
	</cffunction>


</cfcomponent>

