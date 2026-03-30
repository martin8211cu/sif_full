<cfparam name="modo" default="CAMBIO">

<cftry>
	<cfif not isdefined("form.Nuevo") >
		<cfif isdefined("form.CAMBIO") >
			<cfquery name="abc_usuario" datasource="sdc">
				set nocount on
				update Usuario
				set	  Pnombre		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
					  Papellido1	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">, 
					  Papellido2	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">, 
					  TIcodigo		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.TIcodigo#">, 
					  Pid			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					  Psexo			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Psexo#">, 
					  Pnacimiento	= convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnacimiento#">,103),
					  Pdireccion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
					  Ppais			= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
					  Poficina		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">, 
					  Pcelular		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">, 
					  Pcasa			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					  Pfax			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
					  Ppagertel		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagertel#">,
					  Ppagernum		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagernum#">,
					  Pemail1		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
					  Pemail2		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">
				where Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
				set nocount off
			</cfquery>
	
			<cfquery name="abc_skin" datasource="sdc">
				set nocount on
				update UsuarioPreferencia 
				set skin_cfm = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.skin_cfm#">
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
				
				if @@rowcount=0
					insert UsuarioPreferencia (skin_cfm, Usucodigo, Ulocalizacion) 
					values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.skin_cfm#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
							) 
				set nocount off
			</cfquery>
			<cfset session.preferences.skin = form.skin_cfm>
			<cfset session.preferences.skinmenu = form.skin_cfm>
		</cfif>
	</cfif>
<cfcatch type="database">
	<cfinclude template="/aspAdmin/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

<cfoutput>
<form action="Usuario.cfm" method="post">
	<input type="hidden" name="modo" value="#modo#">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>