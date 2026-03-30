<!--- Query para obtener el nombre del Administrador que está logueado en el Portal --->
<!--- <cfset Session.DSN = "asp"> --->
<cfset cuenta = "">
<cfset titulo = "">

<cfif not isdefined("Session.Progreso")>
	<cfset Session.Progreso = StructNew()>
</cfif>

<cfset pagina = #GetFileFromPath(GetTemplatePath())#>
<cfif pagina EQ "Proyecto.cfm">
	<cfset Session.Progreso.Pantalla = "1">
<cfelseif pagina EQ "Equipos.cfm">
	<cfset Session.Progreso.Pantalla = "2">
<cfelseif pagina EQ "expediente.cfm">
	<cfset Session.Progreso.Pantalla = "3">
<!--- <cfelseif pagina EQ "Permisos.cfm">
	<cfset Session.Progreso.Pantalla = "4"> --->
</cfif>

<!--- Cuenta Empresarial Seleccionada --->
<cfif isdefined("Form.CEcodigo") and Len(Trim(Form.CEcodigo)) NEQ 0>
	<cfset Session.Progreso.CEcodigo = Form.CEcodigo>
</cfif>
<cfif isdefined("Session.Progreso") and isdefined("Session.Progreso.CEcodigo") and Len(Trim(Session.Progreso.CEcodigo)) NEQ 0>
	<cfquery name="rsCuenta" datasource="asp">
		select CEnombre
		from CuentaEmpresarial
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
	</cfquery>
	<cfset cuenta = rsCuenta.CEnombre>
</cfif>
