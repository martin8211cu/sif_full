<cfparam name="form.loginex" default="">
<cfparam name="form.passwdex" default="">

<cfif Len(form.loginex) EQ 0 or Len(form.passwdex) EQ 0>
	<cflocation url="signup_j1.cfm?error=1">
</cfif>
<cftry>
	<cfscript>
		// initial context
		ejbJNDI = 'SdcSeguridad/Afiliacion';
		ejbUser = form.loginex;
		ejbPass = form.passwdex;
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
		afilia.autenticar(ejbUser, ejbPass);
	</cfscript>
	<cfcatch type="any">
		Thread.sleep(10000); // Esperar diez segundos entre cada intento de autenticacion
		<cflocation url="signup_j1.cfm?error=2">
	</cfcatch>
</cftry>
<!--- 
	usuario / passwd ok
	unificar usuarios
--->
<cfquery datasource="sdc" name="existente">
	select Usucodigo, Ulocalizacion
	from Usuario
	where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.loginex#" >
	  and Usutemporal = 0
	  and activo = 1
</cfquery>
<cfif existente.RecordCount EQ 0>
	<cflocation url="signup_j1.cfm?error=3">
<cfelse>
	<!---
		Renombrar el usuario en framework
		el siguiente cfm requiere de las variables "existente" y "data", ambas con Usucodigo y Ulocalizacion
	--->
	<cfset data = session>
	<cfinclude template="../afiliacion/recibo/recibo_unificar.cfm">
</cfif>
<!--- inactivar password anterior --->
<cfset afilia.inhabilitarUsuario(session.usuario, false) >
<cflocation url="../../logout/logout.cfm">