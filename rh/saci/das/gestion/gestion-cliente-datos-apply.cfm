<cfinclude template="gestion-params.cfm">

<cfif isdefined("Form.Guardar")>
	<cfinclude template="/saci/vendedor/venta/venta-cliente-app.cfm">
</cfif>

<cfinclude template="gestion-redirect.cfm">