<cfcomponent extends="taffy.core.resource" taffy_uri="/login">

	<cffunction name="post" access="public" output="false">
		<cfargument name="username" type="string">
		<cfargument name="password"  type="string">
		<cfargument name="company"  type="string">

		<cfscript>
			result=StructNew();
		</cfscript>

		<cfset status = 200>

		<cftry>
			
			<cfset seguridad = createObject("component", "home.Componentes.SeguridadAPI")>
	
			<cfset rsUsu = getUserData(arguments.username, arguments.company)>
			<cfif rsUsu.recordCount eq 0>
				<cfthrow type="UserNotFound" message="Credenciales incorecctas">
			</cfif>
			
			<cfset resultLogin = seguridad.autenticar( Usucodigo = rsUsu.codigo, passwordtext = arguments.password) />
			
			<cfif not resultLogin>
				<cfthrow type="UserNotFound" message="Credenciales incorecctas">				
			<cfelse>

				<cfset rsToken = getTokenInfo( arguments.username )>
				<cfif rsToken.recordCount eq 0>
					<cfquery datasource="aspmonitor">
						insert into MonProcesos (Usucodigo,login,desde,acceso,cerrada,CEcodigo)
						values(#rsUsu.codigo#, '#rsUsu.usuario#', getdate(), getdate(),0,#rsUsu.empresa#)
					</cfquery>
					<cfset rsToken = getTokenInfo( arguments.username )>
				</cfif>
				
				<cfset rsEmpresas = getEmpresas( usucodigo = rsUsu.codigo, cecodigo = rsToken.empresa)>

				<cfset arrEmpresas = queryToArray( rsEmpresas )>
				<cfset loginData["profile"] = queryToStruct(rsUsu)>
				<cfset loginData["token"] = rsToken.token>

				<cfset result["token"] =  rsToken.token> 
				<cfset result["companies"] =  arrEmpresas> 
				<cfset result["usuario"] =  loginData["profile"]> 
			</cfif>
			
		<cfcatch type="UserNotFound">
			<cfset status = 401>
			<cfset result["message"] = "Credenciales incorecctas">
			<cfset result["errorcode"] = 1>
		</cfcatch>
		<cfcatch type="Expression">
			<cfset status = 400>
			<cfset result["message"] = "Peticion mal formada #cfcatch.message#">
			<cfset result["errorcode"] = 2>
		</cfcatch>
		<cfcatch type="any">
			<cfset status = 401>
			<cfset result["message"] = "#cfcatch.message#">
			<cfset result["errorcode"] = 99>
		</cfcatch>
		<cffinally>
			<cfreturn representationOf(result).withStatus(status) />
		</cffinally>
		</cftry>

	</cffunction>

	<cffunction  name="getTokenInfo" access="private">
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

	<cffunction  name="getEmpresas"  access="private">
		<cfargument name="usucodigo" type="numeric" required="true">
		<cfargument name="cecodigo" type="numeric" required="true">

		<cfquery name="rsEmpresas" datasource="asp">
			select
				e.Enombre, e.Ereferencia as Ecodigo<!---, ((select min(c.Ccache) from Caches c where c.Cid = e.Cid )) as Ccache --->
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

	<cffunction  name="getUserData" access="private">
		<cfargument name="username" type="string" required="true">
		<cfargument name="emp" type="string" required="false" default="">

		<cfset fullUrlPath = 'http://'><cfif findnocase('HTTPS',ucase(cgi.SERVER_PROTOCOL))><cfset fullUrlPath = 'https://'></cfif>
		<cfset fullUrlPath&=cgi.HTTP_HOST & cgi.CONTEXT_PATH>
		<cfquery name = "rsUsu" datasource = "asp">
			select 
				u.Usucodigo codigo, u.Usulogin usuario, u.CEcodigo empresa, 
				d.Pnombre nombre, d.Papellido1 apellido1, d.Papellido2 apellido2,
				d.Pemail1 email, d.Psexo sexo, '' as img
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

	<cffunction  name="keepAlive"  access="private">
		<cfargument name="token" type="string" required="true">

		<cfquery datasource="aspmonitor">
			update MonProcesos set acceso = getdate()
			where CONVERT(VARCHAR(32),HashBytes('MD5', convert(varchar(32),sessionid)),2) = '#arguments.token#'
		</cfquery>
	</cffunction>

	
</cfcomponent>
