<cfcomponent>
	<cffunction name="listaEmpresas" access="remote" returntype="query">
		<cfset fnVerificaSession(true)>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select *
			  from Empresas
		</cfquery>
		<cfreturn rsSQL>
	</cffunction>

	<cffunction name="prueba" access="remote" returntype="numeric">
		<cflog file="cfprueba_log" text="#now()#">
		<cfreturn 1234>
	</cffunction>

	<cffunction name="fnVerificaSession" access="private">
		<cfsetting enablecfoutputonly="yes">
			<cfapplication name="SIF_ASP" 
			sessionmanagement="Yes"
			clientmanagement="Yes"
			setclientcookies="Yes"
			sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
		<cfheader name = "Expires" value = "0">
		<cfparam name="Session.Idioma" default="ES_CR">

		<cfif NOT isdefined("Session.Usucodigo") OR Session.Usucodigo EQ 0>
			<cfthrow message="Usuario no está Autorizado">
		</cfif>
	</cffunction>
</cfcomponent>