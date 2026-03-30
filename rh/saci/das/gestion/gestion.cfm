<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	
	<cfif isdefined("form.personaID") and len(trim(form.personaID))>
		<cfset form.cliente = form.personaID>	
		<cfset form.cli = form.personaID>	
	</cfif>
	
	<cfinclude template="gestion-params.cfm">
	
	<cfset pasaXprimeravez = false>
	<cfif not len(trim(form.cliente))>
		<cfset pasaXprimeravez = true>
		<cfset form.rol = "DAS">
	</cfif>
	
	<cfif form.rol EQ "DAS" and pasaXprimeravez EQ true>
		<cfinclude template="clientes-busqueda.cfm">
	<cfelse>
		<cfinclude template="gestion-principal.cfm">
	</cfif>
	
<cf_templatefooter>
