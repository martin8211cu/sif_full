<!--- Query para obtener el nombre del Administrador que está logueado en el Portal --->
<cfset cuenta = "">
<cfset titulo = "">

<cfif not isdefined("Session.Progreso")>
	<cfset Session.Progreso = StructNew()>
</cfif>

<cfset pagina = #GetFileFromPath(GetTemplatePath())#>
<cfif pagina EQ "Cuentas.cfm">
	<cfset Session.Progreso.Pantalla = "1">
<cfelseif pagina EQ "Modulos.cfm">
	<cfset Session.Progreso.Pantalla = "1a">
<cfelseif pagina EQ "Caches.cfm">
	<cfset Session.Progreso.Pantalla = "1b">
<cfelseif pagina EQ "CuentaAutentica.cfm">
	<cfset Session.Progreso.Pantalla = "1c">
<cfelseif pagina EQ "Empresas.cfm">
	<cfset Session.Progreso.Pantalla = "2">
<cfelseif pagina EQ "Usuarios.cfm">
	<cfset Session.Progreso.Pantalla = "3">
<cfelseif pagina EQ "Permisos.cfm">
	<cfset Session.Progreso.Pantalla = "4">
</cfif>

<!--- Cuenta Empresarial Seleccionada --->
<cfif acceso_uri('/asp/catalogos/Cuentas.cfm')>
	<cfif isdefined("Form.CEcodigo") and Len(Trim(Form.CEcodigo)) NEQ 0>
		<cfset Session.Progreso.CEcodigo = Form.CEcodigo>
	</cfif>
<cfelse>
	<cfset Session.Progreso.CEcodigo = Session.CEcodigo>
</cfif>

<cfif isdefined("Session.Progreso") and isdefined("Session.Progreso.CEcodigo") and Len(Trim(Session.Progreso.CEcodigo)) NEQ 0>
	<cfquery name="rsCuenta" datasource="asp">
		select CEnombre
		from CuentaEmpresarial
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
	</cfquery>
	<cfset cuenta = rsCuenta.CEnombre>
</cfif>
