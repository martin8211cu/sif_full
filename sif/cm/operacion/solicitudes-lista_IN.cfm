<cfset url.SC_INV = true>
<cfif session.compras.solicitante EQ "">
	<cf_errorCode	code = "50325" msg = "Usuario debe ser Solicitante de Compras">
</cfif>
<cfinclude template="solicitudes-lista.cfm">


