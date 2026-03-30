<!--- Modifica la pregunta de Usuario --->
<cfif isdefined("form.preg") and form.preg eq 1>
	<cfquery name="upd_pregunta" datasource="sdc">
		update Usuario
		set Usupregunta  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pregunta#">,
			Usurespuesta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.respuesta#">
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
	</cfquery>
</cfif>

<!--- datos incompletos --->
<cfif len(trim(form.oldpass)) eq 0 or len(trim(form.newpass)) eq 0 or len(trim(form.newpass2)) eq 0 >
	<cfset error = 1 >
</cfif>

<!--- EJB --->
<cfif not isdefined("error")>
	<cfset EjbJndi = 'SdcSeguridad/Afiliacion'>
	<cfset user = session.usuario >
	<cfset pass = form.oldpass >

	<cfscript>
		function crearEJB(){
			var home = 0;
			var prop = 0;

			// initial context
			prop = CreateObject("java", "java.util.Properties" );
			initContext = CreateObject("java", "javax.naming.InitialContext" );

			// especificar propiedades, esto se requiere para objetos remotos
			prop.init();
			prop.put(initContext.SECURITY_PRINCIPAL, user);
			prop.put(initContext.SECURITY_CREDENTIALS, pass);
			initContext.init(prop);
			
			// ejb lookup
			home = initContext.lookup(EjbJndi);
			
			// global var, reuse
			afilia = home.create();
			
			return afilia;
		}					
	</cfscript>
</cfif>

<!--- cambia el password --->
<cftry>
	<cfset crearEJB().cambiaPassword(session.usuario, form.newpass) >
<cfcatch type="any">
	<cfset error = 2 >
</cfcatch>
</cftry>	

<cfif not isdefined("error")>
	<cflocation url="/cfmx/sif/logout/logout.cfm">
</cfif>


<cfoutput>
<form action="passch.cfm" method="post" name="sql">
	<cfif isdefined("error")>
		<input name="error" type="hidden" value="#error#">
	</cfif>
</form>
</cfoutput>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>