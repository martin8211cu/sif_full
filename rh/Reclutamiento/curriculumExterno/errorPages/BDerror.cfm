<cfif IsDefined("cfcatch")>
	<cfthrow object="#cfcatch#">
<cfelse>
<!--- 	<cfinclude template="/sif/errorPages/BDerror0.cfm"> --->
	<cfinclude template="/sif/errorPages/BDerror1.cfm"> <!--- Compatible para Oracle --->
</cfif>