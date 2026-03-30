<cf_templateheader title="Reportes de Documentos de Presupuesto">
	<cf_web_portlet_start titulo="Reportes de Documentos de Presupuesto">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cfif isdefined("form.CPTpoRep") and Len(Trim(form.CPTpoRep))>
			<cfset form.CPTpoRep = form.CPTpoRep>
		<cfelse>
			<cfset form.CPTpoRep = "RE">
		</cfif>
		<cfinclude template="rptDocsPRES-filtros.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>