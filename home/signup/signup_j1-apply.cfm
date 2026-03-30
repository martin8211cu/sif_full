<cfparam name="form.loginex" default="">
<cfparam name="form.passwdex" default="">

<cfif Len(form.loginex) EQ 0 or Len(form.passwdex) EQ 0>
	<cflocation url="signup_j1.cfm?error=1">
</cfif>
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

<cfset AUTHBACKEND = sec.autenticar(session.CEcodigo, form.loginex, form.passwdex)>
<cfif Len(AUTHBACKEND) IS 0>
	<!--- Thread.sleep(10000); // Esperar diez segundos entre cada intento de autenticacion --->
	<cflocation url="signup_j1.cfm?error=2">
</cfif>
<!--- 
	usuario / passwd ok
	unificar usuarios
--->
<cfquery datasource="asp" name="existente">
	select Usucodigo
	from Usuario
	where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.loginex#" >
	  and Utemporal = 0
	  and Uestado = 1
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
</cfquery>
<cfif existente.RecordCount EQ 0>
	<cflocation url="signup_j1.cfm?error=3">
<cfelse>
	<!---
		Renombrar el usuario en framework
		el siguiente cfm requiere de las variables "existente" y "data", ambas con Usucodigo y Ulocalizacion
	--->
	<cfset data = session>
	<cfinclude template="signup_unificar.cfm">
	<cfset session.autoafiliado = existente.Usucodigo>
	<cflocation url="/cfmx/home/index.cfm">
</cfif>
