<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader template="#session.sitio.template#" title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfinclude template="Transacciones-common.cfm">
			<cfif 
				(isdefined("form.GATid") and len(trim(form.GATid)))
				or 
				(isdefined("form.Nuevo") or isdefined("form.btnNuevo"))
				or 
				(isdefined("form.Completar") or isdefined("form.btnCompletar"))>
				<cfinclude template="Transacciones-form.cfm">
			<cfelseif 
				(isdefined("form.GATperiodo") and len(trim(form.GATperiodo)))
				and 
				(isdefined("form.GATmes") and len(trim(form.GATmes)))
				and 
				(isdefined("form.Cconcepto") and len(trim(form.Cconcepto)))
				and 
				(isdefined("form.Edocumento") and len(trim(form.Edocumento)))
				and not
				(isdefined("form.Lista") or isdefined("form.btnLista"))>
				<cfinclude template="Transacciones-lista.cfm">		
			<cfelse>
				<cfinclude template="Transacciones-listadocs.cfm">
			</cfif>
		<cf_web_portlet_end>
<cf_templatefooter>