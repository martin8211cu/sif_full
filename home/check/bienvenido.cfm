<cfif IsDefined("session.logoninfo.Utemporal") AND session.logoninfo.Utemporal EQ 1
	and Mid(CGI.SCRIPT_NAME, 1, 18) NEQ '/cfmx/home/signup/'
	and CGI.SCRIPT_NAME NEQ '/cfmx/home/public/logout.cfm'>
	<!---
		Es el primer login, proceder a la firma del usuario
		Se excluyen de la validación solamente las pantallas relevantes al signup
	--->

	<cfoutput>Redireccionando a signup...</cfoutput>

	<cflocation url="/cfmx/home/signup/signup.cfm">

<cfelseif not isdefined("session.bienvenido_check")
	and Mid(CGI.SCRIPT_NAME, 1, 18) NEQ '/cfmx/home/signup/'
	and CGI.SCRIPT_NAME NEQ '/cfmx/home/public/logout.cfm'
	and CGI.SCRIPT_NAME NEQ '/cfmx/home/menu/passch.cfm'
	and CGI.SCRIPT_NAME NEQ '/cfmx/home/menu/passch2.cfm'
	and CGI.SCRIPT_NAME NEQ '/cfmx/home/menu/passch-apply.cfm'
	and CGI.SCRIPT_NAME NEQ '/cfmx/home/menu/micuenta/index.cfm'
	and CGI.SCRIPT_NAME NEQ '/cfmx/home/menu/micuenta/usuario-apply5.cfm'
	and IsDefined('session.Usucodigo') and Len(session.Usucodigo)
	and session.Usucodigo gt 1
	and (isdefined("session.authbackend") and ucase(session.authbackend) EQ 'ASP')><!--- Solo aplica controlar la expiración del password si el backend es asp --->

	<!--- ver si la contraseña ya expiró --->
	<cfinvoke component="home.Componentes.Politicas" method="trae_parametro_usuario" returnvariable="expira_default">
		<cfinvokeargument name="parametro" value="pass.expira.default">
		<cfinvokeargument name="CEcodigo" value="#session.CEcodigo#">
		<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
	</cfinvoke>
    <!--- ver si la contraseña exije recordatorio --->
	<cfinvoke component="home.Componentes.Politicas" method="trae_parametro_usuario" returnvariable="expira_recordatorio">
		<cfinvokeargument name="parametro" value="pass.expira.recordatorio">
		<cfinvokeargument name="CEcodigo" value="#session.CEcodigo#">
		<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
	</cfinvoke>

	<cfquery datasource="asp" name="__bienvenido">
		select PasswordSet
		from UsuarioPassword
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>

	<cfif __bienvenido.RecordCount and Len(__bienvenido.PasswordSet)>
		<cfset PasswordAge = DateDiff("d", __bienvenido.PasswordSet, Now())>
		<!---
		<cfoutput>PasswordAge:#PasswordAge#,
			expira_default: #expira_default#,
			expira_recordatorio: #expira_recordatorio#
		 </cfoutput>--->



		 <cfif PasswordAge GE expira_default>
			<!--- OBLIGAR a que cambie contraseña
				  Por eso va antes del cfset session.bienvenido_check
			<cfoutput>Password expirado</cfoutput><cfabort>
		--->
            <cfoutput>Password expirado</cfoutput>
			<cflocation url="/cfmx/home/menu/passch.cfm?error=3">
		 </cfif>

		 <cfset session.bienvenido_check = 1>


		 <cfif expira_default - PasswordAge le expira_recordatorio>
			<!--- recordatorio de que el password va a expirar  --->
			<cfoutput>Su contraseña expira en #expira_default - PasswordAge# días</cfoutput>
			<cflocation url="/cfmx/home/menu/passch.cfm?error=4&days=#expira_default - PasswordAge#">
		 </cfif>
	</cfif>

	<!--- ver si tiene pregunta personal --->
	<cfquery datasource="asp" name="__bienvenido">
		select Usurespuesta
		from Usuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	<cfif __bienvenido.RecordCount is 1 and Len(Trim(__bienvenido.Usurespuesta)) is 0>
		<cflocation url="/cfmx/home/menu/pregunta.cfm">
	</cfif>
	<cfset __bienvenido = ''>
</cfif>