<cfif isdefined("Session.Compras.Solicitantes")>
	<cfset Session.Compras.Solicitantes = StructNew()>
	<cfset Session.Compras.Solicitantes.Pantalla = 0>
</cfif>
<cflocation url="solicitantes.cfm">