<!--- ***************************************************************************************** --->
<!--- Primera Parte estos aplica para todas las pantallas sin importar si esta en session o no  --->
<!--- ***************************************************************************************** --->


<cfsetting enablecfoutputonly="yes">
	<cfapplication name="EXT" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>	
	
<cfset session.datasource 	 = "minisif">
<cfset session.dsn		 	 = "minisif">
<cfset session.Ecodigo       = 1>
<cfset Application.dsinfo.type = 'sybase'>
<cfset session.Usucodigo = 1>


<cfset httpRequestData = GetHTTPRequestData()>
<cfif IsDefined('httpRequestData')>
	<cfset req = httpRequestData.headers>
	<cfset Session.sitio.host = "">
	<cfif StructKeyExists(req,"X-Forwarded-Host")>
		<cfset Session.sitio.host = req["X-Forwarded-Host"]>
	</cfif>
	<cfif Len(Session.sitio.host) EQ 0>
		<cfset Session.sitio.host = req["Host"]>
	</cfif>
<cfelse>
		<cfset Session.sitio.host = CGI.HTTP_HOST>
</cfif>
 
<cfset res = setLocale("English (Canadian)")> 
<cfheader name = "Expires" value = "0"> 
<cfparam name="Session.Idioma" default="ES_CR"> 
<cfsetting enablecfoutputonly="no">	

<!--- ***************************************************************************************** --->
<!---                                      Procesos                                             --->
<!--- ***************************************************************************************** --->

<!--- 1 ) cuando viene una Autentificación --->
<cfif isdefined("url.authentication") and len(trim(url.authentication)) gt 0 and not isdefined("form.authentication")  >
	<cfset form.authentication  = url.authentication >
</cfif>
<cfif isdefined("form.authentication") and len(trim(form.authentication ))>
	<cfquery name="valida_datosOferente" datasource="#Session.datasource#">
		select  coalesce(RHAutentificar,0) as RHAutentificar  from DatosOferentes
		where RHPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.authentication#">
	</cfquery>
	<cfif valida_datosOferente.RHAutentificar eq 0>
		<cfquery name="rsupdate" datasource="#Session.datasource#">
				update DatosOferentes set RHAutentificar = 1
				where RHPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.authentication#">
				and RHAutentificar = 0
		</cfquery>
	</cfif>
	<style type="text/css">
		.Completoline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-width: 1px;
			border-right-style: solid;
			border-right-color: #000000;
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000000;
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000			
		}	
	</style>
	<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
		<tr bgcolor="##A0BAD3">
			<td  colspan="3" class="Completoline">&nbsp;</td>
		</tr>
		<tr>
			<td width="25%">&nbsp;</td>
			<cfif valida_datosOferente.RHAutentificar eq 0>
				<td width="50%" align="center">Autorizaci&oacute;n realizada exitosamente</td>
			<cfelse>
				<td width="50%" align="center">El usuario ya fue autorizado</td>
			</cfif>
			<td width="25%">&nbsp;</td>
		</tr >
		<tr bgcolor="##A0BAD3">
			<td  colspan="3" class="Completoline">&nbsp;</td>
		</tr>
	</table>
	</cfoutput>
	<cfabort>	
</cfif>
<!---  <cfdump var="#session.usuario#">
<cfdump var="#FORM#">	
--->

<!--- 2 ) Lo que puedo hacer si no tengo session :  --->
<cfif not IsDefined("session.usuario")  or (IsDefined("session.usuario") and len(trim(session.usuario)) eq  0 ) >
	<cfif IsDefined("Form.txtRegistrar") or  IsDefined("Form.txtOlvidar") or  IsDefined("Form.txtCambio")  or  IsDefined("Form.Guardar") or IsDefined("Form.Cambiar")or IsDefined("Form.Enviar")>
		<!--- Ingresa a la pantalla de captura de datos para registrarse , cambiar contraseña o recordar contraseña --->
		<cfinclude template="principal.cfm">
		<cfabort>
	<cfelseif IsDefined("Form.TXTLOGUEO")>
		<!--- Incia el proceso de validación de usuario --->
		<cflogin>
			<cfquery name="rs_cedula" datasource="#Session.datasource#">
				select  ltrim(rtrim(RHOidentificacion)) as RHOidentificacion  from DatosOferentes
				where ltrim(rtrim(RHOemail)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.txtUsername)#">
			</cfquery>
			<cfif rs_cedula.recordCount eq 0>
				<cfset session.Estado = "5">
				<cflocation  url="index.cfm"  addtoken="no">
				<cfabort>
			</cfif>		
			<cfset This.HashMethod = "MD5">
			<cfset new_salt = "MCSOIN">
			<cfset HashCFC = createObject("component","Hash") />
			<cfset new_hash = HashCFC.hashPassword("#This.HashMethod#","#form.txtPassword#","#rs_cedula.RHOidentificacion#","-1","#new_salt#")>
			<cfquery name="valida_datosOferente" datasource="#Session.datasource#">
				select  RHOid,Ecodigo,coalesce(RHAutentificar,0) as RHAutentificar  from DatosOferentes
				where RHPassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hash#">
				and ltrim(rtrim(RHOemail)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.txtUsername)#">
			</cfquery>	
			<cfif valida_datosOferente.recordCount GT 0>
				<cfif valida_datosOferente.RHAutentificar eq 0>
					<cfset session.Estado = "5">
					<cflocation  url="index.cfm"  addtoken="no">
					<cfabort>
				<cfelse>
					<cfloginuser name="#Form.txtUsername#" Password = "#new_hash#"
						roles="0">
					<cfset session.RHOid     = valida_datosOferente.RHOid>
				</cfif>
			<cfelse>
				<cflogout>
				<cfset session.Estado = "3">
				<cflocation  url="index.cfm"  addtoken="no">
			</cfif>
		</cflogin>
		
		<cfif GetAuthUser() NEQ "" >
			<cfset session.usuario 	= GetAuthUser()>
			<cfquery name="valida_datosOferente" datasource="#Session.datasource#">
				select  RHOid,Ecodigo from DatosOferentes
				where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.RHOid#">
			</cfquery>
			<cfquery name="RS_CECODIGO" datasource="#Session.datasource#">
				select cliente_empresarial from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfset form.RHOid        = valida_datosOferente.RHOid>
			<cfset session.CEcodigo = RS_CECODIGO.cliente_empresarial>
			<cfset session.Estado = "0">
		</cfif>		
	<cfelseif IsDefined("Form.logout") >
		<cfset form.RHOid        = "">
		<cfset session.CEcodigo = "">
		<cfset session.Estado = "">
		<cfset session.usuario 	= "">
		<cflogout>
		<cflocation  url="index.cfm"  addtoken="no">
	<cfelse>
		<!--- Ingresa a la pantalla de logueo ---> 
		<cfinclude template="loginform.cfm">
		<cfabort>	
	</cfif>
</cfif>
















