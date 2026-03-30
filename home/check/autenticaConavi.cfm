<!--- se definen aqui para que estén siempre disponibles --->
<cfparam name="Session.Usuario"       default="">
<cfparam name="Session.Usucodigo"     default=0>
<cfparam name="Session.CEcodigo"      default="0">
<cfparam name="Session.Ecodigo"       default="0">
<cfparam name="Session.EcodigoSDC"    default="0">
<cfparam name="Session.CEnombre"      default="">
<cfparam name="Session.Enombre"       default="">
<cfparam name="Session.idioma"        default="">
<cfparam name="Session.Ulocalizacion" default="00">
<cfif Len(session.CEcodigo) IS 0>
	<cfset session.CEcodigo = 0>
</cfif>
<cfif Len(session.Ecodigo) IS 0>
	<cfset session.Ecodigo = 0>
</cfif>

<!--- 
no hay transferencia de sessiones:
se quito de el if { IsDefined("url.sess_pk") and IsDefined("url.uid") or }
	
--->

<cfif IsDefined("form.j_username") AND IsDefined("form.j_password") And Len(form.j_username) NEQ 0 and Len(form.j_password) NEQ 0 or
	IsDefined("session.autoafiliado")>
		<cfset Session.Usuario = "">
		<cfset Session.Usucodigo = 0>
		<cfset Session.CEcodigo = "">
		<cfset StructDelete(Session, "logoninfo")>
		<cfset StructDelete(Session, "datos_personales")>
					
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

		<cfparam name="form.j_empresa" default="">
		
		<cfif IsDefined("url.uid") and IsDefined("url.sess_pk")>
			<cflogout>
			<cfset info_usuario = "">
			<cfthrow message="No hay transferencia de sesiones">
		<cfelseif IsDefined("session.autoafiliado") and session.autoafiliado NEQ 1>
			<cfset info_usuario = sec.infoUsuario("", "", session.autoafiliado)>
			<cfset StructDelete(session, "autoafiliado")>
		<cfelse>
			<!--- validar usuario solamente si no es autoafiliado --->
			<cfset form_Usucodigo = sec.buscarUsuarioGlobal(form.j_empresa, form.j_username)>
			<cfset AUTHBACKEND = sec.autenticarUsucodigo(form_Usucodigo, form.j_password)>
			<cfif Len(AUTHBACKEND) EQ 0>
				<cflogout>
				<cfif isdefined("session.login_no_interactivo") and session.login_no_interactivo>
					<cfreturn>
				</cfif>
				<cfinvoke component="functions" method="login_redirect">
					<cfinvokeargument name="errormsg" value="1">
				</cfinvoke>
				<!---
				<cflocation url="/cfmx/home/public/login.cfm?nf=yes&errormsg=1&uri=#JSStringFormat(CGI.SCRIPT_NAME)#">
				--->
			</cfif>
			<cfset info_usuario = sec.infoUsuario("", "", form_Usucodigo)>
		</cfif>

		<cfinvoke component="home.Componentes.aspmonitor" method="ValidarSiSePuedeIniciarSesion">
			<cfinvokeargument name="Usucodigo" value="#info_usuario.Usucodigo#">
		</cfinvoke>
		
		<cfquery name="rsUsuario" datasource="asp">
			select 
				a.Usucodigo, 
				a.Usulogin,
				a.datos_personales,
				a.Utemporal,
				a.CEcodigo,
				b.CEnombre, a.LOCIdioma, a.Usurespuesta,
				p.skin, p.enterActionDefault
			from Usuario a
				join CuentaEmpresarial b
				  on a.CEcodigo = b.CEcodigo
				left join Preferencias p
				  on p.Usucodigo = a.Usucodigo
			where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#info_usuario.Usucodigo#">
		</cfquery>
		
		<cfif len(rsUsuario.Usucodigo) GT 0>
			<cfset session.logoninfo = StructNew()>
			<cfset session.logoninfo.Utemporal = rsUsuario.Utemporal>
			<cfif IsDefined('AUTHBACKEND')>
				<cfset Session.AUTHBACKEND = AUTHBACKEND>
			</cfif>
			<cfset Session.Usuario=rsUsuario.Usulogin>
			<cfset Session.Usulogin=rsUsuario.Usulogin>
			<cfset Session.Ulocalizacion="00"><!--- para compatibilidad con tramites --->
			<cfset Session.Usucodigo=rsUsuario.Usucodigo>
			<cfset Session.CEcodigo=rsUsuario.CEcodigo>
			<cfset Session.CEnombre=rsUsuario.CEnombre>
			<cfset Session.idioma = rsUsuario.LOCIdioma>
			
			<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
			<cfset Session.duracion_minutos = Politicas.trae_parametro_usuario('sesion.duracion.default')>
			<cfset Session.duracion_modo   = Politicas.trae_parametro_usuario('sesion.duracion.modo')>
			
			<!--- esta linea evita que si me estoy logueando en una sesión ya expirada dé error, ver aspmonitor.cfc --->
			<cfset Request.SesionNuevaFavorNoExpirar = true>
			
			<cf_datospersonales action="select" key="#rsUsuario.datos_personales#" name="datos_personales">
			<cfset Session.datos_personales = datos_personales>
			<cfloginuser name="#Session.Usuario#" roles="none" password="#rsUsuario.Usucodigo#">
			<cfif Len(rsUsuario.enterActionDefault)>
				<cfset session.sitio.enterActionDefault = rsUsuario.enterActionDefault>
			<cfelse>
				<cfset session.sitio.enterActionDefault = "submit">
			</cfif>
			<cfif Len(rsUsuario.skin)>
				<cfset UserCSS = GetDirectoryFromPath(session.sitio.css) & rsUsuario.skin>
				<cfif FileExists(ExpandPath(UserCSS))>
					<cfset session.sitio.css = UserCSS>
				</cfif>
			</cfif>
			<cfset CreateObject("Component","functions").seleccionar_empresa(0)>
		<cfelse>
			<cfif isdefined("session.login_no_interactivo") and session.login_no_interactivo>
				<cfreturn>
			</cfif>
			<!--- aqui solamente llegaríamos si por alguna razón el usuario pasó la 
				autenticación externa eg: LDAP, pero no tenemos registro de él en el portal (Usuario)
			--->
			<cfset sec.login_incorrecto(info_usuario.CEcodigo, "",
				info_usuario.Usulogin, "Usuario no existe")>
			<cflogout><cfoutput>USUARIO NO EXISTE</cfoutput><cfabort>
			<cfinvoke component="functions" method="login_redirect">
				<cfinvokeargument name="errormsg" value="1">
			</cfinvoke>
			<!---
			<cflocation url="/cfmx/home/public/login.cfm?nf=yes&errormsg=1&uri=#JSStringFormat(CGI.SCRIPT_NAME)#"> --->
		</cfif>
		
		<cfif isdefined("session.login_no_interactivo") and session.login_no_interactivo>
			<cfreturn>
		</cfif>
		<cf_ssl secure='login' url="/cfmx/home/public/login-enter.cfm">
</cfif>

<!--- dump check login
<cfoutput>
<table border="0" style="background-color:##CCCCCC;padding:4 4 4 4;border:1px solid black;margin-bottom:4" >
  <tr>
    <td colspan="2" style="background-color:##000000;color:##ffffff"><strong>check/check-login.cfm</strong> (session.sitio)</td>
    </tr>
  <tr>
    <td>CEcodigo</td>
    <td>#Session.CEcodigo#</td>
  </tr>
  <tr>
    <td>Usucodigo</td>
    <td>#Session.usucodigo#</td>
  </tr>
  <tr>
    <td>Usuario</td>
    <td>#Session.usuario#</td>
  </tr>
</table>
</cfoutput>
 --->