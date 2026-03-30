<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	
	<cfinclude template="gestion-params.cfm">
	<cfset pasaXprimeravez =0>
	<cfif not len(trim(form.rol))>
		<cfset pasaXprimeravez =1>
		<cfset form.rol = 2>			<!---Rol de agente = 2--->
	</cfif>
	<cfif form.rol EQ 2 and pasaXprimeravez EQ 1>
		<cfinclude template="clientes-busqueda.cfm">
	<cfelse>
		<cfif isdefined("form.personaID") and len(trim(form.personaID))>
			<cfif not len(trim(form.cliente))>
				<cfset form.cliente=form.personaID>	
				<cfset form.cli=form.personaID>	
			</cfif>
		</cfif>
		<cfinclude template="gestion-principal.cfm">
	</cfif>
	
	
<cf_templatefooter>
