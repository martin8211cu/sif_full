<cfif isdefined("Session.Compras.Configuracion")>
	<cfset Session.Compras.Configuracion = StructNew()>
	<cfset Session.Compras.Configuracion.Pantalla = 0>
</cfif>
<cflocation url="compraConfig.cfm">