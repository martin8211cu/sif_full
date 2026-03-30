<cfif FindNoCase("/login.cfm",CGI.SCRIPT_NAME) EQ 0><cflogin>
	<cfif IsDefined("form.j_username") AND IsDefined("form.j_password") or IsDefined("url.sess_pk") and IsDefined("url.uid")>
		<cftry> <!---  --->
			<cfscript>
				if (IsDefined("url.uid")) {
					ejb_uid = "guest";
					ejb_pass = "guest";
					sdc_uid = url.uid;
				} else {
					ejb_uid = form.j_username;
					ejb_pass = form.j_password;
					sdc_uid = form.j_username;
				}
				prop = CreateObject("java", "java.util.Properties" );
				initContext = CreateObject("java", "javax.naming.InitialContext" );
				prop.init();
				// prop.put(initContext.INITIAL_CONTEXT_FACTORY, "com.sybase.ejb.InitialContextFactory");
				// prop.put(initContext.PROVIDER_URL,            "iiop://10.7.7.162:9000");
				prop.put(initContext.SECURITY_PRINCIPAL,      ejb_uid);
				prop.put(initContext.SECURITY_CREDENTIALS,    ejb_pass);
				initContext.init(prop);
				home = initContext.lookup("SdcSeguridad/Afiliacion");
				if (IsDefined("url.sess_pk") and IsDefined("url.uid")) {
					home.create().reautenticar(url.uid,url.sess_pk);
					ret = url.sess_pk;
				} else {
					ret = home.create().autenticar(form.j_username, form.j_password);
				}
			</cfscript>
			<cfif Not IsDefined("ret")><cfthrow message="Usuario o contraseña no válidas" ></cfif>
			<cfquery name="rsUsuario" datasource="#session.DSN#">
				select 
					getdate() as fecha,
					Ulocalizacion, 
					convert(varchar,Usucodigo) as Usucodigo, 
					Usulogin, 
					Pnombre + ' ' + Papellido1 + ' ' + Papellido2 as Pnombre, 
					Ppais, 
					Pid, 
					TIcodigo, 
					Pemail1,
					Usutemporal
				from Usuario
				where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sdc_uid#">
			</cfquery>
			<cfif len(rsUsuario.Usucodigo) GT 0>
				<cfset SESSION.logoninfo = rsUsuario >
				<cfset Session.Usuario=rsUsuario.Usulogin>
				<cfset Session.Usucodigo=rsUsuario.Usucodigo>
				<cfset Session.Ulocalizacion=rsUsuario.Ulocalizacion>
				<cfloginuser name="#sdc_uid#" roles="none" password="#rsUsuario.Usucodigo#">
			<cfelse>
				<cfset SESSION.logoninfo = "empty" >
				<cfset Session.Usuario="">
				<cfset Session.Usucodigo=0>
				<cfset Session.Ulocalizacion="">
				<cflogout>
				<cflocation url="/cfmx/sif/logout/login.cfm?nf=yes&errormsg=1&uri=#JSStringFormat(CGI.SCRIPT_NAME)#">
			</cfif>
			<cfquery name="sdc__prefs__logon" datasource="#session.DSN#">
				select skin_cfm from UsuarioPreferencia
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
			</cfquery>
			<cfparam name="Session.Preferences.Skin" default="ocean">
			<cfparam name="Session.Preferences.SkinMenu" default="ocean">
			<cfif sdc__prefs__logon.RecordCount GT 0 and Len(Trim(sdc__prefs__logon.skin_cfm)) GT 0>
				<cfset Session.Preferences.Skin     = sdc__prefs__logon.skin_cfm>
				<cfset Session.Preferences.SkinMenu = sdc__prefs__logon.skin_cfm>
			</cfif>
			
			<cfcatch type="any"><!---
				<cfsavecontent variable="errormsg">
				<cfoutput>#cfcatch.Message# <cfif IsDefined("cfcatch.Cause.Message")>#cfcatch.Cause.Message#</cfif></cfoutput>
				</cfsavecontent>
				<cflocation url="/cfmx/sif/logout/login.cfm?errormsg=# URLEncodedFormat(errormsg) #">--->
				<cflocation url="/cfmx/sif/logout/login.cfm?errormsg=1&uri=#JSStringFormat(CGI.SCRIPT_NAME)#">
				</cfcatch>
		</cftry>
	<cfelse>
		<cflocation url="/cfmx/sif/logout/login.cfm?uri=#JSStringFormat(CGI.SCRIPT_NAME)#">
	</cfif>
</cflogin></cfif>
