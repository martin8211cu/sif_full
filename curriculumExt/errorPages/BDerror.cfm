<cfif IsDefined("cfcatch")>
	<cfthrow object="#cfcatch#">
<cfelse>
<!--- 	<cfinclude template="/errorPages/BDerror0.cfm"> --->
	<cfinclude template="/errorPages/BDerror1.cfm"> <!--- Compatible para Oracle --->
</cfif>