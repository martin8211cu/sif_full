<cfparam name="session.Usucodigo"     type="numeric" default="0">
<cfparam name="session.Ulocalizacion" type="string" default="">
<cfparam name="session.Usuario"       type="string" default="0">
<cfif Not Isdefined("session.monitoreo")>
	<cfset session.monitoreo = StructNew()>
	<cfset session.monitoreo.SScodigo = ''>
	<cfset session.monitoreo.SMcodigo = ''>
	<cfset session.monitoreo.SPcodigo = ''>
	<cfset session.monitoreo.Modulo   = ''>
	<cfset session.monitoreo.sessionid = 0>
</cfif>

<!---<cfif #cgi.REMOTE_ADDR# EQ "10.7.7.3">
<cfoutput>Referer:</cfoutput><cfdump var="#cgi.HTTP_REFERER#">
--->
	
<cfinclude template="acceso_uri.cfm">

<cfif IsDefined("url.seleccionar_EcodigoSDC") and 
	  Len(url.seleccionar_EcodigoSDC) NEQ 0 and 
	  REFind('^[0-9]+$', url.seleccionar_EcodigoSDC) NEQ 0>
	<cfset CreateObject("Component","functions").seleccionar_empresa(url.seleccionar_EcodigoSDC)>
<cfelseif IsDefined("form.seleccionar_EcodigoSDC") and 
	  Len(form.seleccionar_EcodigoSDC) NEQ 0 and 
	  REFind('^[0-9]+$', form.seleccionar_EcodigoSDC) NEQ 0>
	<cfset CreateObject("Component","functions").seleccionar_empresa(form.seleccionar_EcodigoSDC)>
</cfif>

<!--- variables --->
<cfset proceso = Trim(Replace(cgi.SCRIPT_NAME,'/cfmx','','one')) >

<!--- la pantalla de login siempre es publica, incluso si no hay datos. idem init-pso y dump.cfm --->
<cfif proceso IS '/home/public/login.cfm'><cfreturn></cfif>
<cfif proceso IS '/home/public/init-pso.cfm'><cfreturn></cfif>
<cfif proceso IS '/home/public/dump.cfm'><cfreturn></cfif>

<cfif not acceso_uri(proceso, true)>
	<cfquery datasource="aspmonitor" debug="no">
		insert into AccesoDenegado
			(uri, tipo_uri, fecha,
			Usucodigo, Ulocalizacion, login, roles, referer)
		values (
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#proceso#" 	len="255">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="C" 			len="1">, 
			<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#session.Usucodigo#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#session.Ulocalizacion#" len="2">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#session.usuario#" 		len="30">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#CGI.HTTP_REFERER#" 		len="255">
			)
	</cfquery>
	<cfif isdefined("session.login_no_interactivo") and session.login_no_interactivo>
		<cfset session.Usucodigo = 0>
		<cfreturn>
	</cfif>
	<cfif (not IsDefined("session.Usucodigo")) or (session.Usucodigo EQ 0)>
		<cfinvoke component="functions" method="login_redirect">
			<cfinvokeargument name="savecontext" value="yes">
		</cfinvoke>
		<!--- 
		<cflocation url="/cfmx/home/public/login.cfm?uri=#JSStringFormat(CGI.SCRIPT_NAME)#"> --->
		<cfabort>
	<cfelse>
		<cfinclude template="/home/check/no-access-404.cfm">
		<cfabort>
	</cfif>
</cfif>