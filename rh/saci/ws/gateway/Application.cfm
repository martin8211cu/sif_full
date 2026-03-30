<cfsilent>
	<!---
		Se invoca desde el event gateway.
		Evitar la validación.
	--->
	<cfset Request.Validar = False>
	<cfinclude template="../Application.cfm">
</cfsilent>