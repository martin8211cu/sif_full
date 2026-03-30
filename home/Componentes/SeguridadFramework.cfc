
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
		<cfset new_hash = this.__hashPassword(This.HashMethod, Arguments.nuevo_password,
			password_query.Usulogin, password_query.CEcodigo, new_salt)>

		<cfquery datasource="asp" name="findPassw">
			Select 1
			from UsuarioPassword
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
		<cfquery datasource="asp" name="password_query">
			<cfif isdefined('findPassw') and findPassw.recordCount GT 0>
				update UsuarioPassword
				set Hash = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hash#">,
					HashMethod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.HashMethod#">,
					PasswordSalt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_salt#">,
					PasswordSet = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#password_query.Usulogin#">,
					AllowedAccess = 1
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			<cfelse>
				insert INTO UsuarioPassword (Usucodigo, Usulogin, Hash, HashMethod, PasswordSalt, PasswordSet, AllowedAccess)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#password_query.Usulogin#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hash#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.HashMethod#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#new_salt#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 1)
			</cfif>
		</cfquery>		
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="_AUTENTICAR_BACKEND" access="package" returntype="boolean" output="false">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="password"  type="string"  required="true">

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
		<cfset hash1 = this.__hashPassword(password_query.HashMethod, Arguments.password,
			password_query.Usulogin, password_query.CEcodigo, password_query.PasswordSalt)>
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


	<!--- funciones auxiliares a la implementación --->
	
	<cffunction name="__hashPassword" access="package" returntype="string" output="false">
		<cfargument name="hashMethod"   type="string"  required="yes">
		<cfargument name="password"     type="string"  required="yes">
		<cfargument name="uid"          type="string"  required="yes">
		<cfargument name="CEcodigo"     type="numeric" required="yes">
		<cfargument name="passwordSalt" type="string"  required="yes">
		
		<cfif Arguments.CEcodigo GT 1>
			<!--- este if existe para que los passwords que migremos del framework viejo sirvan --->
			<cfset Arguments.uid = Arguments.uid & '##' & CEcodigo>
		</cfif>
		<cfset instr = Arguments.password & "$$" & Arguments.uid & "$$" & Arguments.passwordSalt>
		<cfreturn this.__hash( instr, Arguments.hashMethod )>
	</cffunction>
	
	<cffunction name="__hash" access="package" returntype="string" output="false">
		<cfargument name="data"       type="string" required="yes">
		<cfargument name="hashMethod" type="string" required="yes">

		<cfset md = CreateObject("java", "java.security.MessageDigest")>
		<cfset md = md.getInstance(Arguments.hashMethod)>
		<cfset md.update(Arguments.data.getBytes())>
		<cfreturn this.__decodeHexStr( md.digest() )>
	</cffunction>
	
	<cffunction name="__decodeHexStr" access="package" returntype="string" output="false">
		<cfargument name="byte_array" type="any" required="true">
		
		<cfset var Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f")>
		<cfset var miarreglo=#ListtoArray(ArraytoList(#arguments.byte_array#,","),",")#>
		<cfset var arreglo_ret=ArrayNew(1)>

		<cfif not isArray(arguments.byte_array)>
			<cfreturn "">
		</cfif>

		<cfloop index="i" from="1" to="#ArrayLen(miarreglo)#">
			<cfif miarreglo[i] LT 0>
				<cfset miarreglo[i]=miarreglo[i]+256>
			</cfif>
			<cfif miarreglo[i] LT 16>
				<cfset arreglo_ret[i] = "0" & #toString(Hex[(miarreglo[i] MOD 16)+1])#>
			<cfelse>
				<cfset arreglo_ret[i] = #trim(toString(Hex[(miarreglo[i] \ 16)+1]))# & #trim(toString(Hex[(miarreglo[i] MOD 16)+1]))#>
			</cfif>
		</cfloop>
		<cfreturn ArraytoList(arreglo_ret,"")>
	</cffunction>

</cfcomponent>

