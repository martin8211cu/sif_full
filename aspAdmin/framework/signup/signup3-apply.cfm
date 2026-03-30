<cfparam name="form.logintext" default="">
<cfparam name="form.pregunta" default="">
<cfparam name="form.respuesta" default="">
<cfparam name="form.newpass" default="">
<cfparam name="form.newpass2" default="">

<cfif Len(form.logintext) EQ 0 OR 
      Len(form.newpass)   EQ 0 OR Len(form.newpass2) EQ 0>
	<!--- faltan datos --->
	<cflocation url="signup3.cfm?error=1&logintext=#URLEncodedFormat(form.logintext)#">
<cfelseif form.newpass NEQ form.newpass2>
	<!--- la contraseña no coincide --->
	<cflocation url="signup3.cfm?error=2&logintext=#URLEncodedFormat(form.logintext)#">
</cfif>

<cfquery datasource="sdc" name="repetidos">
	select Usulogin
	from Usuario
	where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.logintext#">
	  and (Usucodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		or Ulocalizacion != <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">) 
</cfquery>
<cfif repetidos.RecordCount GT 0>
	<cflocation url="signup2.cfm?error=2">
</cfif>

<cfquery datasource="sdc">
	update Usuario
	set Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.logintext#">,
	    Usueplogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.logintext#">,
	    Usutemporal = 0
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and Usutemporal = 1
</cfquery>

<!--- Modifica la pregunta de Usuario --->
<cfif Len(form.pregunta) GT 0 AND Len(form.respuesta) GT 0>
	<cfquery datasource="sdc">
		update Usuario
		set Usupregunta  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pregunta#">,
			Usurespuesta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.respuesta#">
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
	</cfquery>
</cfif>

<!--- Realizar cambio de contrasena --->
<cfscript>
	// initial context
	ejbJNDI = 'SdcSeguridad/Afiliacion';
	ejbUser = session.usuario;
	ejbPass = form.oldpass;
	prop = CreateObject("java", "java.util.Properties" );
	initContext = CreateObject("java", "javax.naming.InitialContext" );
	// especificar propiedades, esto se requiere para objetos remotos
	prop.init();
	prop.put(initContext.SECURITY_PRINCIPAL, ejbUser);
	prop.put(initContext.SECURITY_CREDENTIALS, ejbPass);
	initContext.init(prop);
	// ejb lookup
	home = initContext.lookup(ejbJNDI);
	afilia = home.create();
	afilia.renombraUsuario(session.usuario, form.logintext);
	afilia.cambiaPassword(form.logintext, form.newpass);
</cfscript>

<!--- Guardar en bitácora --->
<cfquery datasource="sdc">
	insert UsuarioBitacora (Usucodigo, Ulocalizacion, UBtipo, UBumod, UBfmod, UBdata)
	values (
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
		'PrimerIngreso',
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
		getdate(), 'signup/signup3-apply.cfm')
</cfquery>
<cflocation url="../../logout/logout.cfm">