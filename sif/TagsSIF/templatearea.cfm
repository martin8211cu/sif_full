<cfparam name="Attributes.name" default="body">

<cfif ThisTag.ExecutionMode IS 'Start' AND ThisTag.HasEndTag IS 'YES'>
	
<cfelse>
	<!---
		Transferir el contenido del area al tag padre para
		que lo pueda reemplazar en el contenido
	--->
	<cfset Attributes.contents = ThisTag.GeneratedContent>
	<cfset ThisTag.GeneratedContent = "">
	<cfassociate basetag="cf_template" datacollection="areas">
</cfif>