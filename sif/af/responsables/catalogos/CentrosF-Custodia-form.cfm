<!---  --->
<cfset modo = "ALTA">


<form action="CentrosF-Custodia.cfm" method="post" name="form1">
	<cfif modo eq "ALTA">
		<cf_botones modo="alta" exclude="limpiar">
	<cfelse>
		<cf_botones modo="baja" exclude="limpiar">
	</cfif>
</form>