<!--- Se requiere un fuente aparte para el cfadmin de Railo 4, porque en Coldfusion daría error: Tag no existe --->
<cfif LvarCFadmiPWD EQ "">
	<cfadmin 	
		action="getDatasources"
		type="web"
		returnVariable="rsDSN">
<cfelse>
	<cfadmin 	
		action="getDatasources"
		type="web"
		password="#LvarCFadmiPWD#"
		returnVariable="rsDSN">
</cfif>