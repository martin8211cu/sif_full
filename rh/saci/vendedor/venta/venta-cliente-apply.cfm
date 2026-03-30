<cfinclude template="venta-params.cfm">

<cfif isdefined("Form.Guardar")>
	<cfinclude template="venta-cliente-app.cfm">
<cfelseif isdefined("Form.Eliminar")>
	<cfinclude template="venta-cliente-borrado.cfm">
</cfif>

<cfinclude template="venta-redirect.cfm">
