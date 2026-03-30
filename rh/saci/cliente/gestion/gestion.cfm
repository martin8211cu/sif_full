<cfif Len(session.saci.persona.id) is 0 or session.saci.persona.id is 0>
  <cfthrow message="Usted no está registrado como persona autorizada, por favor verifíquelo.">
</cfif>

<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	
	<cfinclude template="gestion-params.cfm">
	
	<cfif not len(trim(form.cliente))>
 		<cfset form.cliente = session.saci.persona.id>	
		<cfset form.cli = session.saci.persona.id>		
		<cfset ExisteCliente = true>
	</cfif>
	
	<cfinclude template="gestion-principal.cfm">
	
<cf_templatefooter>
