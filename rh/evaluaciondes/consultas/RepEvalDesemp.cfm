<!--- <cf_dump var="#form#"> --->

<cfif form.Tipo eq  1>
	<cfinclude template="RepEvalDesempR.cfm">
<cfelse>
	<cfinclude template="RepEvalDesempD.cfm">
</cfif>