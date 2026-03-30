<cfsilent>
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout="#CreateTimeSpan(200,0,0,0)#">
<!---
	Validar
	true: Sí se debe solicitar y validar un usuario y contraseña
	false: Utilizar el indicado en los parámetros del SACI (Pcodigo 200)
--->
<cfparam name="Request.Validar" default="True">

<cfif Request.Validar is False>
	<cfset session.dsn = 'isb'>
	<cfset session.Ecodigo = 235>
	<!--- Averiguar el usuario para invocación de Web Services --->
	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="usuario200">
		<cfinvokeargument name="Pcodigo" value="200">
	</cfinvoke>
	<cfquery datasource="asp" name="buscar_usuario_param200">
		select Usucodigo, Usulogin
		from Usuario where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#usuario200#">
	</cfquery>
	<cfif buscar_usuario_param200.RecordCount is 0>
		<cfthrow message="No se ha definido el Usuario para Web Services (parámetro 200)">
	</cfif>
	<cfset Session.Usucodigo = buscar_usuario_param200.Usucodigo>
	<cfset Session.Usulogin = buscar_usuario_param200.Usulogin>
	<cfset Session.Usuario = buscar_usuario_param200.Usulogin>
<cfelse>
	<cftry>
		<cflogin>
			<cfset authenticated = false>
			<cfif IsDefined('cflogin')>
		
				<cfset user = cflogin.name>
				<cfset pass = cflogin.password>
				<cflog file="isb_ws" text="auth user: #user#, auth pass: #pass#">
				
				<cfset form.j_username = user>
				<cfset form.j_password = pass>
				<cfset form.j_empresa = 'racsa'>
				<cfset session.login_no_interactivo = true>
				<cfinclude template="/Application.cfm">
		
				<cflog file="isb_ws" text="Auth... Usucodigo = #session.Usucodigo#">
				
				<cfif session.Usucodigo>
					<cfset authenticated = true>
				</cfif>
						
				<cfif not authenticated>
					<cfcontent reset="yes" type="text/html">
			
					<cfif IsDefined('session.Usuario') and Len(session.Usuario)>
						<!--- se logueó, pero acceso_uri dio false y me reseteo el Usucodigo --->
						<cfheader statuscode="403" statustext="Forbidden URL">
						<cfset WriteOutput('403 - Forbidden URL'  )>
					<cfelse>
						<!--- no se logueó, pido el password de nuevo.  ojo, podría bloquearse el usuario --->
						<cflog file="isb_ws" text="Authorization: denied">
						<cfheader statuscode="401" statustext="Authorization denied">
						<cfheader name="WWW-Authenticate" value='Basic realm="ISB Web Services (retry)"'>
						<cfset WriteOutput('401 - Authorization failed')>
					</cfif>
					<cfabort>
				</cfif>
			<cfelse>
				<cflog file="isb_ws" text="Authorization: requested (not authenticated)">
				<cfheader statuscode="401" statustext="Authorization required">
				<cfheader name="WWW-Authenticate" value='Basic realm="ISB Web Services login"'>
				<cfabort>
			</cfif>
		</cflogin>
		<cfcatch type="any">
				<cflog file="isb_ws" text="Error: #cfcatch.Message# #cfcatch.Detail#">
				<cfheader statuscode="401" statustext="#replace(cfcatch.Message & ' ' & cfcatch.Detail, ' ', '_', 'all')#">
				<cfheader name="WWW-Authenticate" value='Error="#cfcatch.Message# #cfcatch.Detail#"'>
		</cfcatch>
	</cftry>
</cfif>
</cfsilent>