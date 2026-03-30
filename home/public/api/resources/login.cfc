<cfcomponent extends="taffy.core.resource" taffy_uri="/authenticate">

	<cffunction name="post" access="public" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password"  type="string"  required="true">
		<cfargument name="enterprise"  type="string"  required="true">

		<cfscript>
			result=StructNew();
		</cfscript>

		<cfset status = 200>

		<cftry>
			
			<cfset seguridad = createObject("component", "home.Componentes.SeguridadAPI")>
	
			<cfset rsUsu = getUserData(arguments.username, arguments.enterprise)>
			<cfif rsUsu.recordCount eq 0>
				<cfthrow message="Inicio de session incorrecto.">
			</cfif>
			
			<cfset resultLogin = seguridad.autenticar( Usucodigo = rsUsu.codigo, passwordtext = arguments.password) />
			<cfset result["result"] = resultLogin>
	
			<cfif not resultLogin>
				<cfset result["message"] = "Inicio de session incorrecto.">
				<cfset status = 401>
			<cfelse>
				
				<cfset rsToken = getTokenInfo( arguments.username )>
				<cfset rsEmpresas = getEmpresas( usucodigo = rsUsu.codigo, cecodigo = rsToken.empresa)>

				<cfset arrEmpresas = queryToArray( rsEmpresas )>
				<cfset loginData["profile"] = queryToStruct(rsUsu)>
				<cfset loginData["profile"]["enterprises"] = arrEmpresas>
				<cfset loginData["token"] = rsToken.token>

				<cfset result["data"] =  loginData> 
			</cfif>
		<cfcatch type="any">
			<!--- TODO --->
			<cfset status = 400>
			<cfset result["result"] = false>
			<cfset result["message"] = cfcatch.message>
		</cfcatch>
		<cffinally>
			<cfreturn representationOf(result).withStatus(status) />
		</cffinally>
		</cftry>

	</cffunction>

	<cffunction  name="getTokenInfo">
		<cfargument name="username" type="string" required="true">

		<cfquery name="rsToken" datasource="aspmonitor">
			select CONVERT(VARCHAR(32),HashBytes('MD5', convert(varchar(32),max(sessionid))),2) token, 
					login as usuario, Usucodigo, CEcodigo as empresa
			from MonProcesos mp
			where cerrada = 0
				and login = '#arguments.username#'
			group by login, CEcodigo, Usucodigo
		</cfquery>

		<cfreturn rsToken>
	</cffunction>

	<cffunction  name="getEmpresas">
		<cfargument name="usucodigo" type="numeric" required="true">
		<cfargument name="cecodigo" type="numeric" required="true">

		<cfquery name="rsEmpresas" datasource="asp">
			select
				e.Enombre, e.Ereferencia as Ecodigo, ((select min(c.Ccache) from Caches c where c.Cid = e.Cid )) as Ccache
			from Empresa e
			where e.Ecodigo in (
					select distinct Ecodigo
					from vUsuarioProcesos up
					where up.Usucodigo = #arguments.usucodigo#
			)
			and e.CEcodigo = #arguments.cecodigo#
			order by Enombre
		</cfquery>

		<cfreturn rsEmpresas>
	</cffunction>

	<cffunction name="get" access="public" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="token"  type="string"  required="true">

		<cfset status = 200>
		<cfscript>
			result=StructNew();
		</cfscript>
		<cftry>
			
			<cfset rsToken = getTokenInfo( arguments.username )>
			
			<cfset result["result"] = rsToken.recordCount gt 0>
		
			<cfif not result["result"]>
				<cfset result["message"] = "Token invalido">
				<cfset status = 403>
			<cfelse>
				<cfset rsUsu = getUserData(arguments.username)>

				<cfset rsEmpresas = getEmpresas( usucodigo = rsUsu.codigo, cecodigo = rsToken.empresa)>
				<cfset arrEmpresas = queryToArray( rsEmpresas )>
				<cfset loginData["profile"] = queryToStruct(rsUsu)>
				<cfset loginData["profile"]["enterprises"] = arrEmpresas>
				<cfset loginData["token"] = rsToken.token>
				<cfset result["data"] =  loginData>
			</cfif>
		<cfcatch type="any">
			<!--- TODO --->
			<cfset status = 500>
			<cfset result["message"] = cfcatch.stacktrace>
		</cfcatch>
		<cffinally>
			<cfset keepAlive(arguments.token)>
			<cfreturn representationOf(result).withStatus(status) />
		</cffinally>
		</cftry>

	</cffunction>

	<cffunction  name="getUserData" access="private">
		<cfargument name="username" type="string" required="true">
		<cfargument name="emp" type="string" required="false" default="">

		<cfquery name = "rsUsu" datasource = "asp">
			select 
				u.Usucodigo codigo, u.Usulogin usuario, u.CEcodigo empresa,
				d.Pnombre nombre, d.Papellido1 apellido1, d.Papellido2 apellido2,
				d.Pemail1 email, d.Psexo sexo
			from Usuario u
			inner join DatosPersonales d
				on u.datos_personales = d.datos_personales
			where Usulogin = '#arguments.username#'
			<cfif len(trim(arguments.emp)) gt 0>
				and CEcodigo = (select CEcodigo from CuentaEmpresarial where CEaliaslogin = '#arguments.emp#')
			</cfif>
		</cfquery>

		<cfreturn rsUsu>

	</cffunction>

	<cffunction  name="keepAlive">
		<cfargument name="token" type="string" required="true">

		<cfquery datasource="aspmonitor">
			update MonProcesos set acceso = getdate()
			where CONVERT(VARCHAR(32),HashBytes('MD5', convert(varchar(32),sessionid)),2) = '#arguments.token#'
		</cfquery>
	</cffunction>

	
</cfcomponent>
